---
name: assignment-deliverable
description: Step 3 of an interview architecture assignment. Writes the document (PDF or Word) and, if asked, the slides from the design files, sized for the reader and the time budget, then runs the final quality check. Use when "write the assignment document", "make the slides for my assignment", "check my draft", or "is it ready to hand in" is asked.
---

# Assignment Deliverable

Step 3 of 4. Reads `intake.md` and `design/`, and writes `deliverable/`. Then `assignment-defence` prepares the presentation.

## Before you start

1. Read `intake.md`: deliverable type and file type (question 3), page or slide limit (4), main reader (5), presentation length (6), mode (8).
2. Check that `design/decisions.md`, `design/solution.md` and the diagrams exist. If not, go back to `assignment-design`.
3. Check the time plan. Writing and review together are about 40% of the budget.

**Coach mode:** the user writes. You give the outline, ask what each section must say, and review drafts with the checklist in Step 6. Do not write sentences for the deliverable.

## Writing rules

- **Plain English.** Short sentences. One idea per paragraph. Explain each abbreviation the first time.
- **No TOGAF ceremony.** No ADM headers, no ABB/SBB tables. TOGAF words only if the company uses them.
- **Answer first.** Each section starts with its conclusion, then the reasons.
- **Every claim has a reason**, and every reason links back to the brief, a requirement or an assumption.
- **Say what you left out and why.** Use the scope contract.
- **Vendor-neutral** unless the brief names a vendor.

## Workflow

```
- [ ] Step 1: Choose the length
- [ ] Step 2: Outline (adapted to the reader)
- [ ] Step 3: Write the document
- [ ] Step 4: Make the slides (only if asked)
- [ ] Step 5: Produce the files (PDF / Word / PowerPoint)
- [ ] Step 6: Final check
```

---

### Step 1 — Choose the length

If there is a page limit, it wins. If not, use this guide:

| Main reader | Main part | Appendix |
|---|---|---|
| Hiring manager or CTO | 8–12 pages | Decision records, extra diagrams |
| Enterprise or Solution Architect | 12–18 pages | Decision records, flows, quality check |

Longer is not better. If the draft goes over, cut depth, not sections: move detail to the appendix.

---

### Step 2 — Outline

Default outline. Drop or merge sections that the scope contract marks out of scope.

1. **Summary** (one page, stands alone): the problem, the solution idea, the 3–5 key decisions in one line each, the main risk, what you recommend next.
2. **The problem and the scope**: what the brief asks (in your words), what this solution covers, what it does not cover and why.
3. **Requirements and assumptions**: the requirements that drive the design, the key assumptions with numbers.
4. **Solution overview**: the solution idea and the C1 System Context diagram.
5. **Architecture**: the C2 Container diagram, what each part does, the key flows.
6. **Key decisions**: one short paragraph per decision (choice, why, what we give up). Full records in the appendix.
7. **Quality, security and data protection**: how the design meets the quality requirements; the security approach.
8. **Migration or roll-out** (if in scope): the stages.
9. **Risks**: the risk table.
10. **Cost and effort** (only if the brief asks).
11. **Next steps and open questions**: what you would do first, and the questions you would ask the company.
- **Appendix**: decision records, extra flows, glossary.

Change the weight for the main reader:

| Main reader | Give more space to | Give less space to |
|---|---|---|
| Hiring manager | Summary, problem, decisions in plain words, next steps | Technical detail |
| CTO | Decisions, risks, cost of being wrong, roadmap | Component detail |
| Enterprise Architect | Fit with the landscape, standards, migration, principles | Code-level detail |
| Solution Architect | Architecture, flows, quality check, integration | Business background |

Show the outline, with a page budget per section, to the user before writing.

---

### Step 3 — Write the document

Write the source in Markdown at `deliverable/document.md`, section by section, from the design files. Do not invent new design here. If a gap shows up, fix it in `design/` first.

**Rules so that it looks right in both PDF and Word:**

| Do | Do not |
|---|---|
| Headings level 1–3 only | Deeper heading levels |
| Simple tables, at most 5 columns, short cell text | Merged cells, nested tables, wide tables |
| Diagrams as PNG from `c4-diagrams`, linked with a relative path, full page width (about 16 cm) | SVG, Mermaid, PlantUML code blocks, screenshots of whiteboards |
| A caption under each diagram, and one paragraph saying what it shows and what it leaves out | A diagram that is never mentioned in the text |
| Numbered and bulleted lists, one level deep | Lists nested more than two levels |
| Plain characters: Met / Partly / Not met | Emoji and special symbols (✅ ❌ ⚠️); they break in some PDF fonts |
| Bold for key words | Coloured text, HTML tags |

---

### Step 4 — Make the slides (only if asked)

Only if intake question 3 says slides. The presentation is based on the document, so the slides follow the document.

For a one-hour session, plan about 30 minutes of talk and 30 minutes of questions:

| Slides | Content |
|---|---|
| 1 | Title |
| 1 | The problem and what they asked |
| 1 | Scope: in and out |
| 1 | Key requirements and assumptions |
| 1 | Solution idea + C1 diagram |
| 1–2 | C2 diagram and one key flow |
| 3–5 | One slide per key decision: choice, why, what we give up |
| 1 | Quality and security |
| 1 | Migration stages (if in scope) |
| 1 | Top risks |
| 1 | Next steps and open questions |

About 12–15 slides. One message per slide, written as the slide title (a full sentence, for example "We keep billing on-premise and connect it with events"). Put the details in the speaker notes, not on the slide.

Make the slides with the Slides artifact type if the session offers it (it exports to PowerPoint and PDF), otherwise with the `pptx` skill. Use the same PNG diagrams as the document.

---

### Step 5 — Produce the files

Use the first route that works:

1. **Claude Docs** (if available): create the doc from `document.md`, add the diagrams as described in `c4-diagrams` Step 5, then export to PDF or Word.
2. **`docx` skill**: build the Word file from `document.md`, diagrams at 16 cm wide. Make the PDF from the Word file.
3. **pandoc on the user's Mac**: only if the user has installed it (`brew install pandoc`) and agrees. Ask before the first run.

Save the final files in `deliverable/` with the name the company expects, or `<YourName>-<Company>-Solution-Architecture.pdf`.

**Open the final PDF or Word file and look at every page.** Check that diagrams are sharp and not cut off, tables fit the page, and no symbol is broken.

---

### Step 6 — Final check

Go through this list and write the result to `deliverable/final-check.md`. Fix every "No" before handing in.

| # | Check | Yes / No |
|---|---|---|
| 1 | Every brief ask (B-NN) is answered. Add a table "brief ask → section" to `final-check.md`. | |
| 2 | The summary stands alone and fits on one page. | |
| 3 | Scope: in and out are both stated, with reasons. | |
| 4 | Every key decision shows the options, the choice, the reason and what we give up. | |
| 5 | Every quality requirement has a number. | |
| 6 | Every diagram is mentioned in the text and has a caption. | |
| 7 | Technology names are the same in text and diagrams. | |
| 8 | No product names, unless the brief names a vendor. | |
| 9 | Nothing in the document is outside the scope contract. | |
| 10 | Assumptions are listed and each one says what changes if it is wrong. | |
| 11 | Within the page or slide limit. | |
| 12 | Plain English: no long sentences, no unexplained abbreviations. | |
| 13 | The PDF or Word file was opened and every page looked at. | |
| 14 | Time spent is within the budget (from the time plan). | |

Then hand over to `assignment-defence`.

## Output files

| File | Content |
|---|---|
| `deliverable/document.md` | Source of the document |
| `deliverable/<name>.pdf` or `.docx` | The document to hand in |
| `deliverable/<name>.pptx` or slides link | Only if slides are asked |
| `deliverable/final-check.md` | Result of the final check |
