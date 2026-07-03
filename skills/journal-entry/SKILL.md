---
name: journal-entry
description: Generates a daily architecture journal entry from the day's git commits, following a candid first-person reflective format. Use when the user asks to "write today's journal", "write up my day", "draft the daily entry", or "journal my commits". Works for today by default; accepts an explicit date for back-filling.
---

# Journal Entry from Commits

Turns a day's git commits into a `journal/YYYY-MM-DD.md` entry. The journal is a candid, first-person working log — commits are the evidence; the entry is the reflection on them. Its value is honest framing of *what moved, what didn't, and why* — not a changelog.

## When to use

- "Write today's journal"
- "Write up my day"
- "Draft the daily journal entry"
- "Journal my commits"
- "Back-fill the journal for [date]"

---

## Workflow

Track progress through these steps:

```
- [ ] Step 1: Repo discovery — resolve paths from AGENTS.md
- [ ] Step 2: Establish date and gather commits
- [ ] Step 3: Establish continuity with the previous entry
- [ ] Step 4: Map commits to work blocks
- [ ] Step 5: Write journal/YYYY-MM-DD.md
- [ ] Step 6: Review for honesty + voice, then offer to commit
```

---

### Step 1 — Repo discovery

Before any file operations, resolve the paths this skill needs.

```bash
# Repo root
REPO_ROOT=$(git rev-parse --show-toplevel)
```

Read `$REPO_ROOT/AGENTS.md` and extract:
- `JOURNAL_DIR` — the journal folder (default: `journal/`)
- `ACTION_ITEMS` — the action-items file (default: `ea-practice/action-items.md`)
- `PRINCIPLES` — the principles file (default: `principles.md`)

If `AGENTS.md` does not exist or does not define these paths, use the defaults above and note the assumption.

All subsequent paths are relative to `REPO_ROOT`.

---

### Step 2 — Date and commits

Default to today's date from the system (`date +%F`). If the user provides a date, use it.

```bash
DAY=YYYY-MM-DD   # the target date

git log \
  --after="$DAY 00:00" \
  --before="$DAY 23:59" \
  --author="$(git config user.name)" \
  --stat
```

- Use `--stat` for the overview of which files moved.
- For any commit whose intent isn't clear from its message + stat, read its detail: `git show <hash> --stat` first, then a scoped diff only if needed. Do not paste large diffs into the entry.
- If there are **no commits** for the day: tell the user and ask whether to write a no-commit entry (some days are meetings or thinking) or pick a different date. Do not fabricate work.
- A commit that only adds the previous day's journal entry is housekeeping; mention it only if relevant.

---

### Step 3 — Continuity

The entry's framing depends on what the previous entry said. Find the most recent file in `$JOURNAL_DIR` before the target date.

- Read its **`## End of day (one line)`** and any "Tomorrow:" line — these state what today was *supposed* to be.
- Step 5's "Why this entry" section must honestly check today's work against that expectation.
- The `Previous:` link in the header points to that file.
- If days were skipped, note why inline (e.g. `Weekend (Sat–Sun) not worked.` or `Gap since [date] — travel.`). Do not invent a reason; if unknown, state the gap plainly or ask.

---

### Step 4 — Map commits to work blocks

Group related commits into **1–4 narrative work blocks**. Do not write one bullet per commit.

For each block:
- Name *what moved* and *why it matters* — not just what files changed.
- Link every artifact touched with a path relative to the journal file (e.g. `../ea-practice/foo.md`).
- Where work closes or advances an action item, cite it as `#NNN` (check `$ACTION_ITEMS` for the correct number and current status).
- Where a decision rests on or conflicts with a principle, cite it by ID and name: *per P-03 Reuse before invent*.
- If a commit represents an architecturally significant decision with real trade-offs, flag it to the user: *"This may warrant an ADR (see `.cursor/rules/adr-and-decisions.mdc`) — want me to offer one?"* Do not silently skip it.

---

### Step 5 — Write the file

Create `$JOURNAL_DIR/YYYY-MM-DD.md` using the format template below. Match the section order and separator style exactly — the journal's value accrues through consistent structure across entries.

Do **not** add the TOGAF ADM-phase header block. The journal is a cross-cutting working log; it uses its own format.

#### Format template

```markdown
# Architecture Journal — <D Month YYYY>

**<Weekday> · <Location — e.g. Remote / Office / Client site>**

*Daily entry. Previous: [<D Month YYYY>](<YYYY-MM-DD>.md).<optional gap note, e.g. " Weekend (6–7 Jun) not worked.">*

---

## Why this entry

<One paragraph. Frame today against what the previous entry's "End of day" / "Tomorrow" line said today should be, and be honest about whether it happened. Summarise the day's work blocks at a high level. If today drifted from plan, lead with that — don't bury it.>

---

## Today's specific work

### 1. <Short title — what moved>

<Prose. Link artifacts with relative paths. Cite #NNN action items and P-NN principle IDs where they apply. Explain why the work matters, not just what changed.>

### 2. <Short title>

<…>

---

## Hypotheses & checkpoint

### Confirmed today

- <What today proved or settled.>

### Still testing

- <Open question this work raises; the concrete test that will resolve it.>

### Tension / risk

- <Honest naming of what is fragile, deferred, or substituting for harder work.>

---

## Documentation produced today

- [<path>](../<path>) — <what it is and which #NNN it closes or advances>.

---

## Gut feeling

<Candid first-person reflection. Name avoidance and trade-offs plainly. End with what tomorrow has to be.>

---

## End of day (one line)

*<One sentence: what moved today + tomorrow's focus.>*
```

---

### Step 6 — Review and offer to commit

Re-read the draft against the voice and honesty rules below. Then offer to commit the file. The convention is a short commit message, e.g. *"journal: add entry for YYYY-MM-DD"*. Do not commit unless the user agrees.

---

## Voice & honesty rules

The reflective sections are the point of the journal. Match this tone:

- **First person, candid, specific.** Name artifacts, action numbers, and decisions. No corporate gloss.
- **Honest about gaps.** If today's work was hygiene or tooling while a harder deliverable slipped, say so. An entry that reads as uniformly positive is probably not honest.
- **Evidence-led.** Every work block traces to a real commit. Do not claim closure that the commits don't support.
- **Tie to the bigger picture.** Connect the day's work to business drivers, open action items, or principles where it genuinely applies — not as a formula.

## Anti-patterns

- One bullet per commit — this is a changelog, not a journal.
- Pasting diffs or large file contents into the entry.
- A relentlessly positive Gut feeling when the day clearly drifted.
- Inventing a reason for a gap, or claiming an item closed when the commits and action-items file don't support it.
- Adding the ADM-phase header block (it doesn't belong in the journal).
