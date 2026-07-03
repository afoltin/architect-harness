---
name: rfp-discovery-to-design
description: RFP Phases 1–2 — produces the Client Context Brief, NFR Catalogue, Solution Hypothesis, and Architecture Intent document (Phase 1), then orchestrates the solution design phase: Capability Map, Options Analysis, SAD outline, Fit/Gap Assessment, and NFR Response Matrix (Phase 2). Invokes adr-generator, principles-review, and ea-standards at the appropriate points. Use when "run Phase 1", "start the discovery", "write the Architecture Intent", "design the solution", or "write the SAD" is requested.
---

# RFP Discovery to Design

Covers Phase 1 (Discovery & Clarification) and Phase 2 (Solution Design) of the RFP pursuit workflow. The central output is the **Architecture Intent document** — the single source of truth that all Phase 2–5 artifacts derive from. Nothing in Phase 2 starts until the Architecture Intent is agreed.

## When to use

- "Run Phase 1 discovery"
- "Write the Architecture Intent"
- "Start the solution design"
- "Write the SAD"
- "Do the fit/gap assessment"
- The Bid/No-Bid decision is confirmed and Phase 1 is starting

---

## Workflow

```
- [ ] Step 1: Repo discovery — locate pursuit folder
- [ ] Step 2: Phase 1 — Client Context Brief
- [ ] Step 3: Phase 1 — NFR Catalogue
- [ ] Step 4: Phase 1 — Solution Hypothesis
- [ ] Step 5: Phase 1/2 boundary — Architecture Intent document
- [ ] Step 6: Phase 2 — Capability Map
- [ ] Step 7: Phase 2 — Options Analysis
- [ ] Step 8: Phase 2 — Architecture principles (invoke principles-review)
- [ ] Step 9: Phase 2 — ADRs for key decisions (invoke adr-generator)
- [ ] Step 10: Phase 2 — SAD outline and NFR Response Matrix
- [ ] Step 11: Phase 2 — Fit/Gap Assessment
- [ ] Step 12: EA standards review (invoke ea-standards)
```

---

### Step 1 — Repo discovery

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
```

Read `$REPO_ROOT/AGENTS.md`. Identify the pursuit folder:
```
pursuits/<client>-<slug>/
```

Read `Phase0/bid-no-bid-decision.md` to confirm the pursuit is active and extract: client name, engagement name, submission deadline, pursuit team.

Read `Phase0/open-questions-log.md` — open questions with High priority that block architecture decisions must be noted in Phase 1 artifacts as assumptions until the client responds.

---

### Step 2 — Client Context Brief

Write to `Phase1/client-context-brief.md`.

Research or gather from the user:

```markdown
# Client Context Brief — <Client Name>

## Organisation overview
<Industry, size, geography, regulatory environment — one paragraph. Be specific about the regulatory context; it drives NFRs directly.>

## Strategic drivers
<What business outcomes is the client trying to achieve? What is driving this procurement now — cost pressure, capability gap, regulatory deadline, growth ambition?>

## Known technology landscape
<What is known about the existing estate — ERP, CRM, data platforms, cloud posture, integration approach? Note the source (RFP text, public information, relationship knowledge).>

## Incumbent landscape
<Is there an incumbent? What is their relationship and likely competitive approach?>

## Key stakeholders
<Named roles and their likely concerns. Director/CTO level concerns are EA concerns; IT Manager concerns are delivery concerns. Tailor the proposal accordingly.>

## Evaluation criteria signals
<From the RFP: how is the response evaluated? What does the weighting tell you about what the client values?>

## Risks and sensitivities
<What could make this client particularly sensitive — recent failed programmes, budget scrutiny, organisational change, political dynamics?>
```

---

### Step 3 — NFR Catalogue

Write to `Phase1/nfr-catalogue.md`.

Extract NFRs from the RFP and supplement with reasonable assumptions where the RFP is silent. For each NFR, record a target, a source, and the architecture domain it drives.

```markdown
# NFR Catalogue — <Client> <Engagement>

| ID | Category | NFR | Target | Source | Architecture domain |
|----|----------|-----|--------|--------|-------------------|
| NFR-001 | Availability | System uptime | 99.9% excluding planned maintenance | RFP §4.2 | Technology |
| NFR-002 | Performance | API response time (p95) | < 500ms | RFP §4.3 | Technology / Application |
| NFR-003 | Security | Data encryption at rest and in transit | AES-256 / TLS 1.2+ | RFP §5.1 | Security |
| NFR-004 | Compliance | GDPR data residency | EU region only | RFP §6.0 | Data / Technology |
| NFR-005 | Scalability | Concurrent users | 10,000 peak | Assumed — RFP silent | Application |
```

**NFR categories to cover:**
- Availability and resilience (uptime, RTO, RPO)
- Performance (response time, throughput, latency)
- Security (encryption, IAM, vulnerability management)
- Compliance (regulatory obligations, data residency, audit)
- Scalability (user load, data volume, growth trajectory)
- Maintainability (deployment frequency, MTTR, observability)
- Interoperability (integration standards, API contracts, data formats)
- Supportability (SLA tiers, support model, on-call obligations)

Mark any NFR derived from assumption (not explicit in the RFP) — these go into the Assumptions & Exclusions document in Phase 3.

---

### Step 4 — Solution Hypothesis

Write to `Phase1/solution-hypothesis.md`.

One page maximum. This is the rough narrative of the proposed approach — directional, not detailed. It will be refined into the Architecture Intent in Step 5.

```markdown
# Solution Hypothesis — <Client> <Engagement>

**Problem statement:** <One sentence: what the client is trying to solve.>

**Proposed approach:** <Two to three sentences: the high-level solution direction. What capabilities will be delivered. What the integration approach is. What platform choices are anticipated.>

**Why this approach:** <One paragraph: why this direction over alternatives. Connects to the client's strategic drivers and the NFRs that most constrain the solution.>

**Key assumptions at this stage:**
- <Assumption 1>
- <Assumption 2>

**Open questions that could change this hypothesis:**
- Q-NNN: <question text>

**Earliest architecture decisions anticipated:**
- <Decision area 1 — e.g. integration platform>
- <Decision area 2>
```

Share with the pursuit lead before proceeding. If the hypothesis is significantly wrong, correct it here rather than after the Architecture Intent is written.

---

### Step 5 — Architecture Intent document (Phase 1/2 boundary)

The most important artifact in the pursuit. Write to `Phase2/architecture-intent.md`.

Nothing in Phase 2 begins until this document is agreed with the pursuit lead. Treat agreement as a gate.

See `ea-practice/rfp-pursuit-guide.md` for the full Architecture Intent format. The document must contain:

1. **Problem statement** — one paragraph; the business problem, not the technical problem
2. **Proposed capability approach** — what capabilities the solution delivers, stated at ABB level; not product names
3. **Key architectural decisions already made** — with brief rationale; full ADRs will follow in Steps 9; these are the pre-decisions that constrain the design
4. **Assumed principles** — which principles from `principles.md` (or the client's principles if known) govern this solution
5. **Integration stance** — how the solution connects to the existing estate; approach level, not design detail
6. **Explicit out-of-scope** — what this solution does not address; state it plainly
7. **Open questions that could change this intent** — link to `Phase0/open-questions-log.md` by Q-NNN

Run the document through `ea-standards` before sharing with the pursuit lead (see Step 12). At minimum, confirm:
- ABBs are named before any SBBs
- Principles are cited by P-NN
- Stakeholders and concerns are named

---

### Step 6 — Capability Map

Write to `Phase2/capability-map.md`.

Map the business capabilities the solution delivers to the technical capabilities required to deliver them. This is the ABB layer — no product names yet.

```markdown
# Capability Map — <Client> <Engagement>

## Business capabilities delivered

| Business capability | Description | Priority | Source requirement(s) |
|--------------------|----|---------|----------------------|
| <Capability name> | <What the business can do as a result> | Core / Supporting | R-NNN |

## Technical capability requirements (ABBs)

| ABB | Description | Drives | NFR(s) |
|-----|-------------|--------|--------|
| API Management | Expose and govern APIs to internal and external consumers | Integration stance | NFR-002, NFR-003 |
| Identity & Access Management | AuthN/Z for all system users and service-to-service | Security architecture | NFR-003 |
```

The capability map is the bridge between Phase B (business) and Phase C/D (application/technology). Every SBB selected in Step 7 (Options Analysis) must be traceable to an ABB here.

---

### Step 7 — Options Analysis

Write to `Phase2/options-analysis.md`.

Produce two to three architecture options with honest trade-off framing. Follow the ADR options table format from `adr-and-decisions.mdc` — the same discipline applies here.

```markdown
# Options Analysis — <Client> <Engagement>

## Option A — <name>
**Description:** <one paragraph>

## Option B — <name>
**Description:** <one paragraph>

## Comparison

| Dimension | Option A | Option B | Option C (if applicable) |
|-----------|----------|----------|--------------------------|
| Fit to mandatory requirements | | | |
| NFR coverage | | | |
| Delivery risk | | | |
| Client capability to operate | | | |
| Long-term extensibility | | | |
| Cost profile | | | |
| Time to value | | | |

## Recommendation
**Recommended:** Option <X>

**Rationale:** <Why this option wins on the dimensions that matter most for this client. Connect to the Architecture Intent and the client's strategic drivers.>

**Conditions:** <What must be true for the recommended option to remain valid — open questions, assumptions, client constraints.>
```

Offer to capture the options comparison as an ADR using `adr-generator` — the decision between options is exactly the kind of reusable, architecturally significant decision the ADR format is designed for.

---

### Step 8 — Architecture principles check

Invoke `principles-review` on the Architecture Intent and the Options Analysis.

If the engagement has access to the client's architecture principles, review against those. If not, review against `principles.md` from `AGENTS.md`.

The key question: does the recommended option align with the stated principles, or does it require a justified deviation? Conflicts must be named in the Architecture Intent and in any relevant ADR.

---

### Step 9 — ADRs for key decisions

For each key decision made during solution design, invoke `adr-generator`.

Decision triggers in an RFP context (in addition to the standard triggers from `adr-and-decisions.mdc`):
- Platform or technology selection (e.g. which integration platform, which cloud provider)
- Integration pattern choice (e.g. event-driven vs. synchronous API for a specific interface)
- Build vs. buy vs. SaaS for a major capability component
- Data hosting model (e.g. cloud region for GDPR compliance)
- Identity provider choice and federation model

Write ADRs to `Phase2/ADR-NNNN-<slug>.md`. Number sequentially — check the global ADR counter across the whole repo before assigning a number.

---

### Step 10 — SAD outline and NFR Response Matrix

Write to `Phase2/sad.md` and `Phase2/nfr-response-matrix.md`.

**SAD outline** — the full Solution Architecture Document is a large artifact; produce the outline and key sections. At minimum, the SAD must contain:

```markdown
# Solution Architecture Document — <Client> <Engagement>

> **ADM phase:** B / C / D
> **Domain:** cross-cutting
> **Stakeholders:** <named from Client Context Brief>
> **Decision class (per Phase H):** <Incremental | Re-architecting>

## 1. Executive summary
## 2. Architecture principles and assumptions
## 3. Capability overview (from Capability Map)
## 4. System context (C1 diagram + description)
## 5. Container architecture (C2 diagram + description)
## 6. Integration architecture
## 7. Security architecture
## 8. Data architecture
## 9. Infrastructure and deployment model
## 10. NFR response (reference to NFR Response Matrix)
## 11. Fit/Gap summary (reference to Fit/Gap Assessment)
## 12. Key decisions (reference to ADRs)
## 13. Assumptions and exclusions (reference to Phase 3 document)
```

**NFR Response Matrix:**

```markdown
# NFR Response Matrix — <Client> <Engagement>

| NFR ID | Requirement | How the architecture addresses it | SAD section | Met / Partial / Not met |
|--------|-------------|-----------------------------------|-------------|------------------------|
| NFR-001 | 99.9% uptime | Active-active deployment across two availability zones with automated failover | §9 Infrastructure | Met |
```

Every NFR from the NFR Catalogue must appear in this matrix. "Not met" entries require a mitigation or a note that the requirement is being challenged via the Open Questions Log.

---

### Step 11 — Fit/Gap Assessment

Write to `Phase2/fit-gap-assessment.md`.

Map every RFP requirement from the Requirements Matrix to the solution:

```markdown
# Fit/Gap Assessment — <Client> <Engagement>

| Req ID | Requirement | Assessment | Solution response | SAD reference | Notes |
|--------|-------------|------------|------------------|---------------|-------|
| R-001 | <requirement> | Met | <how the solution meets it> | §4 | |
| R-007 | <requirement> | Partial | <what is met and what remains> | §6 | Mitigation: <approach> |
| R-012 | <requirement> | Gap | <what is not addressed> | — | Proposed resolution: <approach or note as Out-of-scope> |
| R-019 | <requirement> | Out-of-scope | <why this is excluded> | — | Stated in Assumptions & Exclusions |
```

**Assessment values:**
- **Met** — fully addressed by the proposed solution
- **Partial** — addressed with limitations or dependencies; always include a mitigation
- **Gap** — not addressed; always include a proposed resolution or an explicit out-of-scope decision
- **Out-of-scope** — excluded by the Assumptions & Exclusions; reference the entry

Be honest. A superficial "Met" on a complex requirement will be challenged in the orals.

---

### Step 12 — EA standards review

Invoke `ea-standards` on the Architecture Intent and the SAD before either is shared externally.

Minimum passing criteria for an RFP submission:
- Architecture Intent: ADM-phase header present, ABBs named before SBBs, principles cited, stakeholders named with concerns
- SAD: same, plus NFR traceability visible, gaps named not implied, no floating recommendations without a stated driver

Fix ❌ findings before sharing. ⚠️ findings are pursuit-lead judgement calls.

---

## Output files

| File | Location |
|------|----------|
| `client-context-brief.md` | `Phase1/` |
| `nfr-catalogue.md` | `Phase1/` |
| `solution-hypothesis.md` | `Phase1/` |
| `clarification-qa-log.md` | `Phase1/` (living document — update as client responses arrive) |
| `architecture-intent.md` | `Phase2/` |
| `capability-map.md` | `Phase2/` |
| `options-analysis.md` | `Phase2/` |
| `ADR-NNNN-*.md` | `Phase2/` |
| `sad.md` | `Phase2/` |
| `nfr-response-matrix.md` | `Phase2/` |
| `fit-gap-assessment.md` | `Phase2/` |
