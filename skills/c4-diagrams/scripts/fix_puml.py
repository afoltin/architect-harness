#!/usr/bin/env python3
"""Make Structurizr's PlantUML export ready for documents.

For every structurizr-<view>.puml file in a folder:
  * keep only the custom view title (not "Container View: X" + title),
  * make boundary labels readable (text colour = line colour),
  * add a legend (key) inside the diagram, built from the styles in use,
  * set the resolution (dpi) for sharp images in Word and PDF,
  * switch to the built-in layout engine when Graphviz is not installed.
Writes <view>.puml next to it. Uses only the Python standard library.
"""
import re, shutil, sys
from pathlib import Path

BASE_TYPES = ["Person", "Software System", "Container", "Component",
              "Deployment Node", "Infrastructure Node", "Container Instance",
              "Software System Instance", "Group", "Element"]


def legend_label(tags):
    tags = [t.strip() for t in tags.split(",") if t.strip()]
    base = next((t for t in reversed(tags) if t in BASE_TYPES and t != "Element"), "Element")
    extra = [t for t in tags if t not in BASE_TYPES]
    return f"{base} ({', '.join(extra)})" if extra else base


def prop(body, name):
    m = re.search(rf"\b{name}:\s*([^;]+);", body)
    return m.group(1).strip() if m else None


def fix(src, dpi, smetana, legend):
    # 1. Title: Structurizr writes "<size:24>View name</size>\n<size:24>Custom title</size>"
    def title(m):
        parts = re.findall(r"<size:\d+>(.*?)</size>", m.group(1))
        keep = parts[-1] if parts else m.group(1)
        return f"title <size:24>{keep}</size>"
    src = re.sub(r"^title (.*)$", title, src, count=1, flags=re.M)

    # 2. Styles: collect element styles, fix boundary font colour.
    styles = {}
    def style(m):
        comment, cls, body = m.group(1), m.group(2), m.group(3)
        if cls.startswith("Boundary-") or cls.startswith("Group-"):
            line = prop(body, "LineColor")
            if line:
                body = re.sub(r"FontColor:\s*[^;]+;", f"FontColor: {line};", body)
        if cls.startswith("Element-"):
            styles[cls] = (comment, prop(body, "BackgroundColor"), prop(body, "FontColor"), prop(body, "LineColor"))
        return f"  // {comment}\n  .{cls} {{{body}}}"
    src = re.sub(r"  // ([^\n]*)\n  \.([A-Za-z]+-[A-Za-z0-9+/=]+) \{(.*?)\}", style, src, flags=re.S)

    # 3. Legend built from the element styles that the diagram actually uses.
    if legend:
        body_part = src.split("</style>", 1)[-1]
        used = [c for c in styles if f"<<{c}>>" in body_part]
        rows, seen = [], {}
        for c in used:  # one row per colour; shapes already show the variant
            tags, bg, fg, _ = styles[c]
            label = legend_label(tags)
            key = (bg, fg)
            if key not in seen or len(label) < len(seen[key]):
                seen[key] = label
        for (bg, fg), label in seen.items():
            rows.append(f"|<{bg or '#ffffff'}> <color:{fg or '#000000'}><size:18> {label} </size></color> |")
        boundary = re.search(r"\.Boundary-[^{]+\{([^}]*)\}", src)
        if boundary:
            lc = prop(boundary.group(1), "LineColor") or "#444444"
            rows.append(f"|<#ffffff> <color:{lc}><size:18> Boundary = in scope </size></color> |")
        if "-->" in body_part:
            rows.append("|<#ffffff> <color:#444444><size:18> - - -> Relationship </size></color> |")
        if rows:
            leg = "legend right\n<size:18><b>Key</b></size>\n" + "\n".join(rows) + "\nendlegend\n"
            src = src.replace("@enduml", leg + "@enduml", 1)

    # 4. Header: resolution, white background, optional layout engine.
    head = f"skinparam dpi {dpi}\nskinparam backgroundColor #FFFFFF\n"
    if smetana:
        head = "!pragma layout smetana\n" + head
    src = re.sub(r"^@startuml[^\n]*\n", lambda m: m.group(0) + head, src, count=1)
    return src


def main():
    folder = Path(sys.argv[1])
    dpi = int(sys.argv[2]) if len(sys.argv) > 2 else 200
    legend = "--no-legend" not in sys.argv
    smetana = shutil.which("dot") is None
    if smetana:
        print("note: Graphviz 'dot' not found, using PlantUML's built-in layout (smetana)")
    files = sorted(folder.glob("structurizr-*.puml"))
    files = [f for f in files if not f.name.endswith("-key.puml")]
    if not files:
        sys.exit(f"No structurizr-*.puml files in {folder}. Does the workspace have a 'views' block?")
    for f in files:
        out = folder / (f.name[len("structurizr-"):])
        out.write_text(fix(f.read_text(encoding="utf-8"), dpi, smetana, legend), encoding="utf-8")
        print(f"prepared {out.name}")


if __name__ == "__main__":
    main()
