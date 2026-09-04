<!--
SPDX-FileCopyrightText: 2026 SyuanTsai
SPDX-License-Identifier: Apache-2.0
-->
# Skill-Knowledge-Content

Independent Agent Skills repository for the **Knowledge & Content** domain.

## Repository contract

- Stable source ID: `knowledge-content`
- Repository: `SyuanTsai/Skill-Knowledge-Content`
- Skill layout: `.agents/skills/<skill-id>/**`
- Source inventory: `catalog/source.json`
- Validation entry point: `scripts/validate.ps1`
- Contract tests: `tests/repository.Tests.ps1`
- Release and rollback rules: `RELEASING.md`

## License and content boundary

The Apache-2.0 license in [LICENSE](LICENSE) applies to the repository-authored Skill instructions, agent metadata, procedural references, source metadata, documentation, validation scripts, tests, and workflow configuration. It does not grant rights to course providers, publishers, NotebookLM, GitHub, or other external services.

Course and lecture videos or audio, PDFs, slides,教材, code, attachments, archives, retrieved text, transcripts, OCR, notes, exports, articles, and other user-provided or third-party material are inputs or outputs rather than Apache-2.0 repository content. Processing them with this tool does not automatically relicense them; users must confirm the rights for each input and output.

The repository does not vendor course materials or third-party source code. See [PROVENANCE.md](PROVENANCE.md) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). Contributors must have the right to submit their contribution; unless a separate written agreement says otherwise, an intentional contribution to the repository-authored scope is submitted under Apache-2.0 and must preserve existing notices.

## Skills

### `capture-private-course-knowledge`

Captures and integrates authorized course and lecture material across video/audio, PDFs, slides, code, attachments, durable notes, NotebookLM exports, and article generation.

Path:

```text
.agents/skills/capture-private-course-knowledge/
├─ SKILL.md
├─ agents/
│  └─ openai.yaml
└─ references/
   ├─ course-notes-format.md
   ├─ notebooklm-export.md
   ├─ pdf-material-capture.md
   ├─ syuantsai-github-article.md
   └─ video-capture.md
```

## Validation

Run from the repository root:

```powershell
./scripts/validate.ps1
```

The validator checks:

- the stable `knowledge-content` source metadata;
- source inventory against actual `.agents/skills/*` directories;
- lowercase stable Skill IDs and flat source paths;
- required `SKILL.md` and `agents/openai.yaml` files;
- `SKILL.md` name matching the stable Skill ID;
- deterministic `contentSha256` using repository-relative paths and raw file SHA-256 values.

Run contract tests with Pester 5+:

```powershell
Invoke-Pester ./tests -CI
```

GitHub Actions executes both checks for pushes and pull requests.

## Versioning

Consumers should pin this repository to a full commit SHA or an immutable release tag resolving to that commit. Skill content hashes are deterministic and are emitted by the validation script for use by external catalog locks.

Do not repurpose stable Skill IDs or move a Skill away from `.agents/skills/<skill-id>` without coordinating the consuming Catalog lifecycle contract.

## Release, update, rename, removal, and rollback

See [RELEASING.md](RELEASING.md). Rollback is performed by returning the consumer source pin to a previously validated commit or immutable tag; release history must not be rewritten.

## Migration scope

This repository owns the Knowledge & Content Skill source after migration. Cross-repository Catalog/bootstrap cutover is intentionally outside this repository's own baseline and is handled separately.
