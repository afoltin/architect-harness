# TOGAF ADM — Decision Stages for Common Architecture Scenarios

In TOGAF, any architecturally significant decision flows through the **Architecture Development Method (ADM)**. The same phases apply to every scenario, but the *emphasis* and *artifacts produced* differ depending on whether you are replacing, consolidating, integrating, or building new capability. The trigger almost always comes from **Phase H – Architecture Change Management**, which classifies the change as *Simplification*, *Incremental*, or *Re-architecting* — and that classification largely drives how heavy each subsequent phase becomes.

This document covers four scenarios:

1. One-to-one replacement of a system
2. Consolidation of multiple applications
3. Integration between existing systems
4. Greenfield capability build

---

## Common backbone (applies to all four)

| ADM Phase | Purpose |
|-----------|---------|
| Request for Architecture Work | Formal demand captured via Phase H (or as a new initiative in Phase A) |
| **A – Architecture Vision** | Scope, stakeholders, business value, success criteria, Statement of Architecture Work |
| **B – Business Architecture** | Capability and process impact |
| **C – Information Systems** (Data + Application) | What changes in data and applications |
| **D – Technology Architecture** | Platform and infrastructure impact |
| **E – Opportunities & Solutions** | Gap analysis, work packages, Transition Architectures, build/buy/SaaS |
| **F – Migration Planning** | Sequencing, roadmap, cost/risk, Implementation & Migration Plan |
| **G – Implementation Governance** | Architecture Contract, compliance reviews during delivery |
| **H – Architecture Change Management** | Post-go-live, feeds the next cycle |
| **Requirements Management** (centre) | Runs across all phases |

---

## 1. One-to-one replacement of a system

Usually classified as **Simplification / Incremental change** (like-for-like).

- **Phase H (trigger):** end-of-life, vendor change, tech debt → change request raised.
- **Phase A:** confirm scope is "replacement, no capability change"; identify stakeholders; value case (TCO, risk reduction).
- **Phase B:** *light-touch* — verify business capabilities and processes remain unchanged; flag any that the new product forces to change.
- **Phase C – Application:** functional fit-gap against the existing app; produce Target Application Architecture (one node replaced).
- **Phase C – Data:** data migration scope, ownership, cleansing rules.
- **Phase D:** new platform, hosting, licensing footprint.
- **Phase E:** **Build / Buy / SaaS decision**, vendor/product selection, one or two Transition Architectures ("old live", "parallel run", "new live").
- **Phase F:** cutover strategy (big-bang vs. parallel), data migration plan, decommissioning plan.
- **Phase G:** enforce Architecture Contract during the implementation project.
- **Phase H:** verify benefits, retire the old baseline.

**Key artifacts:** Application Portfolio delta, Data Migration Plan, Decommissioning Plan, ADR for product/vendor choice.

**Decision centre of gravity:** Phase E (build/buy/SaaS + vendor), driven by Phase C-App fit-gap.

---

## 2. Consolidation of multiple applications

Usually classified as **Re-architecting change** — a new ADM cycle, not a change request.

- **Phase H (trigger):** portfolio rationalisation, M&A, cost reduction.
- **Phase A:** broader scope, multiple business owners, clear consolidation principles (e.g. "one system of record per capability").
- **Phase B:** *heaviest phase after Phase C* — harmonise processes, resolve capability overlap, agree the target operating model; this is where most of the organisational work happens.
- **Phase C – Application:**
  - Application Portfolio rationalisation (TIME / 6R analysis).
  - Functional overlap matrix across candidates.
  - Target Application Architecture with the consolidated system.
- **Phase C – Data:** canonical data model, master data reconciliation, data ownership across former silos — typically the hardest part.
- **Phase D:** consolidated platform, capacity sizing.
- **Phase E:** multiple Transition Architectures (consolidation rarely happens in one step); work packages per source system; build vs. extend an existing one vs. new platform.
- **Phase F:** multi-wave roadmap, business change and training, parallel decommissioning.
- **Phase G:** strong governance — scope creep is the primary risk.
- **Phase H:** measure rationalisation KPIs (apps retired, cost saved, data quality).

**Key artifacts:** Application Rationalisation Matrix, Capability-to-Application heatmap, multi-step Transition Architectures, Data Ownership Register.

**Decision centre of gravity:** Phase B + Phase C (capability and portfolio rationalisation), formalised in Phase E.

---

## 3. Integration between existing systems

Usually classified as **Incremental change**, scoped to information flows rather than the systems themselves.

- **Phase H (trigger):** new business process, regulatory need, automation, data quality issue.
- **Phase A:** define integration scope, parties, SLAs, information exchange objectives.
- **Phase B:** cross-functional process design, value streams that span the systems, process hand-offs.
- **Phase C – Data:** *core of the work* — canonical/shared data model, semantics alignment, mastering and golden source, event definitions.
- **Phase C – Application:** integration pattern (synchronous API, async messaging, event-driven, ETL/file, data virtualisation), contract/API specifications, choreography vs. orchestration.
- **Phase D:** integration platform choice (API gateway, iPaaS, ESB, broker, streaming), security (authN/Z, mTLS), observability.
- **Phase E:** build vs. reuse existing integration capability; reusable interface services vs. point-to-point; Transition Architectures often minor.
- **Phase F:** phased rollout by interface/domain; backward compatibility and versioning plan.
- **Phase G:** governance over API contracts, standards compliance (REST/OpenAPI, AsyncAPI, canonical model).
- **Phase H:** monitor interface health, evolve contracts.

**Key artifacts:** Canonical Data Model, Interface Catalogue, Integration Pattern ADR, API contracts.

**Decision centre of gravity:** Phase C-Data + Phase C-App (canonical model and integration pattern), platform choice in Phase D.

---

## 4. Greenfield capability build

Usually classified as **Re-architecting change** — a net-new capability that does not exist in the current baseline.

- **Phase H (trigger):** new business model, regulatory requirement, strategic investment, market opportunity.
- **Phase A:** define the new capability in business terms; establish scope boundaries (what is in, what is explicitly out); identify stakeholders and their concerns; produce the Architecture Vision.
- **Phase B:** *heaviest phase* — define the capability model, the value streams the new capability enables, the operating model (who owns and runs it), and the organisational change required. This is where the decision to build vs. buy vs. partner lives.
- **Phase C – Application:** design the application architecture from scratch; apply ABB-before-SBB discipline; identify integration points with the existing estate.
- **Phase C – Data:** define new data entities, their ownership, canonical placement, and integration with existing canonical model. Greenfield data models that don't align to the canonical model create future integration debt.
- **Phase D:** platform and infrastructure choices; apply existing technology baselines where possible (per the Reuse before invent principle); identify net-new platform requirements.
- **Phase E:** build vs. buy vs. SaaS for each application component; identify reuse opportunities in the existing estate; produce Transition Architectures if the capability will be delivered in waves.
- **Phase F:** phased delivery roadmap; team/skills plan; operational readiness plan (SLAs, monitoring, on-call).
- **Phase G:** Architecture Contract for the delivery programme; compliance checkpoints at each delivery wave.
- **Phase H:** measure capability adoption and value realisation; feed lessons into the next cycle.

**Key artifacts:** Architecture Vision, Business Capability definition, Application Architecture (new), Data Architecture (new entities + canonical alignment), platform ADRs, phased delivery roadmap.

**Decision centre of gravity:** Phase A + Phase B (capability definition and operating model), then Phase E (build/buy/SaaS per component).

**Key risk:** scope inflation. Phase A must establish hard boundaries; Phase G must enforce them. The most common failure mode is greenfield becoming an accidental platform with no defined operating model.

---

## Summary — where the decision really gets made

| Scenario | Dominant decision phase | Typical change type |
|----------|------------------------|---------------------|
| 1. One-to-one replacement | **Phase E** (build/buy/SaaS + vendor), driven by Phase C-App fit-gap | Simplification / Incremental |
| 2. Consolidation | **Phase B + Phase C** (capability and portfolio rationalisation), formalised in Phase E | Re-architecting |
| 3. Integration | **Phase C-Data + Phase C-App** (canonical model and integration pattern), platform in Phase D | Incremental |
| 4. Greenfield | **Phase A + Phase B** (capability definition and operating model), then Phase E per component | Re-architecting |

In all four, Phase A frames the decision, Phase E formalises it into work packages and Transition Architectures, and Phase F sequences it — but the *centre of gravity* moves left/right along the ADM depending on the scenario.
