---
name: process-notes
description: Converts raw meeting or conversation notes (typed bullets or transcript) into a properly formatted markdown file, stores it in the correct directory, then produces a list of suggested artifact updates and new artifact proposals. Use when the user pastes raw notes, says "process my notes", "convert my notes", "write up the meeting", or similar.
---

# Process Notes

Converts raw notes into structured markdown, files them correctly, and produces a prioritised list of suggested artifact updates and new artifact proposals — turning a meeting into actionable architecture work rather than a document that gets filed and forgotten.

## When to use

- "Process my notes"
- "Convert my notes"  
- "Write up the meeting"
- Paste of raw bullets, a transcript, or rough notes
- "File these notes from [person/date]"

---

## Workflow

```
- [ ] Phase 1: Repo discovery — resolve paths from AGENTS.md
- [ ] Phase 2: Detect note type and extract metadata
- [ ] Phase 3: Format and write the file
- [ ] Phase 4: Produce artifact update suggestions
- [ ] Phase 5: Produce new artifact proposals
- [ ] Phase 6: ADR trigger check
```

---

### Phase 1 — Repo discovery

Before any file operations, resolve the paths this skill needs.

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
```

Read `$REPO_ROOT/AGENTS.md` and extract:
- `NOTES_CONV_DIR` — conversation notes directory (default: `process/ConversationNotes/`)
- `NOTES_BOARD_DIR` — board meeting notes directory (default: `process/ArchitectureBoardMeetings/`)
- `ACTION_ITEMS` — action items master list (default: `ea-practice/action-items.md`)
- `ADR_DIR` — ADR directory (default: `TechnologyArchitecture/`)
- `STAKEHOLDER_MAP` — stakeholder map file (default: `BusinessArchitecture/Organization/StakeholderMap.md`)
- `APP_LANDSCAPE` — application landscape map (default: `ApplicationArchitecture/ApplicationLandscapeMap.md`)

If `AGENTS.md` does not define a path, use the default and note the assumption.

Check which of these files actually exist before suggesting updates to them. If a file doesn't exist, suggest creating it rather than updating a phantom.

---

### Phase 2 — Detect note type and extract metadata

From the raw input, determine:

| Question | What to look for |
|----------|-----------------|
| **Conversation or board session?** | Board: mentions "architecture board", "ARB", formal agenda, multiple named attendees with roles; Conversation: 1-on-1 or small group, no formal agenda |
| **Date** | Any explicit date in the input; if absent, **ask before proceeding** |
| **Participants** | Names and roles; for conversations the primary person's name goes in the filename |
| **Topic(s)** | Main subjects discussed |
| **New action items** | Any "to-do", commitments, named owners |
| **Enriched existing actions** | Any reference to existing `#NNN` items or known threads (check `$ACTION_ITEMS`) |
| **Architecturally significant decisions** | Apply the three criteria from `adr-and-decisions.mdc`: reusable + architecturally significant + trade-offs considered |
| **New people, roles, or systems** | Names or tools not previously in the workspace |
| **Principles cited or challenged** | Any reference to existing principles or a new principle implied |

If the date is missing, **stop and ask** before proceeding. A note without a date cannot be filed correctly.

---

### Phase 3 — Format and write the file

#### Filename convention

| Type | Pattern | Example |
|------|---------|---------|
| Conversation | `NotesConversation_<PersonOrTopic>_DD-MM-YYYY.md` | `NotesConversation_Sarah_Chen_25-06-2026.md` |
| Board | `NotesArchitectureBoard_DD-MM-YYYY.md` | `NotesArchitectureBoard_25-06-2026.md` |

Use hyphens only; no spaces. For multi-person conversations use the primary person's name or a short topic slug.

#### Target directory

| Type | Directory |
|------|-----------|
| Conversation | `$NOTES_CONV_DIR` |
| Board | `$NOTES_BOARD_DIR` |

Create the directory if it doesn't exist.

#### Format

Apply the template from `FORMATS.md` (in the same directory as this skill) for the detected note type.

Rules that apply to **both** types:
- The canonical-actions block quote is the most important element — list every `#NNN` the note opens or enriches.
- Action items in the body use bold `**#NNN — description**`. Assign the next free number by inspecting `$ACTION_ITEMS`.
- Cross-references use relative paths from the file's location.
- If the TOGAF domain is clearly constrained (e.g. a data architecture conversation), add the four-line ADM-phase header block from `togaf-core.mdc`.
- Write the canonical-actions block quote **after** drafting the full note, so `#NNN` assignments are final before the summary is written.

---

### Phase 4 — Artifact update suggestions

After writing the file, scan the content and produce a **numbered suggestion list**. For each suggestion state: the artifact, what to add or change, and why it matters.

#### Always check

| Artifact | What to look for |
|----------|-----------------|
| `$ACTION_ITEMS` | New actions to add; enrichments to existing `#NNN` items (new information, changed direction, resolved blocker) |
| `ea-practice/topics.md` | New recurring topics that don't yet have a slot (if file exists) |

#### Check if relevant

| Artifact | Trigger |
|----------|---------|
| `$APP_LANDSCAPE` | New system, application, or vendor mentioned |
| `$STAKEHOLDER_MAP` | New person, role change, updated decision rights, or new last-interaction date |
| `ea-practice/managementPriorities.md` | A priority changed, unblocked, or a new one emerged (if file exists) |
| `transformation/<name>/` | A transformation theme advanced or a new programme-level item appeared |
| `Glossary.md` | New term or acronym introduced |
| `principles.md` | A principle was cited, challenged, or a new one seems implicit in the discussion |

For each suggested update, state it as a concrete action: "Add `#NNN — [description]` to `$ACTION_ITEMS`" rather than vague "update action items".

If a suggested artifact doesn't exist, frame the suggestion as "Create `<path>` — [one-line rationale]" rather than "Update `<path>`".

---

### Phase 5 — New artifact proposals

If the note introduces a subject with no existing home in the workspace, propose a new artifact. Frame every proposal using the TOGAF domain mapping from `AGENTS.md`:

| TOGAF phase | Folder |
|-------------|--------|
| B — Business | `BusinessArchitecture/` |
| C — Applications | `ApplicationArchitecture/<SystemName>/` |
| C — Data | `DataArchitecture/` |
| D — Technology | `TechnologyArchitecture/` |
| E/F — Programme | `transformation/<ProgrammeName>/` |
| Cross-cutting | `ea-practice/` |

Present each proposal as:
> **New artifact suggestion:** `<path>` — *one-sentence rationale citing the TOGAF phase and the driver from the notes.*

Do **not** create new files or directories speculatively. Present proposals and wait for confirmation.

---

### Phase 6 — ADR trigger check

Apply the three criteria from `adr-and-decisions.mdc`:
1. Reusable — will guide future similar choices
2. Architecturally significant — touches platform, integration, data ownership, vendor choice, or cross-cutting principle
3. Trade-offs were considered — at least two real options were weighed

If all three hold, ask **once**: *"This looks like it may warrant an ADR — capture it as ADR-NNNN?"*

If yes, draft the ADR end-to-end using `adr-and-decisions.mdc` format. Do not stop at a stub.

---

## Output order

1. The formatted note file (write it).
2. **Artifact update suggestions** — numbered, concrete actions from Phase 4.
3. **New artifact proposals** — from Phase 5, each with TOGAF-framed rationale.
4. **ADR offer** — from Phase 6, once only, if warranted.
