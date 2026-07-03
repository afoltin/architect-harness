---
name: rfp-assembler
description: RFP Phases 3–4 — produces the delivery model artifacts (Risk Register, Assumptions & Exclusions, Phased Roadmap via roadmap-planner) and the commercial assembly artifacts (Compliance Matrix, Executive Summary, proposal assembly checklist). Use when "assemble the proposal", "write the delivery model", "risk register", "compliance matrix", "executive summary", or "Phase 3/4" is requested.
---

# RFP Assembler

Covers Phase 3 (Delivery Model & Estimation) and Phase 4 (Commercial & Proposal Assembly) of the RFP pursuit workflow. Phase 3 runs in parallel with Phase 2 once the Architecture Intent is stable; Phase 4 is sequential after both Phases 2 and 3 are complete.

## When to use

- "Write the delivery model"
- "Build the risk register"
- "Compile the assumptions and exclusions"
- "Write the compliance matrix"
- "Draft the executive summary"
- "Assemble the proposal"
- Architecture Intent is agreed and estimation can begin

---

## Workflow

```
- [ ] Step 1: Repo discovery — locate pursuit folder
- [ ] Step 2: Phase 3 — Phased Roadmap (invoke roadmap-planner)
- [ ] Step 3: Phase 3 — Risk Register
- [ ] Step 4: Phase 3 — Assumptions & Exclusions
- [ ] Step 5: Phase 3 — Dependency Log
- [ ] Step 6: Phase 4 — Compliance Matrix
- [ ] Step 7: Phase 4 — Executive Summary
- [ ] Step 8: Phase 4 — Proposal assembly checklist
```

---

### Step 1 — Repo discovery

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
```

Read `$REPO_ROOT/AGENTS.md` and locate the pursuit folder. Confirm the Architecture Intent (`Phase2/architecture-intent.md`) exists and has been agreed before proceeding. If it does not exist, stop and invoke `rfp-discovery-to-design` first — estimation before a stable architecture produces misalignment downstream.

Read:
- `Phase0/rfp-requirements-matrix.md` — for Compliance Matrix in Step 6
- `Phase0/open-questions-log.md` — for unresolved assumptions in Step 4
- `Phase2/fit-gap-assessment.md` — gaps feed the Risk Register
- `Phase2/nfr-response-matrix.md` — partial NFRs feed the Risk Register

---

### Step 2 — Phased Roadmap

Invoke `roadmap-planner` to produce the delivery roadmap.

In an RFP context, the roadmap input differs slightly from a standard EA roadmap:

- **Gaps** come from `Phase2/fit-gap-assessment.md` — each Gap and Partial entry is a delivery gap to close
- **Horizons** map to delivery phases/waves, not calendar years — H0 is Phase 1 of delivery, H1 is Phase 2, etc.
- **Transition Architectures** represent go-live milestones and handover states
- **Work packages** map to delivery workstreams, not EA programmes

Write to `Phase3/phased-roadmap.md`. The roadmap-planner skill handles the format.

Additionally, for RFP context, the roadmap must include:
- Decision gates between phases (e.g. "Phase 2 begins after client sign-off on Phase 1 deliverables")
- Client dependencies (what the client must provide and when)
- Assumptions that affect the timeline (link to Step 4)

---

### Step 3 — Risk Register

Write to `Phase3/risk-register.md`.

```markdown
# Risk Register — <Client> <Engagement>

| ID | Risk | Likelihood (H/M/L) | Impact (H/M/L) | Risk rating | Owner | Mitigation | Residual risk |
|----|------|--------------------|----------------|-------------|-------|------------|---------------|
| R-001 | <risk description> | H / M / L | H / M / L | HH / HM / MM / etc. | <role> | <mitigation action> | <remaining risk after mitigation> |
```

**Risk rating:** Likelihood × Impact. HH = critical; HM/MH = high; MM = medium; ML/LM/LL = low.

**Risk sources to systematically check:**

*Architecture and technical risks:*
- Open questions (from `Phase0/open-questions-log.md`) that remain unanswered — each is a latent risk
- Partial NFRs in the NFR Response Matrix — what happens if the partial cannot be fully addressed?
- Integration dependencies on third-party systems or client-owned components
- Technology choices with limited organisational experience
- Data migration complexity and data quality unknowns

*Delivery risks:*
- Timeline assumptions — is the proposed schedule realistic given the scope?
- Key person dependencies — what if the proposed SA or delivery lead is unavailable?
- Client-side delivery dependencies — governance approvals, data access, environment provisioning
- Third-party vendor dependencies and their lead times

*Commercial risks:*
- Fixed price exposure — where estimation uncertainty is high and the contract model is fixed price
- Scope creep triggers — requirements that are ambiguous enough to be interpreted broadly
- Assumptions that, if invalidated, would require re-estimation or contract renegotiation

*External risks:*
- Regulatory changes during delivery
- Incumbent sabotage or disruption during transition
- Budget changes on the client side

---

### Step 4 — Assumptions & Exclusions

Write to `Phase3/assumptions-exclusions.md`.

This is commercial protection. Every assumption that is not validated by the client at proposal stage is a scope-creep vector. Write it carefully.

```markdown
# Assumptions & Exclusions — <Client> <Engagement>

> This document defines the boundary conditions under which the proposal and its commercial terms are valid. Material changes to these assumptions may require re-scoping and re-pricing.

## Assumptions

Assumptions are conditions we believe to be true based on available information. If any assumption proves incorrect, the impact on scope, timeline, and cost is noted.

| ID | Assumption | Impact if incorrect | Source |
|----|-----------|---------------------|--------|
| A-001 | The client will provide access to [System X] API documentation within 2 weeks of project start | Integration workstream delayed by up to 4 weeks | Inferred from RFP scope |
| A-002 | Data migration volume does not exceed [N] records | Migration timeline and tooling selection may need revision | RFP §3.2 implies but does not state |
| A-003 | The client's existing [Platform Y] licence will be extended to cover the new workload | Additional licensing cost is outside this proposal | Verbal confirmation from client contact |

**Assumption categories:**
- Client responsibilities and inputs (data access, approvals, environments, SME availability)
- Third-party system behaviour and availability
- Volume and scale figures used in estimation
- Regulatory and compliance scope (what regulations apply and which are already addressed)
- Technology availability (licences, cloud accounts, existing platform capacity)

## Exclusions

Exclusions are items explicitly out of scope. They are stated to prevent misinterpretation of what "delivery" means.

| ID | Exclusion | Rationale |
|----|-----------|-----------|
| E-001 | Replacement of [Legacy System Z] | Outside the scope of this engagement; referenced in the RFP as a future phase |
| E-002 | End-user training beyond train-the-trainer | Commercial model assumes client-led training delivery |
| E-003 | Production support beyond [N]-month hypercare | Ongoing managed service is a separate commercial arrangement |
```

Cross-reference with:
- `Phase0/open-questions-log.md` — unresolved questions that had to be assumed; each becomes an assumption entry
- `Phase2/fit-gap-assessment.md` — Out-of-scope entries in the fit/gap each become an exclusion entry

---

### Step 5 — Dependency Log

Write to `Phase3/dependency-log.md`.

```markdown
# Dependency Log — <Client> <Engagement>

| ID | Dependency | Type | Owner | Required by | Lead time | Risk if late |
|----|-----------|------|-------|-------------|-----------|-------------|
| D-001 | Access to [System X] test environment | Client-side | Client IT | Week 3 of Phase 1 | 2 weeks | Integration testing delayed |
| D-002 | [Vendor Y] licence procurement | Third-party | Delivery Lead | Week 1 | 4–6 weeks | Platform deployment blocked |
| D-003 | Data governance sign-off for [Entity Z] migration | Client-side | Client Data Owner | Week 6 of Phase 1 | Unknown | Migration planning stalled |
```

**Dependency types:**
- **Client-side** — the client must provide this; it is outside the delivery team's control
- **Third-party** — a vendor, partner, or external system must deliver this
- **Internal** — a workstream within this engagement depends on another workstream's output
- **Regulatory** — a regulatory approval or compliance sign-off is required before proceeding

Flag dependencies with long or unknown lead times — these are the most likely schedule risks and should appear in the Risk Register.

---

### Step 6 — Compliance Matrix

Write to `Phase4/compliance-matrix.md`.

Maps every RFP requirement to the section of the proposal that responds to it. This is the formal audit trail the evaluation team uses to score the response.

Read `Phase0/rfp-requirements-matrix.md` for the full requirement list.

```markdown
# Compliance Matrix — <Client> <Engagement>

| Req ID | Requirement | Compliance | Proposal section | Notes |
|--------|-------------|------------|-----------------|-------|
| R-001 | <requirement text> | Fully compliant / Partially compliant / Non-compliant / Not applicable | §<N> — <section title> | |
| R-007 | <requirement text> | Partially compliant | §6 Integration Architecture, §Appendix B Fit/Gap | See Fit/Gap entry R-007 for detail on the partial |
```

**Compliance values:**
- **Fully compliant** — the requirement is met completely; the proposal section is the evidence
- **Partially compliant** — the requirement is partially met; the partial and its mitigation are documented in the Fit/Gap Assessment
- **Non-compliant** — the requirement is not met; include a brief explanation and, if possible, a proposed resolution
- **Not applicable** — the requirement does not apply to the proposed solution; brief justification required

The Compliance Matrix must cover every requirement in the RFP. Gaps in the matrix are immediately visible to the evaluation team and signal incomplete work.

---

### Step 7 — Executive Summary

Write to `Phase4/executive-summary.md`.

The most-read section of the proposal. Written last, but written from the perspective of a client executive who will read nothing else. One to two pages maximum.

Structure:

```markdown
# Executive Summary — <Client> <Engagement>

## The challenge
<One paragraph: the client's problem in their language, not ours. Show that we understand what they are trying to achieve and why it matters now.>

## Our solution
<One to two paragraphs: the proposed approach at capability level — not a technology list. What the client will be able to do as a result. Connect directly to the Architecture Intent.>

## Why this approach
<One paragraph: two or three reasons why our approach is differentiated. These must be true, specific, and traceable to the SAD — not generic positioning statements.>

## How we will deliver it
<One paragraph: delivery model, phasing, key milestones, and what governance looks like. The client should feel confident in the delivery approach, not just the architecture.>

## Commercial headline
<One paragraph or a simple table: pricing model, key terms, and timeline. No detail — that is in the Commercial Proposal.>

## What we need from you
<One paragraph: key client dependencies and decisions required early. This signals we have thought about delivery partnership, not just our own workstream.>
```

**Quality checks before finalising:**
- Does every sentence trace to the Architecture Intent, SAD, or Delivery Model? If not, remove it.
- Are there any technology names that appear in the Executive Summary but are not explained in the Architecture Intent? Remove or explain.
- Does it sound like the client wrote it, or like the pursuing organisation wrote it? It should sound like the former.
- Is there anything that would surprise a Director or CTO who then reads the full SAD? If yes, align the documents.

---

### Step 8 — Proposal assembly checklist

Present the final checklist before submission. Every item must be confirmed.

```markdown
## Proposal Assembly Checklist

### Phase 0 artifacts
- [ ] Bid/No-Bid Decision Record — signed off
- [ ] RFP Requirements Matrix — complete, all requirements captured
- [ ] Open Questions Log — all High priority questions resolved or documented as assumptions

### Phase 1/2 artifacts
- [ ] Client Context Brief — reviewed by pursuit lead
- [ ] NFR Catalogue — all RFP NFRs captured; assumed NFRs flagged
- [ ] Architecture Intent — agreed by pursuit lead; EA standards review passed
- [ ] Capability Map — all ABBs named; no orphaned SBBs
- [ ] Options Analysis — 2–3 options with honest trade-offs; recommendation stated
- [ ] ADRs — all key decisions captured; Principles fields populated
- [ ] SAD — all sections complete; diagrams present and labelled; NFR Response Matrix referenced
- [ ] Fit/Gap Assessment — every RFP requirement covered; Partial and Gap entries have mitigations
- [ ] NFR Response Matrix — every NFR from catalogue covered; no "Not met" without mitigation

### Phase 3 artifacts
- [ ] Phased Roadmap — decision gates included; client dependencies named
- [ ] Risk Register — HH risks have mitigations; risk owners assigned
- [ ] Assumptions & Exclusions — every open question mapped to an assumption; exclusions cross-referenced to Fit/Gap
- [ ] Dependency Log — lead times confirmed; long-lead dependencies in Risk Register

### Phase 4 artifacts
- [ ] Compliance Matrix — every RFP requirement mapped; no gaps
- [ ] Executive Summary — traceable to Architecture Intent; no unsupported claims; two pages maximum
- [ ] Commercial Proposal — pricing reviewed and signed off by Commercial Lead
- [ ] Reference Case Studies — matched to client context; client-approved for use

### Cross-checks
- [ ] Executive Summary narrative consistent with Architecture Intent
- [ ] SAD section references in Compliance Matrix are accurate
- [ ] Fit/Gap Gap entries have corresponding Risk Register entries
- [ ] Assumptions & Exclusions consistent with Effort Estimation Workbook assumptions
- [ ] ADR count in SAD introduction matches actual ADR files in Phase2/

### Submission
- [ ] Proposal reviewed by pursuit lead
- [ ] Internal red-team review completed (recommended)
- [ ] Branded and formatted per RFP submission requirements
- [ ] Submission deadline confirmed: <date and time and method>
```

---

## Output files

| File | Location |
|------|----------|
| `phased-roadmap.md` | `Phase3/` |
| `risk-register.md` | `Phase3/` |
| `assumptions-exclusions.md` | `Phase3/` |
| `dependency-log.md` | `Phase3/` |
| `compliance-matrix.md` | `Phase4/` |
| `executive-summary.md` | `Phase4/` |
