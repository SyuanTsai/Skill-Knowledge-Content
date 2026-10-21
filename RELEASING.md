<!--
SPDX-FileCopyrightText: 2026 SyuanTsai
SPDX-License-Identifier: Apache-2.0
-->
# Releasing and rollback

## Supported platform

Run local development, installation, execution, testing, acceptance, and CI on Windows. Linux, macOS, WSL, and Linux containers are not host fallbacks. Authorized SaaS, browser, and API services remain supported; platform-specific course code and commands remain source evidence. Every workflow job, including each required status mirror, runs on a Windows runner.

## Release contract

The stable source ID is `knowledge-content`. Skill IDs and their `skills/<skill-id>` source paths are stable API and must not be repurposed.

Before release:

1. Run the `Standard v1 Validation` source gate against the exact event candidate and base. The workflow calls the single public `scripts/Validate.ps1` entry point with `-PrepareSourceTools`, then calls it with `-SourceValidation` after preparing the required runtime and setup receipts. Its PASS is source evidence only and does not authorize release, installation, publication, or downstream cutover.
2. The repository contract diagnostic and regression suite are internal validation components, not additional release commands.
3. Confirm the validation workflow passes on the release commit.
4. Pin consumers to the full 40-character commit SHA or to a tag that resolves to that commit.
5. Record the emitted `contentSha256` for each released Skill when producing an external catalog lock.

Use immutable release tags. Do not move an existing release tag to another commit.

The active `8e627baf54bd6e47862e6291b25e71cc45a2f2b7` authority pin requires the protected two-purpose run. A bare `scripts/Validate.ps1` invocation fails closed and cannot count as a release result. The workflow requires an exact nonzero event base commit that is a distinct ancestor of the exact candidate commit; manual dispatch must supply that base explicitly.

The protected source gate covers stages 1–5 and runs Static without an LLM plus the complete repository test suite. A source report PASS, workflow success, review, or merge does not authorize release, installation, publication, or downstream cutover. The field `releaseEligible=false` remains false permanently; a separate release process must make its own decision. The [README local protected-run instructions](README.md#protected-local-run) list the required raw-checkout controls, clean roots, exact-base driver, verified runtime, and both canonical-purpose commands.

## Updating a Skill

Keep the stable Skill ID and directory path. Update `SKILL.md`, `agents/openai.yaml`, references, scripts, assets, and tests together when required. Run validation before tagging.

## Adding a Skill

Add the Skill under `skills/<skill-id>/` and add exactly one matching string to `catalog/source.json`. The validators reject undeclared or missing Skill directories.

## Rename or removal

Do not silently rename a stable Skill ID. Coordinate rename/removal through the consuming Catalog lifecycle contract before changing this repository. Keep rollback possible until consumers have moved to a new pinned source version.

## Rollback

Rollback is performed by selecting the previously validated full commit SHA or immutable tag. Because consumers pin source commits and verify deterministic Skill content hashes, reverting the source pin restores the previous repository inventory without rewriting release history.

Rollback must use a normal reviewed PR that reverts the entire adoption, including the `.github/workflows/validate.yml` 8e62 activation, `config/standard-v1.json`, active driver, tests, and docs. Restore the complete previously validated ff85 authority tuple: commit `ff85d5f80fe795b96354e753074b5ce59ad04ecd`, archive SHA-256 `3dc38613f2e2316ad8fcc79d4bf48d0b03fd8398f8dacc72d156abcbce95ea9d`, and its full 32-file hash inventory, along with the prior protected two-purpose workflow. Reverting only the config or driver while leaving the 8e62 source workflow active is invalid because that workflow rejects the ff85 authority. The prepared base reader accepts either complete approved tuple; rerun the restored gate with fresh receipts before making any separate release decision.
