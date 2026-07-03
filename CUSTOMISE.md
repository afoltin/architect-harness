# Customisation Guide — EA Tooling Kit

**Version:** 1.0 (Phase 1 scaffold)
**Status:** Living document — update when org-specific decisions are made

This kit is fully generic by design. Nothing in `.cursor/rules/` or `skills/` refers to a specific organisation, repository layout, or tooling stack out of the box. This file explains exactly what to change, where, and why — so you can adapt the kit to your context without breaking the generic baseline.

---

## How the kit is structured

```
.cursor/rules/       ← Cursor project rules (passive: loaded automatically)
skills/              ← Claude skills (active: invoked on demand)
ea-practice/         ← Shared reference docs (used by both)
AGENTS.md            ← Charter for any AI agent working in this repo
CUSTOMISE.md         ← This file
LOG.md               ← Progress and changelog
```

The Cursor rules shape how any AI agent *thinks* when working in your repo. The Claude skills give Claude the workflows to *act* — generating journal entries, processing meeting notes, writing ADRs, and so on.

---

## Step 1 — Define your repository layout

The single most important customisation. Open `AGENTS.md` and replace the generic folder-to-TOGAF-domain mapping with your actual structure.

**Default generic mapping (in `AGENTS.md`):**

```
BusinessArchitecture/   → ADM Phase B
ApplicationArchitecture/ → ADM Phase C – Applications
DataArchitecture/       → ADM Phase C – Data
TechnologyArchitecture/ → ADM Phase D (ADRs live here)
ea-practice/            → EA operating layer
journal/                → Daily working log
process/                → Meeting and conversation notes
transformation/         → Cross-cutting transformation programmes
templates/              → Reusable blank templates
```

If your repo uses different folder names, update this table. Every skill and rule derives its path logic from `AGENTS.md` — a single source of truth.

**Tip:** If your repo does not yet have this structure, create the folders first, then configure here. The skills include a repo-discovery step that reads `AGENTS.md` to determine actual paths — they will not hardcode guesses.

---

## Step 2 — Seed your Architecture Principles

Create `principles.md` at the root of your EA repo (or wherever you map `ea-practice/` to). Start from the template at `ea-practice/principles-template.md`.

Each principle has an ID (`P-NN`), a name, a rationale, and implications. The Cursor rules and skills reference principles by ID — if this file doesn't exist, the principle-citation behaviour is silently skipped.

**Minimum viable set:** 5–10 principles covering reuse, security, data ownership, vendor independence, and cloud-native preference. The template gives you 10 starters — delete, amend, or extend as needed.

---

## Step 3 — Add your first ADR example

The `adr-generator` skill uses an example ADR as a format reference. Add one real decision your team has made to `TechnologyArchitecture/ADR-0001-<slug>.md` (or wherever your ADRs live), following the format in `.cursor/rules/adr-and-decisions.mdc`.

This does two things:
- Grounds the format in a real, meaningful decision your team recognises.
- Sets the ADR counter baseline so the next ADR is numbered correctly.

If you have no prior decisions to document, the `adr-generator` skill will work with a stub placeholder, but a real example improves output quality significantly.

---

## Step 4 — Customise the Cursor rule globs

Each `.mdc` file in `.cursor/rules/` has a frontmatter `globs:` field. These tell Cursor which files trigger that rule automatically.

Open each rule and verify the glob matches your folder names:

| Rule file | Default glob | Change if… |
|-----------|-------------|------------|
| `application-architecture.mdc` | `ApplicationArchitecture/**` | Your apps folder has a different name |
| `business-architecture.mdc` | `BusinessArchitecture/**` | Your business folder has a different name |
| `data-architecture.mdc` | `DataArchitecture/**` | Your data folder has a different name |
| `technology-architecture.mdc` | `TechnologyArchitecture/**` | Your tech folder has a different name |
| `adr-and-decisions.mdc` | `**/ADR-*.md` | Your ADR naming convention differs |

Rules with `alwaysApply: true` (like `togaf-core.mdc`) do not use globs — they load for every file.

---

## Step 5 — Configure the journal and process-notes skills

Both skills have a **repo-discovery step** that reads `AGENTS.md` to derive paths. If your layout matches the default mapping in Step 1, no further action is needed.

If you use a non-standard structure, open the relevant `SKILL.md` and update the path constants block near the top of the Workflow section:

```
JOURNAL_DIR: journal/
NOTES_CONVERSATION_DIR: process/ConversationNotes/
NOTES_BOARD_DIR: process/ArchitectureBoardMeetings/
ACTION_ITEMS_FILE: ea-practice/action-items.md
ADR_DIR: TechnologyArchitecture/
```

These are the only values the skills assume. Everything else is derived dynamically.

---

## Step 6 — Add your Glossary and Stakeholder context

Two files significantly improve AI output quality but are optional at setup:

- **`Glossary.md`** — authoritative terms, acronyms, and product names specific to your organisation. Without it, the agent will invent synonyms. Add entries incrementally as they surface in conversations.
- **`BusinessArchitecture/Organization/StakeholderMap.md`** (or equivalent) — named roles and their concerns. Referenced by the `process-notes` skill when suggesting stakeholder updates after a meeting.

Neither file needs to be complete to start. A 10-entry Glossary is better than none.

---

## Optional — Add organisation-specific rules

If you have standards that apply across all work (naming conventions, approved cloud providers, mandatory security controls, preferred integration patterns), add them as additional `.mdc` files in `.cursor/rules/`. Name them clearly:

```
.cursor/rules/org-naming-conventions.mdc
.cursor/rules/org-approved-platforms.mdc
.cursor/rules/org-security-baseline.mdc
```

Set `alwaysApply: true` if they apply everywhere, or scope them with `globs:` if they are domain-specific.

---

## Optional — Add organisation-specific skills

If your team has recurring workflows not covered by the six default skills, add them as new folders under `skills/`. Follow the same `SKILL.md` format. Name the skill in the frontmatter `name:` field — this is what you invoke it by.

Good candidates for org-specific skills:
- Generating RFC/proposal docs in your internal template
- Producing reports from a specific source system
- Writing changelog entries in your release format
- Running a pre-meeting prep workflow

---

## What NOT to change in the generic baseline

The following files are the shared foundation. Edit them only if you are deliberately updating the generic kit for all users, not just your org:

- `ea-practice/togaf-decision-stages.md` — canonical ADM scenario reference
- `ea-practice/principles-template.md` — starter template (copy it, don't edit it)
- `.cursor/rules/togaf-core.mdc` — core TOGAF stance and vocabulary

If you need org-specific overrides for these, add a separate `.mdc` file or extend via a new skill rather than editing the base files. This keeps the generic baseline clean and upgradeable.

---

## Checklist — minimum viable customisation

```
[ ] Updated AGENTS.md folder mapping to match your repo
[ ] Created principles.md from ea-practice/principles-template.md
[ ] Added at least one real ADR to TechnologyArchitecture/
[ ] Verified .cursor/rules/ globs match your folder names
[ ] Created Glossary.md with at least 5–10 terms
```

Once these five steps are done, the kit is fully operational for your context.
