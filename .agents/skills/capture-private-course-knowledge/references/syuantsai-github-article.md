# SyuanTsai.github.io Article Export

Use this reference when durable course notes must become a specific article for [SyuanTsai/SyuanTsai.github.io](https://github.com/SyuanTsai/SyuanTsai.github.io). The article is an original public synthesis, not a transcript, course substitute, or public copy of the private evidence bundle.

## Reinspect the target

Before each article generation, inspect the current repository rather than relying only on this snapshot:

- repository-level instructions and contribution guidance;
- default or publishing branch, working tree, and existing changes when a local checkout is used;
- `_config.yml`, `Gemfile`, the two most recent substantive posts, relevant layouts and includes, and any asset convention;
- documented build, preview, lint, and deployment workflow.

As observed on 2026-08-12, the site publishes from `gh-pages`, uses Jekyll with the Minima remote theme, declares `zh-tw`, and stores posts under `_posts/` as `.markdown` files. Treat these as discoverable defaults, not permanent facts.

If the target repository is temporarily unavailable, a user-requested draft may use the last verified snapshot only when it is labeled provisional. Mark repository-dependent front matter and paths as needing revalidation, and do not call the result compatible, publication-ready, or published.

## Choose the article contract

Record the intended audience, one central question or outcome, article type, output language, intended publication date, and requested publication state. Use the user's requested publication date when supplied. Otherwise use the local draft date and flag it for confirmation before publication.

## Build a private evidence map

Create the smallest useful equivalent of:

```text
exports/syuantsai-github/
├─ article-plan.md
├─ _posts/
│  └─ YYYY-MM-DD-<slug>.markdown
└─ article-evidence-map.json
```

For every substantive claim, code block, procedure, and demonstrated result, record in `article-evidence-map.json` the article section, course/lesson/material IDs and revisions, precise source locators, supporting artifacts, transformation type, confidence, uncertainty, privacy decision, and validation performed.

Keep `article-plan.md` and `article-evidence-map.json` with the private course notes. They are editorial provenance, not website content, and must not be copied into the public repository.

## Transform private teaching into a public article

- Write an original explanation organized around the reader's problem and outcome. Do not follow the lecture sentence by sentence.
- Use only facts supported by captured evidence.
- Remove private lesson URLs, account or organization details, access instructions, learner data, credentials, tokens, private endpoints, and identifying screen content.
- Do not publish raw frames, PDF pages, slide reproductions, transcripts, paid attachments, or proprietary project files by default.
- Use the minimum code needed to teach the point and distinguish verified excerpts from independently derived generalized examples.
- Keep instructor claims distinct from the author's analysis, modernization, correction, and external enrichment.

## Match the current Jekyll post format

Unless the latest repository conventions differ, generate:

```markdown
---
layout: post
title: "<specific Traditional Chinese title>"
date: YYYY-MM-DD
categories: <categories matching the site's current syntax>
---

# <reader-facing heading>

<opening problem, outcome, and why it matters>

## <mental model or context>

## <verified walkthrough, example, or analysis>

## <result, limitations, and applicable conditions>

## <practical takeaways>
```

Use `_posts/YYYY-MM-DD-<ASCII-kebab-case-slug>.markdown` unless the repository has adopted another convention.

## Validate the public payload

Before presenting an article as publication-ready:

1. Compare every material statement and code block with the private evidence map.
2. Review the post and approved assets for secrets, private URLs, identifying information, copyrighted over-reproduction, and unsupported claims.
3. Check filename, date, front matter, categories, links, Markdown or Liquid syntax, and asset paths against the current repository.
4. Run the repository's documented checks; when applicable run `bundle exec jekyll build` and `git diff --check`.
5. Inspect the rendered article when rendering is available.
6. Report validation that could not run and keep the status as draft when a material check is missing.

The publication handoff must identify the generated post path, article angle, evidence-map path, excluded private material, approved public assets, validation results, and whether the article is only a draft, changed locally, committed, pushed, or published.
