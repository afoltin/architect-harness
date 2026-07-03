---
name: roadmap-planner
description: Turns a gap analysis into a sequenced Architecture Roadmap with named Transition Architectures and horizon-banded work packages. Use when the user asks to "build a roadmap", "sequence these gaps", "plan the transition", "create Transition Architectures", or "what order do we close these gaps in".
---

# Roadmap Planner

Bridges Phase E (Opportunities & Solutions) and Phase F (Migration Planning). Takes a set of identified architecture gaps and produces a sequenced roadmap with named Transition Architectures and horizon-banded work packages — turning a gap list into a navigable delivery plan.

## When to use

- "Build a roadmap from these gaps"
- "Sequence the transition"
- "What order do we close these gaps in?"
- "Create the Transition Architectures"
- "Plan the delivery horizon"
- "Turn this gap analysis into a roadmap"

---

## Workflow

```
- [ ] Step 1: Repo discovery
- [ ] Step 2: Input — load or gather the gap list
- [ ] Step 3: Dependency analysis
- [ ] Step 4: Horizon assignment
- [ ] Step 5: Transition Architecture definition
- [ ] Step 6: Work package definition
- [ ] Step 7: Write the roadmap document
- [ ] Step 8: Phase F handoff notes
```

---

### Step 1 — Repo discovery

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
```

Read `$REPO_ROOT/AGENTS.md` and extract:
- Roadmap directory (default: `ea-practice/` or `transformation/<programme>/` if programme-specific)
- Domain folder paths (to resolve gap references)
- `ACTION_ITEMS` — for linking work packages to tracked items

If the roadmap is programme-specific (e.g. a platform migration), ask the user which `transformation/` subdirectory to use before writing.

---

### Step 2 — Input: load or gather the gap list

A gap is the difference between the Baseline and the Target for a specific capability, application, data entity, or technology component. Each gap needs:

| Field | Description |
|-------|-------------|
| **ID** | `G-NN` — sequential within this roadmap |
| **Domain** | Business / Application / Data / Technology |
| **Description** | One sentence: what is insufficient or missing |
| **Capability impact** | Which business capability is blocked or degraded |
| **Severity** | High (blocks Target) / Medium (degrades Target) / Low (nice-to-have) |
| **Dependencies** | Other gaps that must be closed first |

Input sources (in preference order):
1. An existing Gap Analysis document in the repo — read and extract the gap list
2. Phase E work product already in conversation context
3. User-provided list — ask for the fields above for each gap

If gaps are vague ("improve data quality"), work with the user to make them specific ("establish system of record for Customer entity in CRM; current state: three systems claim ownership"). A roadmap built on vague gaps will be vague.

---

### Step 3 — Dependency analysis

Map dependencies between gaps. A gap B **depends on** gap A when:
- Closing B requires infrastructure, data, or decisions that A produces
- Closing B before A creates a technical state that must be undone
- Business or regulatory constraints require a specific ordering

Produce a simple dependency table:

| Gap | Depends on | Reason |
|-----|-----------|--------|
| G-03 | G-01 | Requires system of record established in G-01 before integration can be built |
| G-05 | G-02, G-03 | Cannot migrate application until both data and integration gaps are resolved |

Identify **independent gaps** — those with no dependencies. These are candidates for parallel execution.

Flag **dependency cycles** if they exist. A cycle means the gap decomposition is wrong — escalate to the user to resolve before continuing.

---

### Step 4 — Horizon assignment

Assign each gap to a horizon band based on dependency order, delivery complexity, and the user's stated constraints.

| Horizon | Meaning | Criteria for assignment |
|---------|---------|------------------------|
| **H0** | Now → ~6 months | No unresolved dependencies; decision made; team/budget available or committed |
| **H1** | ~6 → 18 months | Dependencies will be resolved by H0 delivery; scoping in progress |
| **H2** | 18 months+ | Depends on H1 outcomes; strategic intent established, details TBD |

Rules:
- A gap cannot be assigned to a horizon earlier than all its dependencies
- Severity should influence horizon position — High severity gaps should not sit in H2 unless genuinely blocked by dependencies
- H0 should be feasible: if more than ~40% of all gaps land in H0, the horizon assignment is probably optimistic

If the user has stated delivery constraints (team capacity, budget cycle, regulatory deadlines), apply them as hard constraints on horizon assignment.

---

### Step 5 — Transition Architecture definition

For each horizon boundary (H0→H1, H1→H2), determine whether a named Transition Architecture is warranted.

**A TA is warranted when:**
- The system must be in a stable, operable state at the horizon boundary
- The H0 delivery leaves some components in the old state and some in the new state
- A cutover or parallel-run period is needed between horizons

**A TA is not needed when:**
- All gaps in the horizon close completely before the next horizon begins
- The horizon boundary is purely a planning artefact with no operational significance

For each Transition Architecture, define:

```
### TA-NN — <name>

**Represents:** The state of the architecture at the end of <horizon>.

**What is live:**
- <Component/capability A>: new target state
- <Component/capability B>: new target state

**What is not yet live:**
- <Component/capability C>: still in baseline state; gaps G-NN, G-NN not yet closed

**Data migration state:** <what has been migrated; what has not>

**Operational capabilities available:** <what the business can do in this state>

**Duration:** <how long this state is expected to persist before the next TA or the Target is reached>
```

Name TAs sequentially: `TA-01-<slug>`, `TA-02-<slug>` (e.g. `TA-01-parallel-run`, `TA-02-new-platform-live-legacy-read-only`).

---

### Step 6 — Work package definition

Group related gaps within the same horizon into **work packages**. A work package is the unit of delivery — roughly sized for one team over one planning cycle.

For each work package:

```
### WP-NN — <name>

**Horizon:** H0 / H1 / H2
**Closes gaps:** G-NN, G-NN
**Produces:** <TA-NN or specific deliverable>
**Dependencies:** WP-NN (must complete first)
**Owner:** <team or role>
**Scope:** <one sentence — what this package delivers and what it explicitly excludes>
```

Within a horizon, work packages may run in parallel if they have no dependencies between them. Make parallelism explicit — it is often the key to delivery speed.

---

### Step 7 — Write the roadmap document

Write to `<ROADMAP_DIR>/ArchitectureRoadmap.md` (or the path identified in Step 1).

```markdown
# Architecture Roadmap — <Programme or scope name>

> **ADM phase:** E / F
> **Domain:** cross-cutting
> **Stakeholders:** <named roles>
> **Decision class (per Phase H):** <Simplification | Incremental | Re-architecting>

---

## Summary

<One paragraph: what this roadmap covers, the Target Architecture it works toward, current status, and last updated date.>

---

## Baseline → Target → Gap summary

<Brief reference to the Gap Analysis. Link to the source document if it exists.>

**Gap count:** <N> total — <n> High, <n> Medium, <n> Low severity.

---

## Transition Architectures

### TA-01 — <name>
<As defined in Step 5>

### TA-02 — <name>
<…>

---

## Roadmap

### H0 — <date range>

| Work package | Closes gap(s) | Produces | Depends on | Owner |
|-------------|--------------|----------|------------|-------|
| WP-01 — <name> | G-01, G-02 | TA-01 | — | <team> |
| WP-02 — <name> | G-03 | TA-01 | WP-01 | <team> |

### H1 — <date range>

| Work package | Closes gap(s) | Produces | Depends on | Owner |
|-------------|--------------|----------|------------|-------|
| … | | | | |

### H2 — Strategic intent

| Work package | Closes gap(s) | Produces | Depends on | Owner |
|-------------|--------------|----------|------------|-------|
| … | | | | |

---

## Decommissioning schedule

| System / component | Decommission trigger | Target horizon | Owner |
|--------------------|---------------------|----------------|-------|
| <legacy system> | TA-02 achieved | H1 | <team> |

---

## Review triggers

| Trigger | Action |
|---------|--------|
| TA-01 achieved | Review H1 scope and refine work package sizing |
| Business priority change | Reassess horizon assignments; bring to Architecture Board |
| H0 slippage > 2 months | Escalate to Architecture Board; reassess H1 dependencies |
| Annual EA review | Full roadmap refresh |
```

---

### Step 8 — Phase F handoff notes

After writing the roadmap, produce a brief handoff note for Phase F (Migration Planning). This is not a full migration plan — it is the information the delivery team needs to begin planning:

For each H0 work package:
- **Cutover approach needed?** (big-bang / parallel run / phased by data domain)
- **Data migration scope?** (which entities, from which source, to which target)
- **Decommission dependency?** (what must be confirmed before the legacy system can be retired)
- **Operational readiness requirements?** (what SLAs, monitoring, runbooks must exist before cutover)

Present this as a table or checklist, not a narrative. The delivery team will own the detail.
