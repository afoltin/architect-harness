---
name: assignment-intake
description: Step 1 of an interview architecture assignment (a take-home case for a Solution Architect job, usually followed by a presentation). Asks the set-up questions, reads the brief, fixes the scope, lists questions and assumptions, and makes a time plan. Use when "I got an assignment", "new interview case", "take-home case", "start an assignment", or "practice assignment" is said.
---

# Assignment Intake

Step 1 of 4 for a job interview assignment. The other steps are `assignment-design`, `assignment-deliverable` and `assignment-defence`.

The main job of this step is to **stop the work from growing too big**. Most candidates lose points by doing too much and explaining too little. The scope you fix here is a contract: later steps follow it.

## How this differs from the RFP skills

| RFP pursuit | Interview assignment |
|---|---|
| A team, weeks, a real client | One person, a time budget, a fictional or anonymised client |
| About 20 documents | One document (and maybe slides) |
| Judged on compliance and price | Judged on how you think, decide and explain |
| TOGAF words are welcome | TOGAF words often look heavy. Use plain words. |

Use TOGAF only as a thinking tool in the background (baseline, target, gap, building blocks). Do **not** put ADM headers, ABB/SBB tables or TOGAF jargon into assignment files unless the user says the company expects it. The AGENTS.md header rule does not apply to `assignments/`.

## Workflow

```
- [ ] Step 1: Ask the set-up questions (every time, no silent defaults)
- [ ] Step 2: Create the assignment folder
- [ ] Step 3: Read the brief and list what it asks
- [ ] Step 4: Find what the judges will expect but the brief does not say
- [ ] Step 5: Write the scope contract
- [ ] Step 6: Questions to the company, and assumptions
- [ ] Step 7: Time plan
- [ ] Step 8: Gate — the user confirms the scope
```

---

### Step 1 — Ask the set-up questions

Ask **all** of these at the start of every assignment, in one message. You may show a suggested answer, but the user must confirm each one. Never fill one in yourself.

| # | Question | Suggested answer | Why it matters |
|---|---|---|---|
| 1 | What is your time budget in hours? | 20 | Sets the time plan and the depth of the work. |
| 2 | What is the deadline (date and time)? | — | Sets the calendar. |
| 3 | What must you hand in: a document, slides, or both? Which file type (PDF, Word, PowerPoint)? | Document as PDF | Decides what `assignment-deliverable` makes. |
| 4 | Is there a page or slide limit? | None given | Hard limit on length. |
| 5 | Who will read it and sit in the panel: hiring manager, CTO, Enterprise Architect, Solution Architect? Who is the most important reader? | — | Decides the tone, the depth and the defence questions. |
| 6 | How long is the presentation, and is it based on the written document? | 1 hour, based on the document | Sets the talk plan in `assignment-defence`. |
| 7 | May you ask the company questions before you hand in? | Unknown | If yes, we send questions. If no or unknown, we write assumptions. |
| 8 | Is AI help allowed for this assignment? | Yes | Yes → **write mode**. No → **coach mode** (see below). |
| 9 | Does the brief name a vendor, cloud or product? | No | If no, the design stays vendor-neutral. |
| 10 | Does the brief ask for cost or effort estimates? | No | Only if yes, `assignment-design` estimates them. |
| 11 | What do you know about the company and the role (industry, size, level)? | — | Helps to guess what the judges care about. |

If the user answers "unknown" to question 7, suggest asking the recruiter. It is a normal question and it shows good practice.

**Write mode and coach mode.** In write mode the skills write drafts, and the user reviews and owns them. In coach mode the skills never write text for the deliverable. They ask questions, give structure and check the user's own drafts against the checklists. Record the mode in `intake.md`. All four skills read it.

---

### Step 2 — Create the assignment folder

```
assignments/<company>-<slug>/
  brief/            the original brief, unchanged (copy the file in)
  intake.md         this step
  design/           assignment-design
    diagrams/       workspace.dsl and PNG files (c4-diagrams)
  deliverable/      assignment-deliverable
  defence/          assignment-defence
```

Ask the user for the company name and a short slug if not given. For a practice case use `practice-<slug>`.

**No brief yet?** Offer a practice brief from `practice-briefs.md` in this skill folder.

---

### Step 3 — List what the brief asks

Read the whole brief. Write each explicit ask as one line with an ID. Quote the brief's own words where you can.

```markdown
## What the brief asks

| ID | Ask (brief's words) | Where in brief | Type |
|----|---------------------|----------------|------|
| B-01 | "Design a solution for ..." | §2 | Must answer |
| B-02 | "Explain how you would migrate ..." | §3 | Must answer |
| B-03 | "Optional: estimate the cost" | §5 | Optional |
```

Also note:
- **Facts given:** numbers, systems, constraints, regulations. List them; they become requirements later.
- **Contradictions and traps:** requirements that fight each other, unrealistic numbers, missing information. Name each one. Spotting them is often part of the test.

---

### Step 4 — What the judges will expect

Some things are rarely written in a brief but almost always judged. Check each one and decide: in scope, short mention, or out of scope.

| Expected topic | Usually |
|---|---|
| Clear statement of the problem and the goal | Always |
| Assumptions written down | Always |
| Non-functional requirements with numbers (availability, performance, scale) | Always |
| Security and data protection | Always |
| Key decisions with options and trade-offs | Always — this is the core of the test |
| Diagrams (C4 context and container) | Always |
| Migration or transition plan | When there is an existing system |
| Risks and how to reduce them | Always, short |
| Operations (monitoring, support) | Short mention |
| Cost and effort | Only when the brief asks (question 10) |
| Team and delivery approach | Only when the brief asks |

Then write, in two or three sentences, **what this assignment is really testing**. For example: "They want to see if I can move a legacy system step by step without stopping the business." Every later choice should serve this sentence.

Use the main reader (question 5) to sharpen it:

| Reader | Looks mostly for |
|---|---|
| Hiring manager | Clear thinking, clear writing, business value, how you work with people |
| CTO | Risk, cost of being wrong, fit with strategy, strong decisions |
| Enterprise Architect | Fit with the wider landscape, standards, principles, roadmap |
| Solution Architect | Technical depth, integration, NFRs, realistic details |

---

### Step 5 — Scope contract

Write the scope into `intake.md`:

```markdown
## Scope contract

**What this assignment is really testing:** <2–3 sentences>

**In scope (deep):** <max 3–5 topics, each linked to B-NN or an expected topic>
**In scope (short, one paragraph each):** <topics>
**Out of scope (said openly in the document):** <topics, each with one reason>

**Key decisions to make:** <max 3–5. Each one must matter to "really testing".>
```

Rules against doing too much:
1. **Deep topics: at most five.** If there are more, ask the user which ones to drop to "short".
2. **Key decisions: at most five.** A sixth decision needs one of the five to be removed.
3. **Every topic must link to a brief ask (B-NN) or an expected topic.** If it links to nothing, it is out.
4. **"Out of scope" is a strength, not a weakness.** A clear out-of-scope list shows judgement. It goes into the document.

---

### Step 6 — Questions and assumptions

**If questions are allowed (question 7 = yes):** write at most 5 to 8 questions. Each must be answerable and must change the design. "Will the new system replace the legacy billing system, or run next to it?" is good. "Tell us more about your landscape" is not. Give each question the B-NN or decision it affects.

**In every case:** write the assumptions you will work with until you get answers.

```markdown
## Assumptions

| ID | Assumption | Why it is reasonable | If wrong, what changes |
|----|-----------|----------------------|------------------------|
| A-01 | Peak load is 500 transactions per second | Brief says 2 million customers; typical card usage | Data store and scaling choice (D-02) |
```

Prefer numbers to words. "High availability" is not an assumption; "99.9% per month" is.

---

### Step 7 — Time plan

Split the time budget (question 1). Default split, adjust with the user:

| Phase | Share | Skill | Example for 20 h |
|---|---|---|---|
| Intake and scope | 10% | assignment-intake | 2 h |
| Design | 35% | assignment-design | 7 h |
| Writing the deliverable | 30% | assignment-deliverable | 6 h |
| Review and polish | 10% | assignment-deliverable | 2 h |
| Defence preparation | 15% | assignment-defence | 3 h |

Put the time plan, with calendar dates up to the deadline, in `intake.md`. Ask the user to tell you the hours spent at the end of each phase. If a phase goes more than 25% over, say so plainly and suggest what to cut. Do not quietly let the scope grow.

---

### Step 8 — Gate: confirm the scope

Show the user the scope contract, the assumptions and the time plan. Ask them to confirm or change them. **Do not start `assignment-design` before the user confirms.**

After the gate, scope changes are allowed, but only openly: write what is added, what is dropped to pay for it, and the date, under "Scope changes" in `intake.md`.

---

## Output files

| File | Location |
|---|---|
| `intake.md` (set-up answers, mode, brief asks, scope contract, questions, assumptions, time plan, scope changes) | `assignments/<company>-<slug>/` |
| The original brief | `assignments/<company>-<slug>/brief/` |
