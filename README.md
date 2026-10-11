<!--
SPDX-FileCopyrightText: 2026 SyuanTsai
SPDX-License-Identifier: Apache-2.0
-->
# Skill-Knowledge-Content

Independent Agent Skills repository for the **Knowledge & Content** domain.

## Repository contract

- Stable source ID: `knowledge-content`
- Repository: `SyuanTsai/Skill-Knowledge-Content`
- Skill layout: `skills/<skill-id>/**`
- Source inventory: `catalog/source.json`
- Validation entry point: `scripts/Validate.ps1`
- Contract tests: the repository regression suite
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
skills/capture-private-course-knowledge/
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

The public validation entry point is `scripts/Validate.ps1`. With the active Standard v1 pin at `ff85d5f80fe795b96354e753074b5ce59ad04ecd`, validation has two explicit purposes: `scripts/Validate.ps1 -PrepareSourceTools` creates run-owned setup receipts, and `scripts/Validate.ps1 -SourceValidation` performs the protected source acceptance using those receipts and the exact event base commit. The protected workflow invokes both purposes with the required clean roots and runtime evidence. A bare `scripts/Validate.ps1` call fails closed while this ff85 pin is active, so it cannot be mistaken for a completed release gate.

The validator checks:

- the stable `knowledge-content` source metadata;
- source inventory against actual `skills/*` directories;
- lowercase stable Skill IDs and flat source paths;
- required `SKILL.md` and `agents/openai.yaml` files;
- `SKILL.md` name matching the stable Skill ID;
- deterministic `contentSha256` using repository-relative paths and raw file SHA-256 values.

The canonical validator invokes the repository contract and Pester components. They are not additional public validation commands. The protected source gate covers stages 1–5 and runs Static without an LLM plus the complete repository test suite. GitHub Actions checks out the exact event candidate and protected base on Windows, verifies the clean ff85 authority, prepares the verified PowerShell and locked Pester runtimes, then invokes the same `scripts/Validate.ps1` entry point once for each explicit purpose. The source report must pass the source authority's final report assertion before the canonical job succeeds; the existing required status contexts mirror that one gate result. This source gate does not grant release, installation, publication, or downstream cutover authority. The field `releaseEligible=false` remains false permanently, including after a PASS, review, or merge.

### Protected local run

The local equivalent uses a clean candidate checkout at the exact event head and a separate, clean protected-driver checkout of this repository at the exact event base. Before cloning or checking out any of these roots, set global `core.autocrlf=false`; keep it false through source validation so checkout files and subsequent Git archives retain committed bytes. Recreate any checkout made while line-ending conversion was enabled. The base must be a full nonzero 40-character SHA, must resolve to itself, and must be a distinct ancestor of the candidate. Use a separate clean authority checkout at `ff85d5f80fe795b96354e753074b5ce59ad04ecd`. `OwnedRoot` is a fresh parent that contains `RuntimeRoot` and the Pester setup area. Keep `ArtifactsRoot` fresh as a separate sibling outside `OwnedRoot`, candidate, driver, authority, and runtime; setup cleanup must stay within its owned paths and must not remove those roots. `SourceToolsPath` must be directly under `ArtifactsRoot`. Use the exact stable Go version installed for the run. Verify the official PowerShell archive hash against the release `hashes.sha256` and its `pwsh.exe` Microsoft Authenticode signature before using it.

Set the root paths and event SHAs first. Then run the global line-ending control and verification before cloning or checking out the three repositories. After checkout, the commands below bind the exact event head, protected driver base, clean ancestry, effective line-ending settings, and clean worktrees. The Pester setup uses the same verified PowerShell and `RUN_OWNED_ROOT` between the two canonical calls:

```powershell
$CandidateRoot = 'C:\work\candidate'
$DriverRoot = 'C:\work\driver-at-event-base'
$AuthorityRoot = 'C:\work\authority-ff85'
$OwnedRoot = 'C:\work\owned-run-unique'
$RuntimeRoot = Join-Path $OwnedRoot 'runtime'
$ArtifactsRoot = 'C:\work\artifacts-run-unique'
$CandidateHead = $env:KC_EVENT_HEAD_COMMIT
$BaseCommit = $env:KC_EVENT_BASE_COMMIT

# Run before cloning or checking out candidate, driver, and authority.
git config --global core.autocrlf false
if ($LASTEXITCODE -ne 0) { throw 'Could not disable global Git line-ending conversion before checkout.' }
$globalAutoCrlf = (& git config --global --get core.autocrlf 2>$null | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or $globalAutoCrlf -cne 'false') { throw 'Global core.autocrlf must remain false.' }

# These paths must be separate clones created after the global setting above.
if ($CandidateHead -cnotmatch '^[0-9a-f]{40}$' -or $CandidateHead -match '^0+$' -or $BaseCommit -cnotmatch '^[0-9a-f]{40}$' -or $BaseCommit -match '^0+$') { throw 'Supply exact nonzero event head and base SHAs.' }
& git -C $CandidateRoot checkout --detach $CandidateHead
if ($LASTEXITCODE -ne 0) { throw 'Could not check out the exact event candidate head.' }
& git -C $DriverRoot checkout --detach $BaseCommit
if ($LASTEXITCODE -ne 0) { throw 'Could not check out the exact event base as protected driver.' }
& git -C $AuthorityRoot checkout --detach ff85d5f80fe795b96354e753074b5ce59ad04ecd
if ($LASTEXITCODE -ne 0) { throw 'Could not check out the exact ff85 authority.' }

$candidateHeadObserved = (& git -C $CandidateRoot rev-parse --verify --end-of-options 'HEAD^{commit}' 2>$null | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or $candidateHeadObserved -cne $CandidateHead) { throw 'Candidate HEAD must equal the exact event head.' }
$driverHeadObserved = (& git -C $DriverRoot rev-parse --verify --end-of-options 'HEAD^{commit}' 2>$null | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or $driverHeadObserved -cne $BaseCommit) { throw 'Protected driver HEAD must equal the exact event base.' }
$baseObserved = (& git -C $CandidateRoot rev-parse --verify --end-of-options "$($BaseCommit)^{commit}" 2>$null | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or $baseObserved -cne $BaseCommit) { throw 'The event base must resolve to itself in the candidate checkout.' }
& git -C $CandidateRoot merge-base --is-ancestor $BaseCommit $CandidateHead
if ($LASTEXITCODE -ne 0 -or $BaseCommit -ceq $CandidateHead) { throw 'The exact event base must be a distinct ancestor of the event candidate.' }

foreach ($root in @($CandidateRoot, $DriverRoot, $AuthorityRoot)) {
  & git -C $root config --local core.autocrlf false
  if ($LASTEXITCODE -ne 0) { throw "Could not disable checkout line-ending conversion: $root" }
  $effectiveAutoCrlf = (& git -C $root config --get core.autocrlf 2>$null | Out-String).Trim()
  if ($LASTEXITCODE -ne 0 -or $effectiveAutoCrlf -cne 'false') { throw "Effective core.autocrlf must be false: $root" }
  $dirty = @(& git -C $root status --porcelain=v1 --untracked-files=all)
  if ($LASTEXITCODE -ne 0 -or $dirty.Count -ne 0) { throw "Checkout must be clean: $root" }
}

$PowerShellExecutable = Join-Path $RuntimeRoot 'pwsh.exe'
$SourceToolsPath = Join-Path $ArtifactsRoot 'source-tools.json'
$env:RUN_OWNED_ROOT = $OwnedRoot
$env:GITHUB_EVENT_NAME = 'pull_request'
$goVersionOutput = & go version
if ($LASTEXITCODE -ne 0 -or $goVersionOutput -notmatch '^go version go(?<version>[0-9]+\.[0-9]+\.[0-9]+)') { throw 'A stable Go runtime is required.' }
$env:STANDARD_GO_RUNTIME_VERSION = $Matches.version
if (-not (Test-Path -LiteralPath $RuntimeRoot -PathType Container) -or
    -not (Test-Path -LiteralPath (Join-Path $RuntimeRoot 'pwsh.exe') -PathType Leaf)) { throw 'OwnedRoot must contain the verified runtime directory.' }
if (Test-Path -LiteralPath $ArtifactsRoot) { throw 'ArtifactsRoot must be fresh and unique.' }
[void](New-Item -ItemType Directory -Path $ArtifactsRoot -ErrorAction Stop)

& $PowerShellExecutable -NoProfile -NonInteractive -File (Join-Path $DriverRoot 'scripts/Prepare-PesterRuntime.ps1') `
  -RuntimeExecutable $PowerShellExecutable -OwnedRoot $OwnedRoot
if ($LASTEXITCODE -ne 0) { throw 'Locked Pester runtime setup failed.' }

& $PowerShellExecutable -NoProfile -NonInteractive -File (Join-Path $DriverRoot 'scripts/Validate.ps1') `
  -RepositoryRoot $CandidateRoot -PrepareSourceTools -ArtifactsRoot $ArtifactsRoot `
  -SourceToolsPath $SourceToolsPath -AuthorityRepositoryRoot $AuthorityRoot `
  -TrustedToolRoot $RuntimeRoot -ExpectedGoRuntimeVersion $env:STANDARD_GO_RUNTIME_VERSION -TimeoutSeconds 1800
if ($LASTEXITCODE -ne 0) { throw 'Protected source-tool preparation failed.' }

& $PowerShellExecutable -NoProfile -NonInteractive -File (Join-Path $DriverRoot 'scripts/Validate.ps1') `
  -RepositoryRoot $CandidateRoot -SourceValidation -ArtifactsRoot $ArtifactsRoot `
  -SourceToolsPath $SourceToolsPath -AuthorityRepositoryRoot $AuthorityRoot `
  -TrustedToolRoot $RuntimeRoot -BaseCommit $BaseCommit `
  -ExpectedGoRuntimeVersion $env:STANDARD_GO_RUNTIME_VERSION -TimeoutSeconds 1800
if ($LASTEXITCODE -ne 0) { throw 'Protected source validation failed.' }
```

The source gate is limited to stages 1–5, no-LLM Static, and the whole test suite. A report PASS, workflow success, review, and merge do not authorize release, installation, publication, or downstream cutover. `releaseEligible` is permanently false; any separate release process must make its own decision.

Rollback must use a normal reviewed PR that reverts the entire adoption, including the `.github/workflows/validate.yml` ff85 activation, `config/standard-v1.json`, the active driver, tests, and docs. Restore the complete previously validated 8a authority tuple: commit `8aabd22694a05771f98639f6d726cc9a620eb94b`, archive SHA-256 `d92df1a8f0aa342970dc9c66a77b6211955b4708de12119cb7f9a360fd265311`, and its full 26-file hash inventory, along with the prior workflow and ordinary validation route. Reverting only the config or driver while leaving the ff85 source workflow active is invalid: that workflow rejects the 8a authority.

## Versioning

Consumers should pin this repository to a full commit SHA or an immutable release tag resolving to that commit. Skill content hashes are deterministic and are emitted by the validation script for use by external catalog locks.

Do not repurpose stable Skill IDs or move a Skill away from `skills/<skill-id>` without coordinating the consuming Catalog lifecycle contract.

## Release, update, rename, removal, and rollback

See [RELEASING.md](RELEASING.md). Rollback is performed by returning the consumer source pin to a previously validated commit or immutable tag; release history must not be rewritten.

## Migration scope

This repository owns the Knowledge & Content Skill source after migration. Cross-repository Catalog/bootstrap cutover is intentionally outside this repository's own baseline and is handled separately.
