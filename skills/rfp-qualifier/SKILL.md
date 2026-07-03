---
name: rfp-qualifier
description: Phase 0 RFP qualification — runs the bid/no-bid scoring process, triages RFP requirements, structures the Open Questions Log, and produces the Bid/No-Bid Decision Record. Use when a new RFP lands and the team needs to decide whether to pursue it, or when "should we bid on this?", "qualify this RFP", "run the bid/no-bid", or "triage these requirements" is asked.
---

# RFP Qualifier

Phase 0 of the RFP pursuit workflow. Drives the go/no-go decision before committing architecture and delivery resources. Skipping this under commercial pressure is one of the most common — and costly — pursuit mistakes.

## When to use

- "Should we bid on this?"
- "Qualify this RFP"
- "Run the bid/no-bid"
- "Triage these requirements"
- A new RFP has landed and Phase 0 hasn't been run

---

## Workflow

```
- [ ] Step 1: Repo discovery — establish pursuit folder
- [ ] Step 2: Bid/No-Bid scoring
- [ ] Step 3: RFP requirements triage
- [ ] Step 4: Open Questions Log
- [ ] Step 5: Write Bid/No-Bid Decision Record
- [ ] Step 6: Confirm go/no-go with pursuit lead
```

---

### Step 1 — Repo discovery and pursuit folder

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
```

Read `$REPO_ROOT/AGENTS.md` for the pursuits directory (default: `pursuits/`).

Confirm or establish the pursuit folder:
```
pursuits/<client-name>-<engagement-slug>/Phase0/
```

If the folder doesn't exist, create it. All Phase 0 artifacts write here. Ask the user for the client name and a short engagement slug if not provided.

---

### Step 2 — Bid/No-Bid scoring

Score the opportunity across five dimensions. Each dimension is scored 1–5. The total guides the recommendation; it does not replace judgement.

| Dimension | Score (1–5) | Scoring guide |
|-----------|-------------|---------------|
| **Strategic fit** | | 1 = outside core capability / market; 5 = direct fit to strategic growth area |
| **Win probability** | | 1 = incumbent entrenched, no relationship; 5 = known client, preferred supplier status |
| **Margin potential** | | 1 = cost-plus with thin margin; 5 = outcome-based or high IP-leverage opportunity |
| **Resource availability** | | 1 = key roles unavailable; 5 = right team ready to deploy |
| **Delivery risk** | | 1 = high unknowns, tight timeline, complex dependencies; 5 = well-understood scope |

**Scoring guide:**
- **≥ 20:** Strong bid — proceed
- **15–19:** Conditional bid — identify the weak dimensions and whether they can be mitigated before committing
- **10–14:** Marginal — bid only if there is a strategic reason beyond this opportunity (relationship, market entry)
- **< 10:** No-bid recommended

Additional qualitative factors to surface (not scored, but must be noted):
- Is there an incumbent? What is the relationship and switching cost?
- Are there budget signals — is this a genuine procurement or a market-benchmarking exercise?
- Are there regulatory or compliance constraints that create delivery risk?
- Is the timeline realistic for the scope?

---

### Step 3 — RFP requirements triage

Read the RFP document and decompose requirements into a structured matrix.

```markdown
## RFP Requirements Matrix

| ID | Requirement | Type | Domain | Owner | Dependencies | Notes |
|----|-------------|------|--------|-------|--------------|-------|
| R-001 | <requirement text> | Mandatory / Weighted / Informational | Business / Technical / Commercial / Legal | <workstream> | R-NNN | |
```

**Requirement types:**
- **Mandatory** — pass/fail; non-compliance likely disqualifies the bid
- **Weighted** — scored; investing in quality here directly affects the evaluation score
- **Informational** — context only; no scoring attached

**Priority actions from triage:**
- Flag every Mandatory requirement immediately — these are non-negotiable scope items
- Identify requirements that are ambiguous enough to block architecture decisions — these go directly to the Open Questions Log
- Note requirements where the organisation has a known capability gap — these are risk items for the Bid/No-Bid decision

---

### Step 4 — Open Questions Log

Capture every ambiguity that could materially affect architecture decisions, effort estimation, or commercial structuring.

```markdown
## Open Questions Log

| ID | Question | Domain | Blocks | Priority | Submitted | Client response | Status |
|----|----------|--------|--------|----------|-----------|-----------------|--------|
| Q-001 | <question text> | Functional / Technical / Commercial / Legal | <what it blocks — R-NNN or artifact> | High / Medium / Low | <date> | | Open |
```

**Domain categories:**
- **Functional** — what the system must do; process or capability ambiguity
- **Technical** — integration, data, security, or platform constraints not specified
- **Commercial** — pricing model, contract structure, payment terms, IP ownership
- **Legal** — compliance obligations, liability, data residency, regulatory constraints

Questions should be phrased to elicit a specific decision from the client — not open-ended discussion starters. "Will the integration with [System X] use the existing API, or is a new integration to be developed?" is answerable. "Can you tell us more about your integration landscape?" is not.

Mark which RFP requirements or architecture decisions are blocked by each question. This prioritises which questions must be answered before Phase 2 can proceed.

---

### Step 5 — Write Bid/No-Bid Decision Record

Write to `pursuits/<client>-<slug>/Phase0/bid-no-bid-decision.md`.

```markdown
# Bid/No-Bid Decision — <Client> <Engagement>

| Field | Value |
|-------|-------|
| **Pursuit** | <client name> — <engagement name> |
| **RFP received** | <date> |
| **Submission deadline** | <date> |
| **Decision** | Bid / No-Bid / Conditional Bid |
| **Decision date** | <date> |
| **Decision owner** | <pursuit lead name / role> |

## Scoring summary

| Dimension | Score | Notes |
|-----------|-------|-------|
| Strategic fit | /5 | |
| Win probability | /5 | |
| Margin potential | /5 | |
| Resource availability | /5 | |
| Delivery risk | /5 | |
| **Total** | **/25** | |

## Recommendation

<One paragraph: summarise the score, name the two or three most significant factors (positive and negative), and state the recommendation with reasoning.>

## Conditions (if Conditional Bid)

<If the decision is Conditional Bid, list the conditions that must be resolved before fully committing — e.g. "Resource confirmed for SA role", "Clarification received on data residency requirement".>

## Key risks to monitor

- <Risk 1 — specific, not generic>
- <Risk 2>

## Next steps if proceeding

- [ ] Assign pursuit lead — <name>
- [ ] Assign SA lead — <name>
- [ ] Assign EA lead — <name>
- [ ] Submit clarification questions by <date>
- [ ] Phase 1 kickoff — <date>

## Sign-off

| Role | Name | Date |
|------|------|------|
| Pursuit Lead | | |
| Practice/Business Lead | | |
```

---

### Step 6 — Confirm go/no-go

Present the Bid/No-Bid Decision Record to the user. Confirm the decision before any Phase 1 resources are committed.

If the decision is No-Bid: the workflow ends here. File the decision record for future reference.

If the decision is Conditional Bid: list the conditions clearly and confirm who owns resolving each one before Phase 1 starts.

If the decision is Bid: confirm the pursuit team assignments and hand off to `rfp-discovery-to-design` for Phase 1.

---

## Output files

| File | Location |
|------|----------|
| `bid-no-bid-decision.md` | `pursuits/<client>-<slug>/Phase0/` |
| `rfp-requirements-matrix.md` | `pursuits/<client>-<slug>/Phase0/` |
| `open-questions-log.md` | `pursuits/<client>-<slug>/Phase0/` |
