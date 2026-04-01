# Metro Line Content Requirements

## Purpose
Create metro line content that helps children around age 6 learn Guangzhou metro history and facts in a fun, clear, and accurate way.

## Scope
- Add new line content
- Rewrite existing line content
- Keep bilingual parity for English and Chinese files

## Required File Pair
Each line must have exactly two files:
- `data/en/<line-id>.md`
- `data/zh/<line-id>.md`

## Non-Negotiable Rules
1. Do not invent facts.
2. Every major fact must have a source.
3. Write for children with simple language.
4. Explain difficult words before moving on.
5. Keep sentence and paragraph length short for read-aloud.
6. Keep EN and ZH fact-consistent.

## Section Framework (Required Order)
1. Quick Intro
2. Story Time
3. Time Story
4. Challenges Along the Way
5. Route Snapshot
6. Important Stations for Kids
7. Fun Facts
8. Word Helper
9. Memory Check
10. Photos
11. Sources

## Photos Section Rules
- Add 2 to 3 photos for each line file.
- Do not store photo binaries in this repo. Use external links only.
- Each photo entry must include: preview image URL, original image URL, caption, source site name with link, photographer or author when available, and risk note.
- Source priority:
  1) Official operator/government pages
  2) Openly licensed repositories such as Wikimedia Commons
  3) Other public web sources only when needed
- If source type (3) is used, include a clear risk note in both rendered content and research/QA notes.
- Caption should name the verified station or landmark when possible.
- EN and ZH photo entries must be fact-consistent and point to the same media URLs unless there is a documented reason to differ.

## Story Time Rules
- Use this section to explain the background in a vivid, child-friendly way.
- Include the city problem or travel need before the line was built.
- Explain why people wanted the line.
- Include 1 to 2 source-backed construction or opening details.
- End with a short sentence about why the line still matters today.
- Narrative tone is allowed, but fiction is not.
- Do not invent nicknames, dialogue, feelings, or scenes unless supported by sources.

## Challenges Along the Way Rules
- Use this section to explain what made the project difficult.
- Challenges may include engineering difficulty, underground conditions, crowded city environment, river crossings, relocation work, policy limits, budget pressure, or construction staging.
- Only include challenges that can be tied to reliable sources for that specific line.
- Separate verified line-specific challenges from general metro-building knowledge.
- Explain each challenge in simple child-friendly language.
- Focus on 2 to 4 meaningful challenges, not a long technical list.

## Source Quality Rules
Preferred priority:
1. Official operator/government pages
2. High-quality references (cross-check)
3. News/media only as supporting context

Verification rule:
- Core facts should be verified by at least two independent reliable sources when possible.
- If only one reliable source exists, mark it as single-source in research notes.

## Bilingual Consistency Rules
1. EN and ZH describe the same facts.
2. Section order is identical.
3. Naming style is consistent (line names, station names).
4. Readability can differ; facts cannot.

## Length Guidance
Suggested range per language file:
- 500 to 1,000 words

## Completion Standard
A line is complete only when:
- Research task sheet is filled
- Draft follows template
- QA checklist passes
- Sources are present and valid
- Story Time is informative, engaging, and source-backed
- Challenges Along the Way is factual, clear, and not speculative
