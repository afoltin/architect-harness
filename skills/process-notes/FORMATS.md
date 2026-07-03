# Note Format Templates

## Conversation note

```markdown
# Conversation — <Full Name> (<Role>) — <D Month YYYY>

> **Topic:** <One-sentence summary of what was covered.>
>
> **Canonical actions:** [../../ea-practice/action-items.md](../../ea-practice/action-items.md)
> Opens: **#NNN** <short desc>; **#NNN** <short desc>.
> Enriches: **#NNN**, **#NNN**.
>
> *Open points:* <any unresolved questions from this conversation, or omit line if none>

---

## People / context

- **<Name>** — <role, relevant context>
- *(repeat for each participant)*

---

## <Topic section 1>

<Narrative or bullets — enough detail to reconstruct the conversation from this document alone>

### <Subtopic if needed>

<content>

---

## Implications / follow-ups

### New actions

- **#NNN — <Action title>** — <description; owner; deadline if stated; relates to which other items>

### Reinforced actions

- **#NNN — <Existing action title>:** <how this conversation enriches, changes direction, or resolves a blocker>

### Closed / de-risked

- *(Nothing closed)* **or** list closed items: **#NNN — <title>** — closed because <reason>.

---

## Abbreviations & new terms

| Term | Definition or context |
|------|-----------------------|
| **<TERM>** | <definition> |
```

---

## Board session note

```markdown
# Architecture Board — <D Month YYYY>

> **Status:** Post-meeting notes (logged <D Month YYYY>). Previous board: [<filename>](<filename>.md).
> Primary takeaway: <one sentence>.
>
> **Canonical actions:** [../../ea-practice/action-items.md](../../ea-practice/action-items.md)
> Opens: **#NNN** <short desc>. Enriches: **#NNN**, **#NNN**.
>
> **Related:** <other relevant docs with relative links>

---

## Logistics

| Field | Value |
|-------|-------|
| **Date** | <date> |
| **Format** | Remote / On-site / Hybrid |
| **Quorum** | Met / Not met |

### Present

- <Name> (<role>)
- *(repeat)*

### Apologies

- *(if any)*

---

## <Agenda item / main topic 1>

<Summary of discussion, key points raised, outcome — enough for an absent stakeholder to understand what happened>

### <Subtopic if needed>

<content>

---

## <Agenda item / main topic 2>

<content>

---

## Decisions & governance outcomes

| Decision | Owner | Status | Next move |
|----------|-------|--------|-----------|
| <decision text> | <name> | Approved / Deferred / Rejected | <ADR, action #NNN, or next board> |

---

## Action items

| # | Action | Owner | Due | Notes |
|---|--------|-------|-----|-------|
| NNN | <description> | <name> | <date or "next board"> | <context> |

---

## Parking lot

*(Anything raised but deferred, not resolved, or needs more information before returning to the board)*

- <item> — <why deferred, what's needed>
```

---

## Canonical-actions block quote — rules

- List every `#NNN` the note **opens** (new) and every `#NNN` it **enriches** (adds new detail, changes direction, resolves a blocker).
- Use bold `**#NNN**` for every reference.
- Write this block quote **after** the full note is drafted, so `#NNN` assignments are final before the summary is written.
- "Enriches" means substantive new information — not just a passing mention of the item.
- A note that opens no new actions and enriches no existing ones is unusual; check whether the meeting produced no commitments or whether you missed them.

---

## Relative path convention

Notes live two levels below repo root (e.g. `process/ConversationNotes/`). Use `../../` to reference root-level files:
- `../../ea-practice/action-items.md`
- `../../principles.md`
- `../../Glossary.md`

For notes in `process/ArchitectureBoardMeetings/`, the same `../../` convention applies.

For cross-references within `process/`, use `../` to move up one level.
