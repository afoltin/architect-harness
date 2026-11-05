# EA Tooling Kit

**Title:** EA Tooling Kit — Usage Guide
**Version:** 1.0 | **Status:** Active | **Updated:** 2026-06-25

A generic, TOGAF-aligned Enterprise Architecture tooling kit designed to work across Cursor, Claude Desktop (Cowork), and Claude Code. It provides Cursor with persistent architectural context and standards, and gives Claude structured workflows for EA operations — from writing ADRs and processing meeting notes to building roadmaps and reviewing decisions against principles.

This is not a full EA repository. It is the **operating layer** that sits inside one — the rules, skills, and reference material that govern how any AI agent should behave when doing EA work.

---

## What this kit provides

Two parallel structures — one passive, one active:

| Structure | Location | Role | Works with |
|-----------|----------|------|------------|
| **Cursor rules** | `.cursor/rules/*.mdc` | Passive context — shape how the agent thinks, what vocabulary it uses, and what standards it applies when working on EA files | Cursor |
| **Claude skills** | `skills/*/SKILL.md` | Active workflows — step-by-step procedures the agent follows to produce EA artifacts | Claude Desktop, Claude Code |

Both structures read from the same shared reference layer in `ea-practice/` and `AGENTS.md`, so they stay in sync without duplication.

---

## Kit structure

```
.
├── AGENTS.md                          ← Single source of truth for repo layout + agent charter
├── README.md                          ← This file
├── CUSTOMISE.md                       ← How to adapt this kit to your organisation
├── LOG.md                             ← Progress log and changelog
│
├── .cursor/
│   └── rules/
│       ├── togaf-core.mdc             ← Core TOGAF stance (always active)
│       ├── adr-and-decisions.mdc      ← ADR trigger and format rules (always active)
│       ├── business-architecture.mdc  ← Phase B guidance (auto-loads for BusinessArchitecture/**)
│       ├── application-architecture.mdc ← Phase C-App guidance
│       ├── data-architecture.mdc      ← Phase C-Data guidance
│       ├── technology-architecture.mdc ← Phase D guidance
│       ├── architecture-roadmap.mdc   ← Phase E/F roadmap and TA guidance
│       ├── principles-governance.mdc  ← Principle lifecycle rules (always active)
│       ├── board-governance.mdc       ← Architecture Board operating model
│       └── rfp-context.mdc            ← RFP presales context (auto-loads for pursuits/**)
│
├── skills/
│   ├── ea-standards/SKILL.md          ← Review a doc against EA standards
│   ├── adr-generator/SKILL.md         ← Generate an ADR for any TOGAF domain
│   ├── journal-entry/SKILL.md         ← Daily journal entry from git commits
│   ├── process-notes/
│   │   ├── SKILL.md                   ← Convert meeting notes to structured markdown
│   │   └── FORMATS.md                 ← Note format templates
│   ├── roadmap-planner/SKILL.md       ← Gap analysis → sequenced Architecture Roadmap
│   ├── principles-review/SKILL.md     ← Audit a document against principles.md
│   ├── rfp-qualifier/SKILL.md         ← Phase 0 bid/no-bid qualification
│   ├── rfp-discovery-to-design/SKILL.md ← Phases 1–2 discovery, Architecture Intent, SAD
│   └── rfp-assembler/SKILL.md         ← Phases 3–4 delivery model and proposal assembly
│
├── ea-practice/
│   ├── togaf-decision-stages.md       ← ADM emphasis for 4 scenarios (replace/consolidate/integrate/greenfield)
│   ├── principles-template.md         ← Starter principles file with 10 generic P-NN entries
│   └── rfp-pursuit-guide.md           ← Architecture Intent format, C4 conventions, pursuit folder structure
│
├── pursuits/                          ← One subfolder per RFP engagement (<client>-<slug>/)
│
└── _archive/                          ← Original content preserved; safe to ignore
```

---

## Before you start — minimum viable setup

The kit is generic by design. Five steps make it operational for your context:

1. **Update `AGENTS.md`** — replace the default folder-to-domain mapping with your actual EA repo structure.
2. **Create `principles.md`** — copy `ea-practice/principles-template.md` into the root of your EA repo and adapt the 10 starter principles to your organisation.
3. **Add one real ADR** — seed `TechnologyArchitecture/ADR-0001-<slug>.md` with a decision your team has already made. This grounds the format and sets the counter.
4. **Verify the Cursor globs** — check that the folder names in `.cursor/rules/*.mdc` frontmatter match your actual structure.
5. **Create `Glossary.md`** — even 5–10 terms prevents the agent inventing synonyms.

### Tools to install

Most skills only read and write Markdown files and need no extra tools. Two skills need command line tools. Install them yourself with [Homebrew](https://brew.sh) on macOS. The agent never installs tools; it asks you before it runs them.

| Tool | Install | Needed by | What it does |
|------|---------|-----------|--------------|
| Structurizr | `brew install structurizr` | `c4-diagrams` | Reads your Structurizr DSL and exports one PlantUML file per view |
| PlantUML | `brew install plantuml` | `c4-diagrams` | Draws the diagrams as PNG or SVG. Also installs Graphviz (layout) and OpenJDK (Java) |
| Python 3 | already on macOS (Xcode Command Line Tools), or `brew install python` | `c4-diagrams` | Prepares the diagrams for documents (title, key, resolution) |
| Git | already on macOS (Xcode Command Line Tools), or `brew install git` | `journal-entry`, commit offers in other skills | Reads the day's commits; the EA repo must be a git repository |

Install all at once:

```bash
brew install structurizr plantuml
```

Check the install:

```bash
structurizr version && plantuml -version && python3 --version && git --version
```

On an Intel Mac, Homebrew may build `structurizr` from source. This takes longer but works the same.

See `CUSTOMISE.md` for the full guide, including optional steps for org-specific rules and skills.

---

## 1. Using with Cursor

Cursor loads `.cursor/rules/` automatically when you open the project. No configuration is needed beyond placing the rules in that folder.

### How the rules activate

Rules have two activation modes, defined in each file's frontmatter:

**`alwaysApply: true`** — loads for every file in the project, regardless of what you have open. Three rules use this:

- `togaf-core.mdc` — the foundation. Vocabulary, ADM phases, structured-output expectation, and the eight behavioural rules. Any architecture artifact you produce in Cursor will be shaped by this.
- `adr-and-decisions.mdc` — Cursor will proactively offer ADR capture whenever a qualifying decision is reached in a chat, regardless of which domain you are working in.
- `principles-governance.mdc` — principle citation, conflict handling, and lifecycle rules apply across all work.

**`globs:`** — loads only when a file matching the pattern is open. Domain rules use this so Cursor automatically deepens its context when you open a domain-specific file:

| Rule | Activates when you open |
|------|------------------------|
| `business-architecture.mdc` | Any file in `BusinessArchitecture/` |
| `application-architecture.mdc` | Any file in `ApplicationArchitecture/` |
| `data-architecture.mdc` | Any file in `DataArchitecture/` |
| `technology-architecture.mdc` | Any file in `TechnologyArchitecture/` |
| `board-governance.mdc` | Any board meeting note in `process/ArchitectureBoardMeetings/` |
| `architecture-roadmap.mdc` | Any file in `ea-practice/` or `transformation/` |

Additionally, `adr-and-decisions.mdc` also activates for `**/ADR-*.md` files, giving ADR-specific editing guidance when you are directly editing an existing decision record.

### What to expect in Cursor

When you open an architecture file and start a chat, Cursor will:

- Use TOGAF vocabulary precisely (ABB vs SBB, Baseline vs Target, etc.)
- Ask which ADM phase you are working in before producing significant artifacts
- Open new architecture documents with the four-line ADM-phase header block
- Cite principles by P-NN ID when a recommendation rests on or conflicts with one
- Proactively offer to write an ADR when a qualifying decision is reached
- Name gaps explicitly rather than implying them

### Customising the rules for your project

Each rule is a plain markdown file. You can:

- Add org-specific naming conventions, approved platforms, or security baselines as additional `.mdc` files — Cursor picks up everything in `.cursor/rules/`
- Adjust glob patterns if your folder names differ from the defaults
- Add `alwaysApply: true` to the `architecture-roadmap.mdc` if you want roadmap guidance available everywhere, not just in `ea-practice/` and `transformation/`

### AGENTS.md and Cursor

Cursor also reads `AGENTS.md` as a project-level context file. It mirrors the core content of `togaf-core.mdc` in a format that Cursor's background indexing picks up, and it is the single source of truth for the repo structure that the Cursor rules reference. If your folder names differ from the defaults, update `AGENTS.md` first — the rules read from it.

---

## 2. Using with Claude Desktop (Cowork)

Claude Desktop's Cowork mode can read files directly from your mounted folder. The skills in this kit are self-contained `SKILL.md` files — Claude reads and follows them when you invoke them by name.

### How the skills work

Each skill in `skills/` is a structured workflow in markdown. When you ask Claude to use one, it reads the `SKILL.md` and follows the step-by-step procedure, using your EA repo as the working context.

Skills always begin with a **repo discovery step** — they read `AGENTS.md` to resolve paths before doing any file work. This means they adapt automatically to your repo structure rather than hardcoding assumptions.

### Invoking a skill

The most direct way is to name the skill and what you want:

```
"Use the journal-entry skill to write today's journal"
"Run the process-notes skill on these notes: [paste notes]"
"Use adr-generator to capture the decision we just made on the API gateway"
"Run ea-standards review on this document: [paste or link file]"
```

Claude will read the appropriate `SKILL.md`, follow the workflow, and produce the output — writing files to your EA repo and showing you what it did.

You can also invoke them more naturally:

```
"Write today's journal entry"              → triggers journal-entry
"Process my meeting notes from this morning" → triggers process-notes
"Write up the ADR for the platform choice" → triggers adr-generator
"Check this design doc against our principles" → triggers principles-review
"Build a roadmap from these gaps"           → triggers roadmap-planner
"Review this artifact"                      → triggers ea-standards
```

### Installing skills permanently

If you use this kit frequently, you can install the skills so Claude picks them up automatically without needing to be told. In Cowork Settings → Capabilities → Skills, you can add a skills directory. Copy the `skills/` folder from this kit into your Cowork skills location — Claude will then offer the skills proactively when relevant context is detected.

Alternatively, each `SKILL.md` can be packaged as a `.skill` file and installed individually. The skill descriptions in the frontmatter are what Claude uses to decide when to offer them automatically.

### Sharing context with Claude in Cowork

When starting a new session working on your EA repo:

1. Mount your EA repo folder in Cowork (the folder that contains your `BusinessArchitecture/`, `TechnologyArchitecture/`, etc.)
2. Point Claude to `AGENTS.md`: *"Read AGENTS.md — this is an EA repo and that file describes how it's structured."* You only need to do this once per session; Claude will maintain context across subsequent requests.
3. From that point, Claude understands the repo structure, the domain mapping, and the operating standards — and will apply them to everything it helps you with.

---

## 3. Using with Claude Code

Claude Code reads `AGENTS.md` automatically from the repo root. This is the primary integration point.

### AGENTS.md as the Claude Code charter

When you run Claude Code in a directory containing `AGENTS.md`, it reads the file as an agent charter — a set of instructions that governs how it should behave in this project. The file:

- Tells Claude Code how the repo's folders map to TOGAF domains
- Sets vocabulary expectations (ABB vs SBB, principle citation format, etc.)
- Defines the structured-output expectation (the four-line ADM-phase header)
- Lists the eight behavioural rules it should follow
- Points to the skills available and what each one does
- Directs it to `ea-practice/togaf-decision-stages.md` for ADM scenario guidance

You do not need to re-explain these things in every Claude Code session — they are loaded automatically.

### Using skills in Claude Code

Claude Code can read and follow skill files directly. Reference them by path:

```bash
# In a Claude Code session:
"Follow the workflow in skills/journal-entry/SKILL.md to write today's journal"
"Use skills/adr-generator/SKILL.md to capture the decision we just discussed"
"Run the ea-standards review from skills/ea-standards/SKILL.md on ApplicationArchitecture/VoiceReplacement.md"
```

For frequent use, you can also place the skill files in `~/.claude/skills/` — Claude Code will then pick them up automatically and offer them without needing the explicit path.

### CLAUDE.md as an alternative or supplement

If your EA repo already has a `CLAUDE.md` at the root, you can either:

- **Replace it with `AGENTS.md`** — the files are equivalent in format and Claude Code reads both
- **Add a reference in `CLAUDE.md`** — add a line: `See AGENTS.md for the architecture operating model and domain mapping`

Both approaches work. `AGENTS.md` is preferred for multi-agent compatibility (it is read by Cursor, Claude Code, Codex, and other tools); `CLAUDE.md` is Claude Code-specific.

### Typical Claude Code session flow

```bash
cd /path/to/your/ea-repo
claude

# Claude Code loads AGENTS.md automatically.
# You can now work naturally:

> "Open BusinessArchitecture/CapabilityMap.md and review it"
# Claude applies togaf-core behavioural rules automatically

> "We just decided to use Azure API Management as our API gateway — write the ADR"
# Claude follows adr-generator workflow, assigns next ADR number, checks principles

> "Write today's journal"
# Claude follows journal-entry workflow, reads git log, discovers paths from AGENTS.md
```

---

## Understanding AGENTS.md

`AGENTS.md` is the single most important file in this kit. Every skill, every rule, and every AI agent that works in your EA repo reads it first.

It serves three purposes:

**1. Repo structure definition.** The folder-to-TOGAF-domain mapping table tells every agent where things live. Skills use it to resolve file paths dynamically — they do not hardcode paths. If you rename a folder, update this table and everything adjusts.

**2. Agent charter.** The behavioural rules, vocabulary definitions, structured-output expectation, and ADR conventions in `AGENTS.md` apply to any agent — Cursor, Claude, Codex, or otherwise. It is the architecture practice's contract with its AI tooling.

**3. Skill index.** The skills table at the bottom of `AGENTS.md` lists every available workflow and what it does. An agent that reads this knows what it can invoke and when.

### When to update AGENTS.md

- When you rename or restructure your EA repo's folders
- When you add a new domain folder not in the default mapping
- When you add a new skill to `skills/`
- When a key reference file (principles.md, action-items.md) moves
- At the start of an engagement when you are adapting the kit to your context

---

## Running an EA engagement with this kit

### Initiating a new engagement (cold start)

You are starting work on an EA practice with no existing repository, or inheriting a disorganised one. This is the sequence that works:

**Week 1 — Orientation**

1. Create your EA repo. Set up the folder structure from the `AGENTS.md` default mapping — or adjust the mapping to reflect what already exists.
2. Copy this kit's `AGENTS.md`, `.cursor/rules/`, `skills/`, and `ea-practice/` into the repo root.
3. Work through `CUSTOMISE.md` steps 1–5: update `AGENTS.md`, seed `principles.md`, create `Glossary.md`.
4. Run your first stakeholder meetings. Use the **process-notes skill** to capture each one — it will produce structured markdown, populate `ea-practice/action-items.md`, and identify what artifacts need to be created.
5. At the end of each working day, use **journal-entry** to capture what moved and what didn't. This builds institutional memory from day one.

**Week 2–4 — Baseline capture**

6. Begin populating the four domain folders. Cursor's domain rules will shape how you write — they will push you toward capability-first language, named gaps, and ABB-before-SBB discipline.
7. When significant decisions are made in meetings or design sessions, use **adr-generator** to capture them. The ADR Principles field will be empty at first — use **principles-review** to populate it as your principles file matures.
8. Identify the first significant gaps between Baseline and Target. When you have a gap list, use **roadmap-planner** to sequence them into a roadmap with named Transition Architectures.
9. Schedule the first Architecture Board session. Use **process-notes** to capture the outcome. The board rule in `.cursor/rules/board-governance.mdc` governs what a session must produce.

**Month 2+ — Governance in motion**

10. The journal, process-notes, and ADRs are your institutional memory. Everything significant gets captured.
11. Run **ea-standards** review on any artifact before it goes to the board — it catches missing headers, floating recommendations, and uncited principles before the review session.
12. Run **principles-review** whenever an ADR is written — it keeps the Principles field honest and surfaces candidate new principles.
13. Use the Architecture Board cadence from `board-governance.mdc` to drive a regular review rhythm.

---

### Maintaining an ongoing engagement

For an established EA practice, this is a sustainable weekly operating cadence:

**Daily**
- `journal-entry` — capture what moved, what didn't, and why. This takes 5 minutes and pays back enormously when reconstructing decisions weeks later.

**After any meeting or significant conversation**
- `process-notes` — convert raw notes to structured markdown, update action items, surface artifact update suggestions. The skill does the filing; you review and confirm.

**When a significant decision is reached**
- `adr-generator` — capture it before the conversation ends. An ADR written the same day takes 15 minutes; reconstructed three weeks later takes an hour and loses nuance.

**Before any Architecture Board submission**
- `ea-standards` review — confirm the artifact meets standards before it goes to governance. Fixing a missing stakeholder concern table in the session is expensive; fixing it beforehand is free.

**Monthly (or before each board session)**
- `principles-review` on any ADR in the review queue — verify the Principles field is complete and no conflicts are unaddressed.

**Quarterly**
- `roadmap-planner` — refresh the horizon assignments. H0 should be closing; H1 should be hardening into H0-level detail; H2 should be revisited against the current business context.

**Annually**
- Principles review session (see `principles-governance.mdc`) — review all Active principles against the current context.
- Review `togaf-decision-stages.md` — does it still reflect how the practice uses the ADM?
- Archive superseded ADRs and update their status.

---

## File reference

### Root files

**`AGENTS.md`**
The agent charter and single source of truth for repo structure. Read by every AI agent automatically. Update this first when your repo structure changes. Contains: domain folder mapping, vocabulary reference, structured-output expectation, behavioural rules, ADR conventions, and the skill index.

**`CUSTOMISE.md`**
Step-by-step guide for adapting this generic kit to a specific organisation. Covers the five mandatory steps (AGENTS.md, principles.md, first ADR, Cursor globs, Glossary.md) and optional steps for org-specific rules, skills, and extended configuration.

**`LOG.md`**
Progress log for the kit itself. Records what has been built across the three development phases, with a changelog. Update this as the kit evolves — it is the kit's own institutional memory.

---

### `.cursor/rules/` — Cursor project rules

**`togaf-core.mdc`** *(alwaysApply: true)*
The foundation rule. Loads for every file. Sets the full TOGAF vocabulary table, the structured-output header expectation, and eight behavioural rules covering gap naming, ABB/SBB discipline, principle citation, stakeholder traceability, ADM phase awareness, and decision capture. Also includes a per-phase "minimum viable artifact" table so Cursor knows what done looks like at each ADM stage.

**`adr-and-decisions.mdc`** *(alwaysApply: true + globs: **/ADR-*.md)*
Governs when to offer ADR capture and how to write one. Applies across all four TOGAF domains — not just Technology. Contains the three trigger criteria (reusable + architecturally significant + trade-offs considered), the full ADR format template, domain-routing table (which domain's folder to use for which decision type), and domain-specific trigger lists for Technology, Application, Data, and Business decisions.

**`business-architecture.mdc`** *(globs: BusinessArchitecture/**)*
Phase B depth. Capability-first language, value stream definition, stakeholder concern traceability (includes a named markdown table template), operating model touchpoints, and the discipline to stay in Phase B without drifting into Phase C or D. Contains the Business ADR trigger list.

**`application-architecture.mdc`** *(globs: ApplicationArchitecture/**)*
Phase C-Applications depth. ABB before SBB enforcement, TIME/6R portfolio evaluation framework, fit-gap before product choice requirement, integration pattern naming (synchronous API, async event, batch, data virtualisation), decommissioning planning as a first-class deliverable. Contains the Application ADR trigger list.

**`data-architecture.mdc`** *(globs: DataArchitecture/**)*
Phase C-Data depth. Canonical model primacy, unambiguous system-of-record assignment, two-dimension ownership (business owner + technical custodian), data sensitivity classification for regulated entities, data quality dimensions for critical entities, mastering pattern selection (hub / registry / coexistence). Contains the Data ADR trigger list.

**`technology-architecture.mdc`** *(globs: TechnologyArchitecture/**)*
Phase D depth. SBB justification against ABBs, operational qualities (availability, RPO/RTO, security zone, observability), reuse-before-introduce check, integration pattern naming and catalogue reference, identity and authentication model requirements, cost and lifecycle visibility. Contains the Technology ADR trigger list and ADR status lifecycle guidance.

**`architecture-roadmap.mdc`** *(globs: {ea-practice,transformation}/**)*
Phase E/F depth. Transition Architecture definition (what makes a TA warranted vs unnecessary), TA naming convention (`TA-NN-<slug>`), three-horizon model (H0/H1/H2) with criteria for each band, work package definition, roadmap artifact structure, decommissioning schedule as a required roadmap component, and the Phase E → Phase F handoff boundary.

**`principles-governance.mdc`** *(alwaysApply: true)*
Principle lifecycle (Proposed → Active → Superseded), inline citation format (`P-NN Name`), new principle proposal steps (board approval required before Active), conflict handling protocol (name → justify → escalate), anti-patterns (granularity, rubber-stamping, the immovable principle), and review cadence triggers (annual, major ADM cycles, three-conflict threshold).

**`board-governance.mdc`** *(globs: process/ArchitectureBoardMeetings/**)*
Architecture Board operating model. Composition guidance, decision rights matrix (board-required vs architect-decides vs escalate), quorum definition, meeting cadence (regular + ad-hoc + annual principle review), mandatory output requirements per agenda item (Approved / Deferred / Rejected / Escalated), and a "what the board is not" section to prevent common governance failures.

**`rfp-context.mdc`** *(globs: {pursuits,presales,rfp}/**)*
RFP and presales pursuit context. Extends `togaf-core.mdc` for time-boxed, commercially-driven proposal delivery. Contains: RFP phase → TOGAF ADM mapping table, Architecture Intent definition and required content (the gate artifact at the Phase 1/2 boundary), RFP vocabulary additions (Architecture Intent, NFR, SAD, Compliance Matrix, etc.), C4 diagram conventions (which levels to produce, labelling rules, what every diagram must include), six RFP-specific behavioural rules (architecture intent first, NFR traceability, honest fit/gap, ADRs during pursuit not after, assumptions as commercial protection, EA lens under time pressure), pursuit governance RACI, and failure patterns to watch for and name. Activates automatically for any file under `pursuits/`, `presales/`, or `rfp/` — no manual loading required.

---

### `skills/` — Claude workflow skills

**`ea-standards/SKILL.md`**
Reviews any architecture artifact against seven dimensions: ADM-phase header, ABB/SBB discipline, principle citations, stakeholder concern traceability, gap naming (Baseline → Gap → Transition), business driver traceability, and ADR trigger identification. Produces a ✅/⚠️/❌ findings table with specific (not generic) findings per dimension, then offers to fix each gap directly in the document. Use before any board submission or peer review.

**`adr-generator/SKILL.md`**
Full eight-step ADR generation workflow: repo discovery, domain classification (Technology/Application/Data/Business), global ADR number assignment (scans all existing ADRs), context gathering (extracts from conversation or asks targeted questions), principles lookup against `principles.md`, full ADR draft, file write to the correct domain directory, and commit offer. Includes an ADR quality anti-patterns table that catches vague decisions, missing options, and optimistic Consequences sections before the file is written.

**`journal-entry/SKILL.md`**
Six-step daily journal workflow: repo discovery (paths from `AGENTS.md`), date and commit gathering (`git log` scoped to the day and `git config user.name`), continuity check against the previous entry's "End of day" line, narrative grouping of commits into 1–4 work blocks, writing `journal/YYYY-MM-DD.md` in a structured reflective format, and commit offer. Voice rules enforce first-person candour, evidence from commits, and honesty about drift from plan. The format includes: Why this entry, Today's specific work, Hypotheses & checkpoint, Gut feeling, End of day.

**`process-notes/SKILL.md`**
Six-phase notes conversion workflow: repo discovery, note type detection (conversation vs board session), format and file writing (using templates from `FORMATS.md`), artifact update suggestions (checks which files exist before suggesting updates to them), new artifact proposals (TOGAF-framed, with rationale), and ADR trigger check. Output order: the formatted note file → artifact update suggestions → new artifact proposals → ADR offer (once, if warranted).

**`process-notes/FORMATS.md`**
Markdown templates for conversation notes and board session notes. Conversation note format: topic block quote with canonical actions, people/context section, topic sections, implications/follow-ups (new / reinforced / closed actions), abbreviations table. Board session format: status block quote, logistics table, agenda items, decisions/governance outcomes table, action items table, parking lot. Includes the canonical-actions block quote rules and the relative path convention for cross-references.

**`roadmap-planner/SKILL.md`**
Eight-step roadmap planning workflow: repo discovery, gap list input (from existing document or conversation — with gap normalisation to ensure specificity), dependency analysis (dependency table + cycle detection), horizon assignment (H0/H1/H2 with assignment rules), Transition Architecture definition (structured TA template for each horizon boundary), work package definition (one team, one planning cycle scope), full roadmap document writing (with embedded markdown template), and Phase F handoff checklist (cutover approach, data migration scope, decommission dependency, operational readiness). Produces `ea-practice/ArchitectureRoadmap.md` or programme-specific roadmap.

**`principles-review/SKILL.md`**
Seven-step principles audit workflow: repo discovery and principles loading (handles absent `principles.md` gracefully), artifact acceptance (file path, pasted content, or natural language description), principles relevance mapping, classification of each relevant principle as Satisfied / Neutral / In Tension / Conflicted (with explicit distinction between In Tension and Conflicted), implied new principle detection, structured review output (table + per-finding detail for tensions and conflicts), and follow-up offers (update ADR Principles field, draft conflict justification, propose new principle for board). Treats the principles file as a governance tool, not a document to acknowledge and ignore.

**`rfp-qualifier/SKILL.md`**
Phase 0 RFP qualification workflow. Drives the go/no-go decision before committing architecture and delivery resources — the step most often skipped under commercial pressure. Six steps: repo discovery and pursuit folder setup, bid/no-bid scoring (five dimensions, 1–5 each, with scoring bands and qualitative factors), RFP requirements triage (Mandatory/Weighted/Informational matrix), Open Questions Log (domain-categorised, each question tied to what it blocks), Bid/No-Bid Decision Record (scored summary, conditions for conditional bid, sign-off table), and go/no-go confirmation. Outputs three files to `pursuits/<client>-<slug>/Phase0/`.

**`rfp-discovery-to-design/SKILL.md`**
Phases 1–2 RFP workflow covering the full discovery-to-architecture arc. Twelve steps: repo discovery and Phase 0 artifact reading, Client Context Brief (industry/regulatory/landscape/stakeholders), NFR Catalogue (all eight categories with source tracking and assumption flagging), Solution Hypothesis (one-page directional narrative), Architecture Intent document (the Phase 1/2 gate artifact — invokes `ea-standards` before sharing), Capability Map (ABBs with business capability traceability), Options Analysis (two to three options with structured trade-off comparison), principles check (invokes `principles-review`), ADRs for key decisions (invokes `adr-generator` for each decision trigger), SAD outline and NFR Response Matrix, Fit/Gap Assessment (Met/Partial/Gap/Out-of-scope for every RFP requirement), and final EA standards review. Outputs eleven artifacts across `Phase1/` and `Phase2/`.

**`rfp-assembler/SKILL.md`**
Phases 3–4 RFP workflow — delivery model and commercial assembly. Eight steps: repo discovery with Architecture Intent confirmation gate, Phased Roadmap (invokes `roadmap-planner` with RFP-adapted inputs — delivery phases as horizons, Transition Architectures as go-live milestones), Risk Register (systematic check across architecture/delivery/commercial/external risk sources), Assumptions & Exclusions (commercial protection — cross-referenced to Open Questions Log and Fit/Gap), Dependency Log (client-side/third-party/internal dependencies with lead times), Compliance Matrix (every RFP requirement mapped to the proposal section that responds to it), Executive Summary (written from a client executive's perspective, traceable to Architecture Intent — with quality checks), and Proposal Assembly Checklist (complete pre-submission verification across all four phases). Outputs six files across `Phase3/` and `Phase4/`.

---

### `ea-practice/` — shared reference documents

**`togaf-decision-stages.md`**
Canonical reference for ADM emphasis across four common scenarios. For each scenario — one-to-one replacement, consolidation of multiple applications, integration between existing systems, and greenfield capability build — it covers: Phase H trigger, emphasis per ADM phase (A through H), key artifacts, and where the decision centre of gravity sits. The summary table at the end maps scenario to dominant decision phase and change type. Reference this before starting significant Phase A work to confirm the right depth and emphasis for each phase.

**`principles-template.md`**
A starter principles file with 10 generic Active principles covering: P-01 Business-driven architecture, P-02 Reuse before buy, buy before build, P-03 ABB before SBB, P-04 One system of record per entity, P-05 Security by design not by addition, P-06 Prefer managed services for undifferentiated capability, P-07 Design for observability from day one, P-08 Incremental delivery over big-bang, P-09 Don't duplicate, federate, P-10 Architecture decisions are traceable and time-stamped. Copy this to `principles.md` in your EA repo root and adapt as needed. Delete principles that don't fit your context; add org-specific ones with `Proposed` status for board review.

**`rfp-pursuit-guide.md`**
Reference document for the RFP capability. Contains: the standard pursuit folder structure (`pursuits/<client>-<slug>/Phase0/` through `Phase5/`), the full RFP → TOGAF ADM mapping with governing principles per phase, the Architecture Intent document format (the gate artifact — full template with all seven required sections and the gate criteria checklist for Phase 2 entry), C4 diagram conventions (which levels to produce, mandatory labelling rules, what every diagram must include and must not include), the artifact dependency map showing sequencing constraints across all phases, and the one rule: every artifact must be traceable to a stated requirement or documented decision. This document is referenced by `rfp-context.mdc` and all three RFP skills.

---

### `_archive/`

The original content from before this kit was restructured. Preserved for reference and traceability. Contains the original BTI Berner-specific `AGENTS.md`, five `.mdc` Cursor rules, and two skill files (`journal-entry`, `process-notes`). Safe to ignore; do not modify.

---

## Common patterns

### Starting a design session in Cursor

Open the relevant domain folder in Cursor. The domain rule loads automatically. Open a chat and say what you are working on. Cursor will ask which ADM phase you are in (or infer it from context) and will apply the appropriate depth. If a significant decision is reached during the session, it will offer to write an ADR.

### Capturing a meeting that produced a decision

Paste your raw notes and ask Claude to process them using the `process-notes` skill. It will write a structured note to `process/ConversationNotes/` or `process/ArchitectureBoardMeetings/`, suggest updates to `action-items.md` and other artifacts, and — if the meeting produced a qualifying decision — ask whether to capture it as an ADR.

### Reviewing an artifact before a board session

Share the artifact (file path or paste) and ask Claude to run `ea-standards` on it. You will get a structured findings table. Fix ❌ items before the session; ⚠️ items are judgement calls. Then run `principles-review` to confirm the Principles field on any ADR in the submission is complete and honest about conflicts.

### Kicking off a new programme or migration

Start with `togaf-decision-stages.md` to confirm the ADM emphasis for your scenario. Work through Phase A and B artifacts with Cursor (the domain rules will guide the depth). When you have a gap list from Phase E, use `roadmap-planner` to sequence it. As decisions are made at each phase, use `adr-generator` to capture them. The journal and process-notes skills keep the institutional memory current throughout.

### Running an RFP pursuit

When an RFP lands: use `rfp-qualifier` to run Phase 0 before committing any architecture resources. If the bid/no-bid decision is positive, create `pursuits/<client>-<slug>/` — the `rfp-context.mdc` rule will activate automatically for any file under this folder, bringing the full RFP/ADM mapping and C4 conventions into Cursor without manual loading.

Use `rfp-discovery-to-design` to run Phases 1 and 2. The Architecture Intent document at `Phase2/architecture-intent.md` is the gate — nothing in Phase 2 proceeds until it is agreed with the pursuit lead. The skill invokes `ea-standards`, `principles-review`, and `adr-generator` at the right points in the workflow; you do not need to orchestrate them separately.

Once the Architecture Intent is stable, use `rfp-assembler` to run Phases 3 and 4. The Proposal Assembly Checklist at the end of the assembler workflow is the final pre-submission gate.

See `ea-practice/rfp-pursuit-guide.md` for the Architecture Intent format, C4 conventions, standard pursuit folder structure, and artifact dependency sequencing.

---

## Extending the kit

**Adding an org-specific Cursor rule**
Create `<name>.mdc` in `.cursor/rules/`. Set `alwaysApply: true` for standards that apply everywhere, or use `globs:` to scope it. Update `AGENTS.md` to reference it in the "Per-domain depth" section.

**Adding an org-specific skill**
Create `skills/<name>/SKILL.md`. Follow the format: frontmatter with `name:` and `description:`, then a workflow section with numbered steps. Start with a repo discovery step (read `AGENTS.md` for paths). Add it to the skills table in `AGENTS.md`.

**Keeping the generic baseline clean**
If a change is specific to your organisation, add it as a new file rather than editing the generic baseline files. This keeps the kit upgradeable — you can pull in updates to the generic files without overwriting your customisations.
