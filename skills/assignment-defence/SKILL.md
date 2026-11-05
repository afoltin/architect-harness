---
name: assignment-defence
description: Step 4 of an interview architecture assignment. Prepares the presentation of the submitted document — a talk plan for the session length, a question bank built for the panel, a weak-points sheet — and runs a mock panel that grills the user one question at a time and scores the answers. Use when "prepare my presentation", "grill me on my assignment", "mock interview panel", or "what will they ask" is asked.
---

# Assignment Defence

Step 4 of 4. Reads `intake.md`, `design/` (especially `decisions.md` and `red-team.md`) and the final document in `deliverable/`. Writes `defence/`.

The panel does not only check the design. It checks whether you can **explain it, defend it, and change it when they push back**. A good defence often matters more than the document.

This skill works the same way in write mode and coach mode: the user must give the answers. The skill asks, scores and gives feedback.

## Workflow

```
- [ ] Step 1: Talk plan
- [ ] Step 2: Question bank
- [ ] Step 3: Weak-points sheet
- [ ] Step 4: Mock panel (interactive)
- [ ] Step 5: Fix list and last rehearsal
```

---

### Step 1 — Talk plan

Read the session length from `intake.md` (question 6, usually 1 hour). Default split for 60 minutes:

| Part | Minutes | Content |
|---|---|---|
| Opening | 3 | Who you are, what you will show, how long |
| Problem and scope | 5 | What they asked, what you covered and left out |
| Solution | 10 | Solution idea, C1 and C2 diagrams, one key flow |
| Key decisions | 10 | Each decision: choice, why, what you give up |
| Risks and next steps | 2 | Top risks, what you would do first |
| Questions | 30 | Panel questions |

Write `defence/talk-plan.md`: for each part, the main message in one sentence, the slide or document page you show, and two or three points to say. Do not write a full script. A script makes people read instead of talk.

If there are no slides, plan which document pages and diagrams to show on screen.

---

### Step 2 — Question bank

Write `defence/question-bank.md`: 25 to 40 likely questions, grouped. For each question, add a short model answer (3–5 bullet points) and the place in the document that supports it. In coach mode, leave the model answers empty for the user to fill.

Sources for the questions:

1. **Each decision record:** "Why not option B?", "What would make you change this?", "What does this cost you?" The answers are in "What we give up" and "What would change my mind".
2. **`red-team.md`:** every argument against a decision becomes a question.
3. **Each assumption:** "What if this number is ten times higher?"
4. **Each "Partly" in the quality check** and each high risk.
5. **Out of scope items:** "Why did you leave out X?"
6. **Change of requirements (live revision):** "The budget is now half. What do you change?", "We must go live in 6 months, not 18." These test whether you can adapt your design on the spot. Prepare at least three.
7. **Questions by reader type** (use the panel from intake question 5):

| Reader | Typical questions |
|---|---|
| Hiring manager | How would you explain this to the business? How would you get the teams to agree? What did you find hardest? |
| CTO | What is the biggest risk? What does it cost if we are wrong? How does this fit our strategy? What would you do in the first 90 days? |
| Enterprise Architect | How does this fit the existing landscape? Which standards or principles does it follow or break? What does the roadmap look like after this? |
| Solution Architect | What happens when component X fails? How do you handle data consistency between A and B? How does it scale to 10 times the load? How do you test and operate it? |

8. **Process questions:** "How did you use your time?", "What would you do with more time?", "Did you use AI tools?" Answer the AI question honestly, in line with the company's rules (intake question 8).

---

### Step 3 — Weak-points sheet

Write `defence/weak-points.md`: the three to five weakest parts of the submission, said honestly. For each one: why it is weak, what you would do with more time or information, and a short answer for the panel.

Naming a weak point before the panel does is a strength. Do not hide them.

---

### Step 4 — Mock panel

Run an interactive session. Rules:

1. Ask the user which panel to simulate (default: the readers from intake question 5) and how long (default 20 minutes, or 10 questions).
2. Play the panel. Say which role asks each question. **Ask one question at a time** and wait for the answer.
3. Start easy, then get harder. Ask at least one follow-up on a weak answer ("Why?", "And if that fails?"). Include at least one change of requirements.
4. Be sceptical, but fair and polite, like a real senior panel.
5. After each answer, give short feedback and a score from 1 to 5:

| Criterion | What good looks like |
|---|---|
| Direct | The answer comes in the first sentence. |
| Reasoned | It gives the reason and links it to a requirement or assumption. |
| Honest trade-off | It says what is given up or what is uncertain. |
| Short | Under about 90 seconds when spoken. |
| Consistent | It matches the document. |

6. At the end, give a summary: average score, the three weakest answers, and what to change.

Write the questions, answers, scores and feedback to `defence/mock-panel-<n>.md` (n = session number).

---

### Step 5 — Fix list and last rehearsal

From the mock panel, make `defence/fix-list.md`:
- Answers to improve (update `question-bank.md`).
- Problems in the document. If the document is already handed in, do not change it; prepare a spoken answer instead.
- Parts of the talk plan that ran too long.

Offer a second short mock panel on the weakest topics only. Stop when the user is satisfied or the time budget for this phase is used.

## Output files

| File | Content |
|---|---|
| `defence/talk-plan.md` | Minutes, messages and what to show |
| `defence/question-bank.md` | 25–40 questions with model answers and sources |
| `defence/weak-points.md` | 3–5 honest weak points and answers |
| `defence/mock-panel-<n>.md` | Record of each mock session |
| `defence/fix-list.md` | What to improve before the session |
