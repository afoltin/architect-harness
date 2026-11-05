---
name: assignment-design
description: Step 2 of an interview architecture assignment. Turns the confirmed scope into requirements, 3–5 short decision records with honest trade-offs, C4 diagrams, key flows, security, a migration path and risks — vendor-neutral unless the brief names a vendor. Use when "design the solution", "work on the assignment design", "what are my options", or "help me with the trade-offs" is asked for an assignment.
---

# Assignment Design

Step 2 of 4. Reads `intake.md` from `assignment-intake` and fills `design/`. The document itself is written later by `assignment-deliverable`. Here you produce the thinking it is based on.

## Before you start

1. Read `assignments/<company>-<slug>/intake.md`.
2. **Check the gate.** If the scope contract is not confirmed by the user, stop and go back to `assignment-intake`.
3. Note the **mode** (write or coach), the **main reader**, whether a **vendor** is named, and whether **cost or effort** is asked.
4. Note the time budget for this phase. Tell the user when about half of it is used.

**Coach mode:** do every step below as questions to the user and checks of their answers. Do not write the content yourself.

## Rules for this step

- **Plain words.** No ADM headers, no ABB/SBB tables. Say "capability", "building block" or just the thing.
- **Vendor-neutral by default.** Name the kind of component ("managed relational database", "message broker", "identity provider", "API gateway"), not the product. Use product names only if the brief names a vendor or cloud.
- **Trace everything.** Each requirement links to a brief ask (B-NN), an assumption (A-NN) or an expected topic from the scope contract. Each decision links to requirements.
- **Stay inside the scope contract.** If you find something important that is out of scope, write it in `design/parking-lot.md` and tell the user. Do not design it.

## Workflow

```
- [ ] Step 1: Requirements (functional, quality, constraints)
- [ ] Step 2: Current situation (only if there is one)
- [ ] Step 3: Solution idea in one paragraph
- [ ] Step 4: Decision records (3–5)
- [ ] Step 5: Diagrams (c4-diagrams) and key flows
- [ ] Step 6: Security and data protection
- [ ] Step 7: Quality requirements check
- [ ] Step 8: Migration or roll-out path (only if needed)
- [ ] Step 9: Risks
- [ ] Step 10: Cost and effort (only if the brief asks)
- [ ] Step 11: Red-team pass
```

---

### Step 1 — Requirements

Write `design/requirements.md`. Keep it short: only what drives a decision.

```markdown
## Functional requirements
| ID | Requirement | Source |
|----|-------------|--------|
| F-01 | Customers can block a lost card at any time | B-02 |

## Quality requirements (with numbers)
| ID | Quality | Target | Source |
|----|---------|--------|--------|
| Q-01 | Availability of card authorisation | 99.95% per month | A-03 |
| Q-02 | Authorisation response time | 95% under 300 ms | B-04 |

## Constraints
| ID | Constraint | Source |
|----|-----------|--------|
| C-01 | Billing system stays on-premise until 2029 | brief §2 |
```

Every quality requirement needs a number. If the brief gives none, make an assumption (A-NN) and add it to `intake.md`.

---

### Step 2 — Current situation

Only if the brief describes an existing system. Write a short section in `design/solution.md`: what exists, what hurts, what must keep working. Name the gap between today and the target in plain words. This drives Step 8.

---

### Step 3 — Solution idea

One paragraph in `design/solution.md`: the main idea of the solution, as you would say it to the CTO in the lift. If you cannot write it in one paragraph, the design is not clear yet. Fix that before you go on.

---

### Step 4 — Decision records

Make one short record per key decision from the scope contract (at most five). Write them all to `design/decisions.md`. Each record fits on about half a page.

```markdown
## D-01 — <decision as a question, e.g. "How do the cloud CRM and the on-premise systems talk?">

**Context:** <2–3 sentences. Which requirements push this decision (F-, Q-, C-, A-).>

**Options:**
| | Option A: <name> | Option B: <name> | Option C: <name> |
|---|---|---|---|
| <criterion from requirements> | | | |
| <criterion> | | | |
| <criterion> | | | |

**Decision:** Option <X>.

**Why:** <2–4 sentences, linked to the criteria that matter most for this brief.>

**What we give up:** <the honest cost of this choice. Never empty.>

**What would change my mind:** <the fact or assumption that, if different, makes another option better.>
```

Rules:
1. **Two or three real options.** A "straw man" option that nobody would choose does not count. "Do nothing" or "keep the current system" is a real option when there is a current system.
2. **Criteria come from the requirements**, not from a generic list. Three to five criteria per decision.
3. **Use words in the table** (good / medium / weak, with a short reason), not fake-precise scores.
4. **"What we give up" is the most important line.** Judges test whether you see the cost of your choice.
5. **"What would change my mind"** prepares you for the defence: it is the answer to "why not option B?".

If a decision needs more than half a page, it is probably two decisions, or it is too deep for the scope.

---

### Step 5 — Diagrams and key flows

Use the `c4-diagrams` skill. Keep `design/diagrams/workspace.dsl`.

- **C1 System Context:** always.
- **C2 Container:** always.
- **C3 Component:** only if one container is the heart of the assignment.
- Keep each view at about 12 boxes or fewer.
- Vendor-neutral technology labels unless a vendor is named (for example "Relational database", "Message broker").

Then describe **one to three key flows** in `design/solution.md`, as numbered steps (for example "card payment is authorised" or "customer record is changed in the cloud and reaches billing"). Pick the flows that prove the hard parts of the design. A numbered list works in PDF and Word; a sequence diagram is optional.

---

### Step 6 — Security and data protection

A short section in `design/solution.md`. Cover only what fits this brief:

- Who can access what (identity, roles, service-to-service access)
- Data protection (classification of the main data, encryption, where data is stored)
- Regulations named in the brief, and what each one means for the design (one line each)
- Audit and logging
- The two or three biggest threats and the answer to each

Do not write a generic security catalogue.

---

### Step 7 — Quality requirements check

Add a table to `design/solution.md`: each quality requirement (Q-NN), how the design meets it, and Met / Partly / Not met. Every "Partly" or "Not met" needs a reason and becomes a risk or an open point. Be honest; a weak "Met" will be found in the defence.

---

### Step 8 — Migration or roll-out path

Only if there is a current system or the brief asks for a roll-out. Write `design/migration.md`:

- Two to four stages. Each stage has a clear end state that works on its own.
- For each stage: what changes, what stays, how you go back if it fails, what must be true before the next stage starts.
- Name the migration approach in plain words (for example "run both systems side by side and move customer groups one at a time").

You may use `roadmap-planner` for the thinking, but write the result in plain words, not as Transition Architectures.

---

### Step 9 — Risks

Write `design/risks.md`: five to eight risks, not more.

```markdown
| ID | Risk | Likelihood | Impact | What we do about it |
|----|------|-----------|--------|---------------------|
| R-01 | Legacy billing API cannot handle the extra load | Medium | High | Load test in stage 1; queue to smooth peaks (D-01) |
```

Specific risks only. "The project may be late" is not a risk entry.

---

### Step 10 — Cost and effort

Only if the brief asks (intake question 10). Give ranges, not single numbers, and list the assumptions behind them. Keep it vendor-neutral unless a vendor is named. If the brief does not ask, write nothing.

---

### Step 11 — Red-team pass

Before you hand over to `assignment-deliverable`, attack the design. For each decision record:

1. Write the strongest argument against it, as a sceptical CTO would say it.
2. Check that the record answers it. If not, improve the record or add the point to "What we give up".

Also check:
- Does every brief ask (B-NN) have an answer somewhere in `design/`?
- Did the design grow beyond the scope contract? If yes, move the extra to the parking lot.
- Can the one-paragraph solution idea still describe the design?

Write the red-team findings to `design/red-team.md`. `assignment-defence` uses this file.

---

## Output files

| File | Content |
|---|---|
| `design/requirements.md` | Functional, quality and constraints, with sources |
| `design/solution.md` | Current situation, solution idea, key flows, security, quality check |
| `design/decisions.md` | 3–5 short decision records |
| `design/diagrams/` | `workspace.dsl` and PNG files |
| `design/migration.md` | Only if needed |
| `design/risks.md` | 5–8 risks |
| `design/red-team.md` | Arguments against each decision and the answers |
| `design/parking-lot.md` | Important things that are out of scope |
