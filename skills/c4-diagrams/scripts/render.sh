#!/usr/bin/env bash
# Render every view in a Structurizr DSL workspace to PNG (and optionally SVG).
#
# Usage: render.sh <workspace.dsl> [output-dir] [--dpi N] [--svg] [--no-legend]
#
# Tools (install on macOS with Homebrew):
#   brew install structurizr plantuml      # plantuml also installs graphviz and openjdk
# Fallback for machines without Homebrew: set C4_JARS to a folder that holds the
# structurizr-dsl, structurizr-export and plantuml jars (see SKILL.md).
set -euo pipefail

usage() { sed -n '2,10p' "$0"; exit 2; }
[ $# -ge 1 ] || usage
DSL=""; OUT=""; DPI=200; SVG=0; LEGEND=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dpi) DPI="$2"; shift 2 ;;
    --svg) SVG=1; shift ;;
    --no-legend) LEGEND="--no-legend"; shift ;;
    -h|--help) usage ;;
    *) if [ -z "$DSL" ]; then DSL="$1"; else OUT="$1"; fi; shift ;;
  esac
done
[ -f "$DSL" ] || { echo "error: workspace file not found: $DSL" >&2; exit 2; }

HERE="$(cd "$(dirname "$0")" && pwd)"
DSL_ABS="$(cd "$(dirname "$DSL")" && pwd)/$(basename "$DSL")"
OUT="${OUT:-$(dirname "$DSL_ABS")/diagrams}"
mkdir -p "$OUT"; OUT="$(cd "$OUT" && pwd)"
PUML="$OUT/puml"; rm -rf "$PUML"; mkdir -p "$PUML"

missing() {
  cat >&2 <<MSG
error: $1 is not installed.
On macOS install the tools with Homebrew (the user does this, not the agent):
    brew install structurizr plantuml
Then run this script again.
MSG
  exit 3
}

# 1. Structurizr DSL -> PlantUML (one file per view)
if command -v structurizr >/dev/null 2>&1; then
  structurizr export -workspace "$DSL_ABS" -format plantuml/structurizr -output "$PUML"
elif command -v structurizr-cli >/dev/null 2>&1; then
  structurizr-cli export -workspace "$DSL_ABS" -format plantuml/structurizr -output "$PUML"
elif [ -n "${C4_JARS:-}" ]; then
  java -cp "$C4_JARS/*" "$HERE/C4Export.java" "$DSL_ABS" "$PUML"
else
  missing "the Structurizr command ('structurizr')"
fi

# 2. Fix titles, boundary labels, legend and resolution
python3 "$HERE/fix_puml.py" "$PUML" "$DPI" $LEGEND

# 3. PlantUML -> images
if command -v plantuml >/dev/null 2>&1; then
  PLANTUML=(plantuml)
elif [ -n "${C4_JARS:-}" ] && ls "$C4_JARS"/plantuml*.jar >/dev/null 2>&1; then
  PLANTUML=(java -Djava.awt.headless=true -jar "$(ls "$C4_JARS"/plantuml*.jar | head -1)")
else
  missing "PlantUML ('plantuml')"
fi
export PLANTUML_LIMIT_SIZE=16384   # large diagrams at high dpi are cut off without this
FILES=()
for f in "$PUML"/*.puml; do case "$(basename "$f")" in structurizr-*) ;; *) FILES+=("$f") ;; esac; done
"${PLANTUML[@]}" -tpng -o "$OUT" "${FILES[@]}"
if [ "$SVG" = 1 ]; then
  # SVG is resolution-independent; drop the dpi line so sizes stay normal
  for f in "${FILES[@]}"; do sed -i.bak '/^skinparam dpi /d' "$f" && rm -f "$f.bak"; done
  "${PLANTUML[@]}" -tsvg -o "$OUT" "${FILES[@]}"
fi

echo "Images written to $OUT:"
ls -1 "$OUT" | grep -E '\.(png|svg)$' | sed 's/^/  /'
