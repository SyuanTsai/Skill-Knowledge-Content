<!--
SPDX-FileCopyrightText: 2026 SyuanTsai
SPDX-License-Identifier: Apache-2.0
-->
# Three-platform consumer gate

Repository CI is provided by the authority-published `consumer-gate` workflow. It validates the candidate on `windows-latest`, `ubuntu-latest`, and `macos-latest` using the immutable authority commit in `config/authority-pin.json`.

Each platform runs both repository-owned checks declared in `config/consumer-gate.json`:

- `scripts/Test-KnowledgeContentRepository.ps1` validates the Knowledge Content source and package contract from a read-only snapshot;
- `tests/` is discovered and executed as the complete Pester suite by the pinned authority runtime.

The transition workflow is present only during the initial conversion and is removed by the follow-up cleanup pull request. Routine authority upgrades modify only `config/authority-pin.json`; copied authority templates must remain byte-identical to their published versions.

Remote environment, App, event-policy, and ruleset configuration are deployment prerequisites outside this repository. Repository files alone do not prove that remote merge enforcement is active.
