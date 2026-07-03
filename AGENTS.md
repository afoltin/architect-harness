# AGENTS.md — EA Tooling Kit

This repository is a **generic TOGAF-aligned Enterprise Architecture tooling kit**. Any AI agent (Cursor, Claude, Codex, or other) working in it should adopt the stance below.

This file is the single source of truth for repo structure. Skills and Cursor rules derive their path logic from here. **If your folder names differ from the defaults, update the mapping in the "Repository layout" section below.**

For setup and customisation instructions, see `CUSTOMISE.md`.

---

## Stance: TOGAF as a thinking tool, not a process

Use TOGAF for **vocabulary and structure**. The ADM provides phases and emphasis, not a ceremony to enforce. Be light, not ceremonial.

---

## Repository layout

Update this table to match your actual folder names. All skills and rules read this mapping.

| Folder | TOGAF domain / ADM phase |
|--------|--------------------------|
| `BusinessArchitecture/` | Phase B — Business |
| `ApplicationArchitecture/` | Phase C — Applications |
| `DataArchitecture/` | Phase C — Data |
| `TechnologyArchitecture/` | Phase D — Technology (ADRs: `TechnologyArchitecture/ADR-NNNN-*.md`) |
| `ea-practice/` | EA operating layer |
| `templates/` | Reusable blank templates |
| `journal/` | Daily architecture working log |
| `process/ConversationNotes/` | Conversation note files |
| `process/ArchitectureBoardMeetings/` | Architecture Board session notes |
| `transformation/` | Cross-cutting transformation programmes |
| `pursuits/` | RFP presales pursuits — one subfolder per engagement (`<client>-<slug>/`) |
| `Glossary.md` | Authoritative terms — extend it; do not invent synonyms |
| `principles.md` | Active architecture principles — cite by P-NN ID |
| `ea-practice/action-items.md` | Master action-items list — cite by #NNN |

---

## Vocabulary to use consistently

ADM phases A–H, **ABB** (Architecture Building Block) vs **SBB** (Solution Building Block), **Architecture Vision**, **Target / Baseline / Transition Architecture**, **Gap Analysis**, **Architecture Principles**, **Architecture Requirements**, **Architecture Contract**, **Capability**, **Value Stream**, **Stakeholder**, **Concern**.

---

## Structured-output expectation

When creating or substantially editing an architecture artifact (anything in the four domain folders, `transformation/`, `ea-practice/`, `process/`, or any file matching `*Architecture*.md`), open with:

```
> **ADM phase:** <A | B | C-App | C-Data | D | E | F | G | H>
> **Domain:** <Business | Application | Data | Technology | cross-cutting>
> **Stakeholders:** <named roles or groups>
> **Decision class (per Phase H):** <Simplification | Incremental | Re-architecting>
```

Do not add this header to `journal/` entries — the journal has its own format.

---

## Behavioural rules

1. **Be light, not ceremonial.** Do not fabricate full TOGAF deliverables unless explicitly asked. A clear markdown document with the header above and the relevant sections is sufficient.
2. **Name gaps explicitly.** When proposing a Target state, identify the Baseline, the Gap, and at least one Transition Architecture if the gap cannot be closed in one step.
3. **Distinguish ABB from SBB.** ABBs are vendor-neutral capabilities; SBBs are concrete products or components. Do not conflate them.
4. **Surface principles when they apply.** Cite principles by `P-NN (Name)` from `principles.md`. If a recommendation conflicts with a principle, name the conflict — do not ignore it. If `principles.md` does not exist, recommend creating it from `ea-practice/principles-template.md`.
5. **Trace every choice.** Link every architectural recommendation back to a business driver, capability, or stakeholder concern.
6. **When in doubt, ask.** Before writing, ask which ADM phase the user is working in. The centre of gravity of the work changes per phase — see `ea-practice/togaf-decision-stages.md`.

---

## Decision capture (ADRs)

Architecturally significant decisions go to an ADR. See `.cursor/rules/adr-and-decisions.mdc` for trigger criteria and format.

ADR home: `TechnologyArchitecture/ADR-NNNN-<slug>.md` (default — update this line if your ADR path differs).

The agent should proactively offer to capture qualifying decisions. Ask once; do not repeat.

---

## Per-domain depth

Domain-specific guidance is in `.cursor/rules/`:

- `business-architecture.mdc` — capability-first, value streams, stakeholder concerns, no drift into apps/tech.
- `application-architecture.mdc` — ABB before SBB, TIME/6R portfolio lens, integration patterns named.
- `data-architecture.mdc` — canonical model, system of record, ownership, classification.
- `technology-architecture.mdc` — SBB choices justified against ABBs, ADRs for platform decisions, align to existing baselines.
- `architecture-roadmap.mdc` — Transition Architecture naming, horizon sequencing.
- `principles-governance.mdc` — principle lifecycle, citation, conflict handling.
- `board-governance.mdc` — decision rights, quorum, escalation.
- `rfp-context.mdc` — RFP presales pursuits: Architecture Intent, phase-to-ADM mapping, C4 conventions, failure patterns. Activates for `pursuits/`, `presales/`, `rfp/` folders.

---

## Claude skills available

Active workflows for Claude are in `skills/`:

| Skill | Purpose |
|-------|---------|
| `ea-standards` | Review a document against EA standards; apply ADM header |
| `adr-generator` | Generate an ADR for any TOGAF domain |
| `journal-entry` | Create a daily journal entry from git commits |
| `process-notes` | Convert raw meeting notes to structured markdown |
| `roadmap-planner` | Turn gap analysis into a sequenced Architecture Roadmap |
| `principles-review` | Audit a decision or document against `principles.md` |
| `rfp-qualifier` | Phase 0 — Bid/No-Bid scoring, requirements triage, Open Questions Log |
| `rfp-discovery-to-design` | Phases 1–2 — Client Context Brief, NFR Catalogue, Architecture Intent, SAD, Fit/Gap |
| `rfp-assembler` | Phases 3–4 — Risk Register, Compliance Matrix, Executive Summary, Assumptions & Exclusions |

---

## Customisation

See `CUSTOMISE.md` for the full customisation guide — folder mapping, principles setup, ADR seeding, Cursor glob configuration, and how to add organisation-specific rules and skills.
