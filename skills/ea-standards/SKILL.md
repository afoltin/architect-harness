---
name: ea-standards
description: Actively reviews an architecture document against EA standards — checks the ADM-phase header, ABB/SBB discipline, principle citations, stakeholder concern traceability, and gap naming. Produces a structured findings table and offers to fix missing elements in place. Use when the user asks to "review this doc", "apply EA standards", "check this artifact", "is this TOGAF-aligned", or "add the ADM header to this".
---

# EA Standards Review

Active companion to `togaf-core.mdc`. Where the Cursor rule shapes how the agent thinks, this skill actively assesses a document and produces a structured review — rating each EA standard dimension and offering to fix gaps in place.

## When to use

- "Review this architecture doc"
- "Apply EA standards to this"
- "Is this TOGAF-aligned?"
- "Check this artifact"
- "Add the ADM header"
- "What's missing from this design doc?"

---

## Workflow

```
- [ ] Step 1: Repo discovery
- [ ] Step 2: Identify document type and ADM domain
- [ ] Step 3: Run the EA standards checklist
- [ ] Step 4: Produce the review output
- [ ] Step 5: Offer to fix gaps in place
```

---

### Step 1 — Repo discovery

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
```

Read `$REPO_ROOT/AGENTS.md` and extract:
- `PRINCIPLES` — principles file path (default: `principles.md`)
- Domain folder mapping — to correctly classify the document's domain

Load `$PRINCIPLES` if it exists. If absent, note it as a finding but continue the review.

---

### Step 2 — Identify document type and ADM domain

From the file path and content, determine:

| Question | How to assess |
|----------|--------------|
| **Which TOGAF domain?** | File path (e.g. `ApplicationArchitecture/` → Phase C-App); or infer from content if cross-cutting |
| **Is this a new or existing artifact?** | Check for the ADM-phase header block already present |
| **Is this a journal entry or process note?** | If yes, these use their own formats — skip the ADM header check, but still check action-item and principle citations |
| **What is the primary audience?** | Delivery team, Architecture Board, executive? (affects depth expectations) |

---

### Step 3 — Run the EA standards checklist

Assess each dimension. Rating: ✅ Present and correct | ⚠️ Present but incomplete or inconsistent | ❌ Missing

#### Dimension 1 — ADM-phase header

Check for:
```
> **ADM phase:** <A | B | C-App | C-Data | D | E | F | G | H>
> **Domain:** <Business | Application | Data | Technology | cross-cutting>
> **Stakeholders:** <named roles or groups>
> **Decision class (per Phase H):** <Simplification | Incremental | Re-architecting>
```

- ✅ All four fields present and consistent with document content
- ⚠️ Present but one or more fields are vague (e.g. "Various stakeholders", domain conflicts with file location)
- ❌ Header absent entirely

#### Dimension 2 — ABB before SBB

Scan the document for product names, vendor names, or specific technology references. For each:
- Is the capability (ABB) stated before the product (SBB)?
- Is the SBB selection justified against the ABB?

- ✅ All product/vendor references preceded by capability statements
- ⚠️ Some SBBs named without ABB justification; note the specific instances
- ❌ No capability language; document is entirely product/vendor focused

#### Dimension 3 — Principle citations

For each recommendation or significant choice in the document:
- Is a relevant principle from `principles.md` cited?
- If a recommendation conflicts with an Active principle, is the conflict named?

- ✅ Relevant principles cited inline; conflicts named and justified
- ⚠️ Some decisions lack principle citations; no conflicts named (may mean no conflicts exist — note if plausible)
- ❌ No principle citations at all; or known conflicts with Active principles not named

If `principles.md` is absent: note as ❌ with recommendation to create from `ea-practice/principles-template.md`.

#### Dimension 4 — Stakeholder concern traceability

- Are stakeholders named (not just "the business" or "users")?
- Is each stakeholder's specific concern stated?
- Does the document show how each concern is addressed or accepted as a trade-off?

- ✅ Named stakeholders with specific concerns and explicit responses
- ⚠️ Stakeholders named but concerns are generic; or concerns named but no response shown
- ❌ No stakeholder or concern language

#### Dimension 5 — Gap naming

If the document proposes a Target state:
- Is the Baseline explicitly stated?
- Is the Gap named (not implied)?
- If the gap is multi-step, is at least one Transition Architecture named?

- ✅ Baseline → Gap → Transition Architecture(s) → Target clearly articulated
- ⚠️ Target described but Baseline or Gap only implicit
- ❌ No Baseline or Gap; document goes directly to solution

#### Dimension 6 — Business driver traceability

Every significant architectural recommendation should link to a business driver, named capability, or stakeholder concern.

- ✅ Recommendations explicitly reference business drivers or capabilities from Phase B
- ⚠️ Some recommendations lack a stated business driver; architecture appears to float free
- ❌ No business driver language anywhere; document is purely technical

#### Dimension 7 — ADR trigger check

Scan for decisions that may qualify for an ADR (apply criteria from `adr-and-decisions.mdc`):
- Is the decision reusable?
- Is it architecturally significant?
- Were trade-offs considered?

Note any qualifying decisions not yet captured as ADRs.

---

### Step 4 — Produce the review output

```markdown
## EA Standards Review — <document name>

| Dimension | Rating | Finding |
|-----------|--------|---------|
| ADM-phase header | ✅/⚠️/❌ | <specific finding> |
| ABB before SBB | ✅/⚠️/❌ | <specific finding> |
| Principle citations | ✅/⚠️/❌ | <specific finding> |
| Stakeholder traceability | ✅/⚠️/❌ | <specific finding> |
| Gap naming | ✅/⚠️/❌ | <specific finding> |
| Business driver traceability | ✅/⚠️/❌ | <specific finding> |
| ADR triggers | ✅/⚠️/❌ | <specific finding or "none identified"> |

### Summary

<One paragraph: overall assessment, the two or three most important gaps, and a recommended next step.>

### Priority fixes

1. <Most important gap — specific and actionable>
2. <Second gap>
3. <…>
```

Be specific in findings — "Stakeholders listed as 'the business' without named concerns" is useful; "stakeholder traceability could be improved" is not.

---

### Step 5 — Offer to fix in place

After delivering the review, offer to fix the identified gaps directly in the document. Prioritise:

1. **ADM-phase header** — can be added immediately; ask the user to confirm the four values if they're not clear from context.
2. **ABB gaps** — offer to add capability statements before each SBB reference.
3. **Missing principle citations** — offer to add inline P-NN citations where they apply.
4. **Stakeholder concern table** — offer to add a traceability table (use the template from `business-architecture.mdc`).
5. **ADR triggers** — offer to draft the ADR for any qualifying decision identified.

For each offer, be specific about what will change. Do not apply fixes without confirmation.
