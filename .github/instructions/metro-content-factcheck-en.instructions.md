---
applyTo: "data/en/*.md"
description: "Use when editing English metro line markdown files. Enforce fact-check review, source-backed claims, and bilingual consistency with paired Chinese file updates."
---

# Metro Content Fact-Check Rule (EN)

When editing files under `data/en/*.md`, you must run a fact-check review before finalizing.

## Mandatory Review Steps
1. Re-check every changed or newly added claim against reliable sources.
2. Ensure all core facts remain source-backed:
- opening timeline
- route and transfer claims
- station highlights
- fun facts
3. If a changed core claim has only one reliable source, flag it as single-source in notes.
4. Confirm the paired Chinese file under `data/zh/<line-id>.md` is fact-consistent.

## Completion Gate
Do not finalize EN content edits unless:
- Sources are present and usable.
- Changed claims are re-validated.
- Paired ZH content is updated or explicitly queued for immediate follow-up.
