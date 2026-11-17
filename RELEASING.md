<!--
SPDX-FileCopyrightText: 2026 SyuanTsai
SPDX-License-Identifier: Apache-2.0
-->
# Releasing and rollback

## Validation contract

The stable source ID is `knowledge-content`. Skill IDs and their `skills/<skill-id>` paths are stable API and must not be repurposed.

The pinned authority consumer gate validates every pull request on Windows, Linux, and macOS. Each platform runs `scripts/Test-KnowledgeContentRepository.ps1` against a read-only candidate snapshot and executes the complete `tests/` suite. A green gate is source evidence; release, installation, publication, and downstream cutover remain separate decisions.

Before release:

1. Confirm the consumer gate passes on the exact release commit on all three platforms.
2. Confirm `catalog/source.json` exactly matches the Skill package directories.
3. Pin consumers to the full source commit SHA or to an immutable tag resolving to it.
4. Record each emitted `contentSha256` when producing an external catalog lock.

Use immutable release tags. Do not move an existing tag to another commit.

## Authority updates

Routine authority upgrades change only the full 40-character commit in `config/authority-pin.json`. The pinned consumer gate verifies the official authority repository and immutable commit. Do not hand-edit or regenerate the authority-published bootstrap or workflow template.

## Updating or adding a Skill

For an update, keep the stable Skill ID and directory path. Update `SKILL.md`, `agents/openai.yaml`, references, scripts, assets, and tests together when required.

For a new Skill, add `skills/<skill-id>/` and exactly one matching string to `catalog/source.json`. The repository check rejects undeclared or missing package directories.

## Rename or removal

Do not silently rename a stable Skill ID. Coordinate rename or removal through the consuming Catalog lifecycle contract and keep rollback possible until consumers have moved.

## Rollback

Rollback uses a normal reviewed pull request. Restore the previously validated Skill source commit or change `config/authority-pin.json` to a previously validated authority commit, depending on what must be reversed. The consumer gate must pass again on all three platforms. Do not rewrite release history or mix files from different authority versions.
