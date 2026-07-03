---
name: adr-generator
description: Generates a complete Architecture Decision Record for any TOGAF domain (Business, Application, Data, Technology). Routes to the correct directory, assigns the next free ADR number, checks principles, and writes the full file. Triggers on "ADR", "architecture decision", "document this decision", "capture this choice", "we need to decide on", "help me decide between", "write up the decision".
---

# ADR Generator

Generates end-to-end Architecture Decision Records across all four TOGAF domains. This skill is the active counterpart to `adr-and-decisions.mdc` — where the rule defines when to capture and what format to use, this skill does the capturing.

## When to use

- "Capture this as an ADR"
- "Write up the decision on X"
- "Document this architecture decision"
- "ADR for our choice of Y"
- Proactively when `adr-and-decisions.mdc` triggers and the user confirms

---

## Workflow

```
- [ ] Step 1: Repo discovery
- [ ] Step 2: Domain classification
- [ ] Step 3: Assign ADR number
- [ ] Step 4: Context gathering
- [ ] Step 5: Principles lookup
- [ ] Step 6: Draft the ADR
- [ ] Step 7: Write file
- [ ] Step 8: Offer to commit
```

---

### Step 1 — Repo discovery

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
```

Read `$REPO_ROOT/AGENTS.md` and extract:
- Domain folder paths (Business, Application, Data, Technology)
- `PRINCIPLES` — principles file (default: `principles.md`)
- `ACTION_ITEMS` — action items file (default: `ea-practice/action-items.md`)

If `AGENTS.md` is absent, use defaults and note the assumption.

---

### Step 2 — Domain classification

Determine which TOGAF domain this decision belongs to. If not clear from context, ask the user directly.

| Domain | Home directory | Decision examples |
|--------|---------------|-------------------|
| **Technology (Phase D)** | `TechnologyArchitecture/` | Platform choice, integration technology, runtime, identity baseline, hosting model |
| **Application (Phase C)** | `ApplicationArchitecture/` | Portfolio classification, build/buy/SaaS, consolidation target, integration pattern standardisation |
| **Data (Phase C)** | `DataArchitecture/` | System of record assignment, MDM approach, canonical model adoption, data ownership |
| **Business (Phase B)** | `BusinessArchitecture/` | Capability ownership, operating model, consolidation principle, sourcing model |

If the decision spans multiple domains (e.g. a platform choice that also sets a data ownership pattern), classify by the domain where the primary decision lives and note the cross-domain implications in the **Consequences** section.

---

### Step 3 — Assign ADR number

ADR numbers are **global** — shared across all domains. Find the next free number:

```bash
find $REPO_ROOT -name "ADR-*.md" | sort | tail -1
```

Extract the highest `NNNN` and increment by 1. If no ADRs exist, start at `ADR-0001`.

Confirm the target filepath: `<DOMAIN_DIR>/ADR-NNNN-<kebab-slug>.md`

The slug should be a short (3–6 word) kebab-case description of the decision: e.g. `api-gateway-platform-selection`, `customer-system-of-record-crm`, `contact-centre-capability-consolidation`.

---

### Step 4 — Context gathering

If not already provided in the conversation, ask for:

1. **What decision was made?** (one sentence — the chosen option)
2. **What options were considered?** (at least two; include any that were discarded and why)
3. **What were the key trade-offs?** (what does the chosen option give up?)
4. **What is the business driver or stakeholder concern?** (why is this decision being made now?)
5. **Who owns this decision?** (role or name)
6. **What is the scope?** (which systems, programmes, or platforms does this apply to?)
7. **Are there related ADRs or documents?** (links to reference)

Do not ask all seven at once if the conversation has already provided most of them. Extract what you can from context; ask only for what is genuinely missing.

---

### Step 5 — Principles lookup

Load `$PRINCIPLES`. For each Active principle, assess whether it is relevant to this decision:
- **Relevant and satisfied:** add to the Principles field
- **Relevant and in tension/conflicted:** add to the Principles field and note the conflict in **Context** or **Consequences**
- **Not relevant:** skip

If `principles.md` is absent: note `Principles: principles.md not found — create from ea-practice/principles-template.md` as an open item.

---

### Step 6 — Draft the ADR

Write the complete ADR using the format from `adr-and-decisions.mdc`. Populate every section. Use `TBD` only for genuinely unknown information and place it under **Open items**, not embedded in other sections.

**Quality checks before writing the file:**
- Does the **Decision** section state a single clear choice with triggers for alternatives?
- Are all discarded options listed with reasons?
- Does the **Principles** field reference at least one P-NN, or explicitly state `none` with a brief justification?
- Are **Consequences** honest — including the accepted trade-offs, not just the positives?
- Are **Open items** genuinely open, not just deferred decisions?

---

### Step 7 — Write the file

Write to `<DOMAIN_DIR>/ADR-NNNN-<kebab-slug>.md`.

Confirm the path with the user before writing if there is any ambiguity about the domain or slug.

---

### Step 8 — Offer to commit

Offer to commit the new ADR file. Suggested commit message format: `docs(adr): add ADR-NNNN <slug>` or follow the repo's git standards (check `.cursor/rules/` for a git-standards rule if present).

Do not commit unless the user confirms.

---

## ADR quality anti-patterns

Watch for these and correct them before writing the file:

| Anti-pattern | Correction |
|-------------|-----------|
| Decision section is vague ("use cloud services where appropriate") | Rewrite as a specific, testable choice with triggers for alternatives |
| Only one option considered | Ask for at least one alternative that was genuinely evaluated |
| Consequences are all positive | Name the real trade-offs — every decision gives something up |
| Principles field is empty or "none" for a major platform decision | Check principles.md more carefully; most significant decisions touch at least one |
| Open items are actually decisions | Resolve them before finalising, or note the ADR cannot be accepted until they are resolved |
| Status set to `Accepted` without board review | Status should be `Proposed (Draft)` until the Architecture Board approves |
