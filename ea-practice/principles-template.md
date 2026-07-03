# Architecture Principles

> **How to use this file**
>
> This is a starter template. Replace the example principles below with your organisation's actual principles. Each principle has an ID (`P-NN`), a name, a rationale, implications, a status, and an owner.
>
> The Cursor rules and Claude skills in this kit reference principles by `P-NN` ID. For citations to work, principle IDs must be stable — once assigned, don't renumber.
>
> **Lifecycle statuses:** `Proposed` → `Active` → `Superseded`
>
> To add a new principle: add it here with status `Proposed`, then bring it to the Architecture Board for approval before changing status to `Active`.
>
> To supersede a principle: change its status to `Superseded by P-NN (Date)` and add a note explaining why.

---

## Active Principles

### P-01 — Business-driven architecture

**Rationale:** Architecture decisions must be traceable to a business driver, capability need, or stakeholder concern. Technology choices that cannot be linked to a business outcome are overhead.

**Implications:**
- Every architecture artifact opens with the business driver it serves.
- ADRs include a "business driver" field.
- Technical elegance is not sufficient justification on its own.

**Status:** Active | **Owner:** EA Lead

---

### P-02 — Reuse before buy, buy before build

**Rationale:** Building bespoke solutions creates long-term maintenance burden and organisational lock-in. The default preference is: reuse an existing capability, then buy/SaaS, then build.

**Implications:**
- Any proposal to build must document why existing capabilities were insufficient.
- SaaS is preferred over self-hosted for commodity capabilities.
- Internal platforms are evaluated before external products for cross-cutting concerns (identity, integration, monitoring).

**Status:** Active | **Owner:** EA Lead

---

### P-03 — ABB before SBB

**Rationale:** Architecture Building Blocks (capabilities, patterns) should be defined before Solution Building Blocks (products, vendors) are selected. Selecting products before defining capabilities leads to requirements being shaped by vendor features.

**Implications:**
- Application and technology architecture documents name the ABB first, then the SBB.
- Product comparisons require a stated fit-gap against the ABB.
- Vendor names are not used as capability proxies.

**Status:** Active | **Owner:** EA Lead

---

### P-04 — One system of record per entity

**Rationale:** Data quality problems almost always trace back to ambiguity about which system is authoritative for a given data entity. A single, named system of record per entity is non-negotiable.

**Implications:**
- Every canonical data entity has a named system of record in `DataArchitecture/DataOwnershipRegister.md`.
- Integrations that duplicate data must identify the golden source and the derivative.
- Consolidation decisions that create a new system of record require a Data Architecture ADR.

**Status:** Active | **Owner:** Data Architect

---

### P-05 — Security by design, not by addition

**Rationale:** Security controls added after design are more expensive, less effective, and more likely to be incomplete than controls built into the architecture from the start.

**Implications:**
- Security requirements are part of Phase B and Phase C, not Phase D only.
- ADRs for platform and integration choices include a security implication section.
- "We'll add security later" is a finding, not a plan.

**Status:** Active | **Owner:** Security Architect

---

### P-06 — Prefer managed services for undifferentiated capability

**Rationale:** Running infrastructure that does not differentiate the business (databases, queues, identity, monitoring) diverts engineering effort from value-adding work. Managed/cloud-native services are preferred.

**Implications:**
- Self-hosted options for commodity capabilities require explicit justification (compliance, cost, sovereignty).
- Operational burden of self-hosted options must be documented before selection.

**Status:** Active | **Owner:** EA Lead

---

### P-07 — Design for observability from day one

**Rationale:** Systems that cannot be observed cannot be operated reliably. Instrumentation, logging, and health endpoints are not optional additions — they are part of the definition of done.

**Implications:**
- Every application architecture includes observability requirements (metrics, logs, traces).
- Production readiness criteria include observable SLIs.
- ADRs for platform choices consider observability tooling compatibility.

**Status:** Active | **Owner:** SRE Lead

---

### P-08 — Incremental delivery over big-bang

**Rationale:** Large single-delivery programmes carry high integration risk, reduce feedback loops, and delay value realisation. Architecture should support phased delivery with intermediate stable states (Transition Architectures).

**Implications:**
- Programmes of more than 6 months must define at least one Transition Architecture.
- Phase E planning explicitly evaluates whether a big-bang delivery is necessary or merely convenient.
- Decommissioning plans are staged alongside delivery plans, not deferred.

**Status:** Active | **Owner:** EA Lead

---

### P-09 — Don't duplicate, federate

**Rationale:** Data and capability duplication creates consistency risk and maintenance overhead. Where centralisation is impractical, the preferred pattern is federation with clear ownership — not independent copies.

**Implications:**
- Integration proposals that replicate rather than federate require explicit justification.
- Canonical data model is the reference for all integrations — shadow models are findings.
- Application portfolio rationalisation targets eliminate duplication, not just reduce headcount.

**Status:** Active | **Owner:** Data Architect

---

### P-10 — Architecture decisions are traceable and time-stamped

**Rationale:** Architecture that cannot be explained cannot be governed. Every significant decision must be recorded with context, options considered, and reasoning — not just the outcome.

**Implications:**
- ADRs are written for all decisions that meet the criteria in `adr-and-decisions.mdc`.
- "We've always done it this way" is not a valid rationale in an ADR.
- Superseded decisions retain their original record; status is updated, content is not deleted.

**Status:** Active | **Owner:** EA Lead

---

## Proposed Principles

> Add new candidate principles here with status `Proposed`. Bring to Architecture Board for review before promoting to `Active`.

*(none currently proposed)*

---

## Superseded Principles

> Retain superseded principles for traceability. Do not delete.

*(none currently superseded)*
