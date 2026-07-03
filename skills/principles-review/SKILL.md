---
name: principles-review
description: Audits a document or decision against the active Architecture Principles in principles.md. Identifies which principles apply, classifies each as Satisfied / Neutral / In Tension / Conflicted, surfaces tensions and implied new principles, and offers to update the ADR Principles field or propose new principle additions. Use when the user asks to "check this against our principles", "principles review", "does this conflict with any principles", or "which principles apply here".
---

# Principles Review

Audits any architecture artifact or decision against the active principles in `principles.md`. Makes the principles file a **living governance tool** rather than a document written once and forgotten — surfacing where decisions align with, tension, or outright conflict with the organisation's stated architecture values.

## When to use

- "Check this against our principles"
- "Principles review of this ADR"
- "Does this conflict with any principles?"
- "Which principles apply here?"
- "Should this become a new principle?"
- Proactively when completing `adr-generator` — the Principles field should be populated

---

## Workflow

```
- [ ] Step 1: Repo discovery and load principles
- [ ] Step 2: Accept the target artifact
- [ ] Step 3: Map principles to the artifact
- [ ] Step 4: Classify each relevant principle
- [ ] Step 5: Check for implied new principles
- [ ] Step 6: Produce the review output
- [ ] Step 7: Offer follow-up actions
```

---

### Step 1 — Repo discovery and load principles

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
```

Read `$REPO_ROOT/AGENTS.md` and extract:
- `PRINCIPLES` — principles file (default: `principles.md`)

Load `$PRINCIPLES`. If absent:
- Inform the user that `principles.md` does not exist
- Offer to create it from `ea-practice/principles-template.md`
- Do not proceed with the review until the file exists or the user provides principles to review against

Extract the list of **Active** principles only. Proposed principles are noted but treated as advisory. Superseded principles are ignored.

---

### Step 2 — Accept the target artifact

The review can operate on:
- A file path (e.g. `TechnologyArchitecture/ADR-0003-api-gateway-selection.md`) — read the file
- Pasted content in the conversation
- A decision described in natural language

If a file path is provided, read the full file content. If the file is long (> 500 lines), ask the user to identify the sections that contain the recommendations and decisions — focus the review there rather than reviewing documentation or context sections.

Note the **document type** (ADR, architecture artifact, design doc, meeting notes) — this affects which dimensions to emphasise in the review.

---

### Step 3 — Map principles to the artifact

For each Active principle in `principles.md`:

1. **Is this principle relevant to this artifact?** A principle is relevant if:
   - The artifact makes a decision or recommendation that the principle is designed to govern
   - The artifact describes a capability, technology, or pattern that the principle applies to
   - The principle's implications directly affect the design choices in the artifact

2. Mark relevant principles for classification in Step 4. Skip irrelevant principles — do not include them in the review output (it adds noise without value).

If fewer than two principles are relevant to a significant decision-making artifact (e.g. an ADR), that is itself a finding — either the principles file is too sparse, or the artifact is not engaging with architecture governance.

---

### Step 4 — Classify each relevant principle

For each relevant principle, classify it as one of:

| Classification | Meaning |
|----------------|---------|
| **Satisfied** | The artifact explicitly follows this principle; the implication is addressed |
| **Neutral** | The principle applies to the domain but this artifact neither advances nor violates it |
| **In Tension** | The artifact makes choices that partially conflict with this principle; both directions have merit and the tension is acknowledged |
| **Conflicted** | The artifact explicitly or implicitly violates this principle; the conflict is not acknowledged |

For **In Tension** and **Conflicted** findings, record:
- The specific text in the artifact that creates the tension or conflict
- The specific implication of the principle that is not met
- A suggested resolution or escalation path

**Important:** distinguish between "In Tension" and "Conflicted". Tension is a known trade-off where the decision is defensible but the principle is not fully satisfied. Conflict is a violation where the principle's intent is not met and there is no stated justification. Conflicted findings require explicit remediation.

---

### Step 5 — Check for implied new principles

After classifying, scan for architecture assertions in the document that:
- Are stated as universal rules ("we will always…", "no system should ever…")
- Would apply broadly to future decisions of the same type
- Are not currently captured in `principles.md`

For each candidate, assess:
- Is this broad enough to be a principle (applies across multiple future decisions) or specific enough to be an ADR (applies to this decision class)?
- Is it already covered, even loosely, by an existing Active principle?

If a genuinely new principle is implied: note it as a candidate with a draft `P-NN (Proposed)` entry. Do not add it to `principles.md` directly — the Architecture Board must approve it. Present it as a proposal.

---

### Step 6 — Produce the review output

```markdown
## Principles Review — <document name>

**Reviewed against:** `principles.md` (Active principles only)
**Date:** YYYY-MM-DD
**Relevant principles identified:** <N> of <total Active>

---

### Findings

| Principle | Classification | Finding |
|-----------|---------------|---------|
| P-NN — <Name> | Satisfied / Neutral / In Tension / Conflicted | <specific finding — cite the text that satisfies or conflicts> |
| … | | |

---

### Tensions and conflicts — detail

#### P-NN — <Name> [In Tension / Conflicted]

**Principle implication:** <the specific implication from principles.md that is relevant>

**Artifact text creating tension/conflict:** `<quote or paraphrase>`

**Assessment:** <why this is In Tension vs Conflicted; what the consequence is if left unresolved>

**Suggested resolution:**
- Option A: <how to bring the artifact into alignment with the principle>
- Option B: <how to document a justified exception — if this is defensible>
- Option C: <if the principle is outdated, propose a principles.md update>

---

### Implied new principles

| Candidate | Draft statement | Recommendation |
|-----------|----------------|----------------|
| <P-next (Proposed)> | <draft principle name and brief rationale> | Bring to Architecture Board for review |

---

### Summary

<One paragraph: overall alignment assessment, the most important finding, and the recommended next step — whether that is updating the ADR Principles field, resolving a conflict, escalating to the board, or proposing a new principle.>
```

Be specific in every finding. "Partially satisfies P-02 because the decision chose to build a custom component rather than reusing an existing platform service, with no stated justification for the deviation" is useful. "Could be more aligned with reuse principles" is not.

---

### Step 7 — Offer follow-up actions

After delivering the review, offer:

1. **Update the ADR Principles field** — if the target is an ADR, offer to rewrite the Principles field with the correct P-NN citations from this review.
2. **Add conflict justification** — for Conflicted findings, offer to draft a justification paragraph for the **Context** or **Consequences** section of the ADR.
3. **Propose new principles** — for any implied new principle candidates, offer to draft a `P-NN (Proposed)` entry for `principles.md` ready for Architecture Board review.
4. **Escalate to board** — for material Conflicted findings (where the conflict affects multiple future decisions), suggest adding it to the Architecture Board agenda.

For each offer, be specific about the change. Do not apply any changes without confirmation.
