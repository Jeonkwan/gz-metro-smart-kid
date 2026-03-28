---
name: metro-line-content
description: "Use when adding new Guangzhou/Foshan metro line content or rewriting existing data/en/*.md and data/zh/*.md files. Triggers: metro line content, rewrite line info, add line history, station facts, kid-friendly bilingual markdown, source-backed metro article."
---

# Metro Line Content Skill

## Goal
Create or rewrite metro line markdown content that is:
- Accurate and source-backed
- Child-friendly for around age 6
- Read-aloud friendly
- Story-rich without fictionalizing facts
- Bilingual and fact-consistent

## Scope
This skill supports two tasks:
1. Add a new line file pair
2. Rewrite an existing line file pair
3. Validate fact accuracy after any metro line content change

## Required Inputs
- Line ID (example: `line-1`, `guangfo`)
- Task type: New or Rewrite
- Preferred source language(s): EN/ZH
- Optional focus: history-heavy, station-heavy, or balanced

## Required Outputs
- `data/en/<line-id>.md`
- `data/zh/<line-id>.md`
- Completed research log (copy from asset template)
- QA checklist pass statement

## Workflow
1. Planning
- Load requirements from `docs/content-requirements.md`.
- Copy the research sheet from `assets/research-task-sheet.md`.

2. Research
- Collect reliable sources.
- Map each core claim to source URLs.
- Mark single-source claims clearly.

3. Drafting
- Use `assets/line-content-template.md` structure.
- Add a `Story Time` section that gives background, context, and a child-friendly narrative arc.
- Draft English first with short, child-friendly sentences.
- Draft Chinese with matching facts and section order.

4. QA
- Run checks from `assets/qa-checklist.md`.
- Re-check every changed claim against source links before publish.
- Fix any structure, language, or source gaps.

5. Publish
- Write paired files to `data/en` and `data/zh`.
- Include full source list in each file.

## Guardrails
- Never invent information.
- If a fact is uncertain, do not present it as certain.
- Explain difficult terms before continuing.
- Explain important hard terms briefly when they first appear.
- Keep paragraphs short for text-to-speech pacing.
- Every edit to metro line markdown requires a fact-check review pass.
- If only one reliable source exists for a changed core claim, mark it as single-source in research notes.
- `Story Time` may be vivid and warm, but it must stay factual.

## Writing Rules
- 2 to 4 lines in Quick Intro.
- Use `Story Time` to explain the city's need, the line's background, and why the opening mattered.
- Keep one idea per sentence when possible.
- Prefer concrete examples children can imagine.
- Add Memory Check questions to reinforce key facts.

## Assets
- `assets/research-task-sheet.md`
- `assets/line-content-template.md`
- `assets/qa-checklist.md`

## Done Criteria
A task is done only if:
- Research evidence exists for core facts.
- All newly added or changed claims were re-validated against sources.
- Both EN and ZH files are updated.
- Section order is complete and consistent.
- `Story Time` adds meaningful background context rather than repeating the timeline.
- QA checklist passes with no open blockers.
