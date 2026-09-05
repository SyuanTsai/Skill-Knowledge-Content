<!--
SPDX-FileCopyrightText: 2026 SyuanTsai
SPDX-License-Identifier: Apache-2.0
-->
# Releasing and rollback

## Release contract

The stable source ID is `knowledge-content`. Skill IDs and their `skills/<skill-id>` source paths are stable API and must not be repurposed.

Before release:

1. Run `./scripts/Test-Repository.ps1` for the repository contract and `./scripts/Validate.ps1` for the complete Standard v1 gate.
2. Run `Invoke-Pester ./tests -CI` with Pester 5+.
3. Confirm the validation workflow passes on the release commit.
4. Pin consumers to the full 40-character commit SHA or to a tag that resolves to that commit.
5. Record the emitted `contentSha256` for each released Skill when producing an external catalog lock.

Use immutable release tags. Do not move an existing release tag to another commit.

## Updating a Skill

Keep the stable Skill ID and directory path. Update `SKILL.md`, `agents/openai.yaml`, references, scripts, assets, and tests together when required. Run validation before tagging.

## Adding a Skill

Add the Skill under `skills/<skill-id>/` and add exactly one matching string to `catalog/source.json`. The validators reject undeclared or missing Skill directories.

## Rename or removal

Do not silently rename a stable Skill ID. Coordinate rename/removal through the consuming Catalog lifecycle contract before changing this repository. Keep rollback possible until consumers have moved to a new pinned source version.

## Rollback

Rollback is performed by selecting the previously validated full commit SHA or immutable tag. Because consumers pin source commits and verify deterministic Skill content hashes, reverting the source pin restores the previous repository inventory without rewriting release history.
