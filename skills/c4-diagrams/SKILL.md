---
name: c4-diagrams
description: Turns a design written in Structurizr DSL into C4 diagram images (PNG, optional SVG) that look right in Claude Docs and in PDF and Word exports. Use for C4 System Context, Container or Component diagrams, "draw the architecture", "Structurizr", "C4 model", or diagrams for an interview architecture assignment, a SAD or an RFP response.
---

# C4 Diagrams (Structurizr DSL → images)

You describe the design once, as **Structurizr DSL**. This skill renders every view in it to an image. The images are made for documents: PNG at 200 dpi, white background, title on top and a key (legend) inside the picture. They show the same in Claude Docs, in a PDF export and in a Word export.

This skill is the drawing tool for the C4 rules in `ea-practice/rfp-pursuit-guide.md` (section "C4 diagram conventions"). Follow those rules when you write the DSL.

## Workflow

```
- [ ] Step 1: Check the tools (ask the user before the first run)
- [ ] Step 2: Write or update the DSL
- [ ] Step 3: Render
- [ ] Step 4: Look at every image
- [ ] Step 5: Put the images in the document
```

---

### Step 1 — Check the tools

The renderer needs two command line tools. **The user installs them with Homebrew on their Mac. Never install them yourself.**

```bash
brew install structurizr plantuml     # plantuml also brings graphviz and openjdk
```

Before you run any of these tools for the first time in a session, **ask the user for permission** and say which commands you will run (`structurizr`, `plantuml`, `python3`). Then check:

```bash
command -v structurizr || command -v structurizr-cli   # either one is fine
command -v plantuml
command -v dot        # optional; without it the layout is a little worse
```

If a tool is missing, stop and give the user the `brew install` line above. Do not try another way to install it.

**Where the commands run:**

| Where you are | What to do |
|---|---|
| Claude Code or Cowork on the user's Mac | Run `scripts/render.sh` directly. The normal permission prompt is the user's approval. |
| A cloud session (for example a project thread) with access to the user's Mac | Ask the user, then start a Remote Control session on the Mac to run `render.sh`. The images are written into the user's folder. Bring them into the cloud with the folder tools when you need to upload them to Claude Docs. |
| A sandbox without Homebrew (fallback only) | Download the jars once with Maven and set `C4_JARS` (see "Fallback without Homebrew" at the end). |

---

### Step 2 — Write the DSL

Start from `examples/workspace.dsl`. Keep one `workspace.dsl` per assignment, next to the document, for example `pursuits/<client>-<slug>/Phase2/diagrams/workspace.dsl` or `assignments/<name>/diagrams/workspace.dsl`.

Rules (they come from the pursuit guide):

1. **Every element has three things:** a name (a noun), a description (one sentence) and, for containers and components, a technology. Example: `container "API Application" "Provides banking features over JSON/HTTPS." "Java, Spring Boot"`.
2. **Technology names match the SAD exactly.** If the SAD says "Azure API Management", the DSL says "Azure API Management".
3. **Mark external systems** with the tag `"External"`. They are drawn grey. Everything inside the system boundary is in scope.
4. **No "TBD" boxes.** If the product is not chosen yet, use the ABB name and the technology `"Technology TBC — pending Q-NNN"`.
5. **One view per C4 level you need:** C1 System Context (always), C2 Container (almost always), C3 Component (only when it adds value). No C4 Code level.
6. **Give every view a key and a title** in this form: `<System Name> — System Context Diagram` / `Container Diagram` / `Component Diagram`. The key becomes the image file name. Use `C1-Context`, `C2-Container`, `C3-<Container>-Components`.
7. **Use `autoLayout tb`** (top to bottom). Word and PDF pages are portrait; `lr` makes wide, small pictures.
8. **Keep each view to about 12 boxes or fewer.** Bigger views become too small to read on an A4 page. Split them, or use `include` / `exclude`.
9. **Keep the `styles` block from the example.** It gives the standard C4 colours, a person shape, a database cylinder and grey external systems.

Check the DSL quickly before rendering: every relationship has a label, and every view has `include *` (or a clear include list) and `autoLayout`.

---

### Step 3 — Render

```bash
<skill-folder>/scripts/render.sh path/to/workspace.dsl [output-folder] [--dpi 200] [--svg] [--no-legend]
```

- Default output folder: `diagrams/` next to the DSL file.
- You get one `<view-key>.png` per view. `--svg` adds SVG files too.
- The PlantUML sources are kept in `<output>/puml/` to help you find problems.

What the script does:

1. `structurizr export -format plantuml/structurizr` → one PlantUML file per view.
2. `fix_puml.py` → keeps only your view title, makes the boundary label readable, adds the key, sets 200 dpi and a white background.
3. `plantuml -tpng` → the images.

**Which file type to use:**

| Target | Use |
|---|---|
| Claude Docs (and its PDF and Word exports) | **PNG** |
| A Word file you build yourself (docx skill) | PNG |
| A Markdown file that is converted to Word or PDF | PNG, linked with a relative path: `![Container diagram](diagrams/C2-Container.png)` |
| A web page, or when the user asks for vector | SVG |

PNG is the safe choice. Some Word versions and some converters do not show SVG.

---

### Step 4 — Look at every image

Open each PNG and look at it before you hand it over. Check:

- The title is the one you set, and there is a key.
- No box or label is cut off at the edge.
- Labels can be read when the image is about 16 cm wide (an A4 page). If not: fewer elements, `autoLayout tb`, or shorter descriptions.
- External systems are grey and outside the boundary.
- Technology labels match the SAD.

Fix the DSL and render again until it is right.

---

### Step 5 — Put the images in the document

**Claude Docs**

1. Write the section text first: the heading and one paragraph that says what the diagram shows **and what it leaves out** (pursuit guide rule). Upload images only when no pending section is left.
2. Upload the PNG files to the doc's artifact with the Artifact tool: `publish` with the doc's `url`, `asset: true` and `file_paths`. You get one asset id (32 hex characters) per file.
3. Create one blob per image in the doc: `batch` with members `{"verb":"create","object":"blob","engine":"blob","payload":{"asset":"<asset id>"}}`. Each returns a blob id.
4. Insert the image right after the section heading: markdown `![<diagram title>](blob/<blob id>)`.
5. When you change the DSL later, render again and upload again. A blob cannot change, so replace the old image with the new blob.

Tested: images added this way show in the doc and stay sharp in the PDF export (A4) and in the Word export, where they are sized to the page width.

**Word file made with the docx skill:** insert the PNG at 16 cm wide.

**Markdown working files:** link the PNG with a relative path (see the table in Step 3). Keep `workspace.dsl` next to it, so the next person can change the design.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `structurizr is not installed` | The user runs `brew install structurizr plantuml`. |
| DSL error with a line number | Fix that line. Common: a style written on one line (`element "X" { background #fff }`) — put each property on its own line. |
| `No structurizr-*.puml files` | The workspace has no `views` block, or no view includes elements. |
| Image is cut off | `render.sh` sets `PLANTUML_LIMIT_SIZE=16384`. If you call PlantUML yourself, set it too, or lower `--dpi`. |
| Lines cross a lot | Install Graphviz (`brew install graphviz`), use `autoLayout tb`, or split the view. |
| Boundary label is white or missing | Render again with `render.sh`; `fix_puml.py` fixes this. |

## Fallback without Homebrew (sandboxes only)

Use this only where the user's Mac is not involved, for example a cloud sandbox for a quick preview. You need Java 17+, Maven and Python 3.

```bash
mkdir -p ~/.c4-jars && cd ~/.c4-jars
cat > pom.xml <<'POM'
<project xmlns="http://maven.apache.org/POM/4.0.0"><modelVersion>4.0.0</modelVersion>
<groupId>local</groupId><artifactId>c4-jars</artifactId><version>1</version>
<dependencies>
<dependency><groupId>com.structurizr</groupId><artifactId>structurizr-dsl</artifactId><version>6.2.4</version></dependency>
<dependency><groupId>com.structurizr</groupId><artifactId>structurizr-export</artifactId><version>6.2.4</version></dependency>
<dependency><groupId>net.sourceforge.plantuml</groupId><artifactId>plantuml-mit</artifactId><version>1.2026.9</version></dependency>
</dependencies></project>
POM
mvn -q dependency:copy-dependencies -DoutputDirectory=lib
C4_JARS=~/.c4-jars/lib <skill-folder>/scripts/render.sh workspace.dsl
```

`scripts/C4Export.java` then does the job of `structurizr export`. Without Graphviz the script uses PlantUML's built-in layout.

## Files

| File | Purpose |
|---|---|
| `scripts/render.sh` | Main script: DSL → PlantUML → PNG/SVG |
| `scripts/fix_puml.py` | Makes the PlantUML ready for documents (title, key, dpi, boundary label) |
| `scripts/C4Export.java` | Fallback exporter when the `structurizr` command is not installed |
| `examples/workspace.dsl` | Starting template with C1, C2 and C3 views and the standard styles |
