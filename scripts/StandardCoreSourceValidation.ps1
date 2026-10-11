# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
#requires -Version 7.0

Set-StrictMode -Version Latest

$script:KnowledgeContentPreparedAuthorityRepository = 'https://github.com/SyuanTsai/SyuanTsai-AI-Instructions.git'
$script:KnowledgeContentPreparedAuthorityCommit = 'ff85d5f80fe795b96354e753074b5ce59ad04ecd'
$script:KnowledgeContentPreparedAuthorityArchiveSha256 = '3dc38613f2e2316ad8fcc79d4bf48d0b03fd8398f8dacc72d156abcbce95ea9d'
$script:KnowledgeContentPreparedAuthorityFiles = [ordered]@{
    'docs/standards/README.md' = '43c1526ac55302f62b706688905be160d9805cc3a6a800189d689e66fa727b71'
    'docs/standards/managed-skill-lifecycle.md' = '70950cf8bdd02819efae6f6e06ac5be1da3e70f809c23e3c6f8d3b217797416c'
    'docs/standards/schemas/managed-skill-lifecycle-v1.schema.json' = '9a7f4c02588d2b88194e953a41766a72a9426fa89d4c3781c5750dcc22d35863'
    'docs/standards/schemas/openai-agent-metadata.schema.json' = '23c1aaee28a54fea1946a61d6122a2097906ffa5bdd66c8014fc6b1625c9062a'
    'docs/standards/schemas/source-inventory-v2.schema.json' = '084550944b4141ab5535f58fb6e99730a5c34b56103f6b59fd5a352679caa98e'
    'docs/standards/schemas/validation-security-gate-v1.schema.json' = 'ac58302e0e350c1ab4ba4dad8a33cd3abce12d592537fbdb23dfb1936d064e91'
    'docs/standards/skill-repository-review-matrix.md' = '299925aabe3cab360827baad9bdeb1f0f56fc320dad967e49fe0b6bf9cdf8f8a'
    'docs/standards/skill-repository-standard.md' = '86a24a75eaf96f9eaa02307937a46d1b2ce788cf63b4657c60bec9815b2ca4b3'
    'docs/standards/upstream-interoperability.md' = '4329e8586e88713027bcd95c7537331e050a89b004f2361223efdc01bf44370e'
    'docs/standards/validation-security-gate.json' = '657122dde340f1f7f4442780cc27ffcb00b60c0d2afdcea22d63fbf7dbfdca7d'
    'docs/standards/validation-toolchain.json' = '1dddbf4c5736e22e56f6ecb298542f41d39e116ab00ca24ad18beb7a3eab40ed'
    'scripts/Invoke-StandardAuthorityGate.ps1' = '8e00ee1e48ef8359ab7be3539f8f7585ccde18b41e26d810843715ebc3656a4c'
    'scripts/Resolve-PythonWheelClosure.py' = 'f9fcd99c408849f98564fbc4c30f3d7e6ad8148b60cb4d8f58fc29b040c4519c'
    'scripts/Resolve-StandardValidationTool.ps1' = '71e6d5b191b74202e96f34a856d3317efb18662e17c8368d112d89b7d6795b15'
    'docs/standards/schemas/standard-validation-adapter-v1.schema.json' = '11aa88fc25716d748bd4f514f1a44f02390ad1745dd5a5c5beee07f642fd5639'
    'docs/standards/schemas/standard-validation-evidence-v1.schema.json' = '8ed4a9d7158273d7a1e9d898acf07f57e9170822cb7cbb70f1e2eec7195867ee'
    'docs/standards/standard-validation-contract-v1.json' = '707edf8945ad9a7097df1dfb22a8f05ce47d0e0a66e2e44381036d630e854da0'
    'docs/standards/pr12-source-merge-adoption.json' = '4c5262f2a11d228195230c15fa4faaf9614af6b59f110e5d9c08f242ce809175'
    'docs/standards/trust-anchors/human-approval-public-key.xml' = '1e46153b72d02f3ce2fb26becd449df4f1590d8e5cb441b1954006a5602bbd9b'
    'docs/standards/trust-anchors/trusted-supervisor-public-key.xml' = '4d550851f43405920156f40c9fc648d99a69dd73efc200f6968d8a837e7fbf27'
    'scripts/Invoke-StandardValidation.ps1' = 'a4ee880810171428a6abd2e8fd5db2da1eaeda4abc0fc6c72dc259b4a709174b'
    'docs/standards/schemas/standard-semantic-consent-evidence-v2.schema.json' = '109091979d0a47e2035d3d8b20963fcdb85680e5da737bf1f27121608115d430'
    'scripts/StandardSemanticBridge.psm1' = 'daf90f703898cc56fc3310e1eec462bafa6552edcac0de4f08a3cd4b9f63a429'
    'docs/standards/schemas/upstream-adapter-v1.schema.json' = '3cff6246463188a91cc54c6a46315a949314767a759c6214e5b28e4db95ac8d7'
    'docs/standards/upstream-adapter.json' = 'c4f5133b24841bb9c66182dc3d5a027596f864ec28e410d47249a67b3b97ad31'
    'scripts/Validate-UpstreamAdapter.ps1' = '3b6e6474690b1ae9f9486544b68f50ca29b96f5dbe6aa8d6c6cd8570afad500b'
    'docs/standards/standard-core-validation-v2.json' = '2ba91aec827a642517fd90d294524e0dfc3fed9ae19c27d867d442d73b4915d6'
    'docs/standards/schemas/standard-core-adapter-v2.schema.json' = '7399980e8765528b759a3734a133447eb9581ac24a9c4780dc8faadd6af0c1c5'
    'docs/standards/schemas/standard-core-evidence-v2.schema.json' = '4a8c61f32484bfe928e4f15f6422de7dc7b63d9d1fc95bca4f8f5c4c37334d24'
    'docs/standards/third-party-raw-skill-sources.md' = '18649fd56eada4a94a5d47de778669b0ebcecfb85b84f5c581d283b21979f7ac'
    'docs/standards/schemas/third-party-raw-skill-source-v1.schema.json' = '9d8585d95c606486f947a3f89e39341af840335376e86910eb7f4ed25bdc16ed'
    'docs/standards/examples/third-party-raw-skill-source-v1.json' = 'decbf276cbeea33c60d8b36b7b16838babe951cd84d13ae4a8a7a8261dc6d9c8'
}

function Assert-KnowledgeContentExactPropertySet {
    param(
        [Parameter(Mandatory = $true)] $Value,
        [Parameter(Mandatory = $true)][string[]] $Expected,
        [Parameter(Mandatory = $true)][string] $Context
    )

    if ($null -eq $Value -or $Value -is [array] -or $Value -is [string] -or $null -eq $Value.PSObject) {
        throw "$Context must be a JSON object."
    }
    $actual = @($Value.PSObject.Properties | ForEach-Object { [string]$_.Name })
    $missing = @($Expected | Where-Object { $actual -cnotcontains $_ })
    $unexpected = @($actual | Where-Object { $Expected -cnotcontains $_ })
    if ($missing.Count -gt 0 -or $unexpected.Count -gt 0 -or $actual.Count -ne $Expected.Count) {
        throw "$Context has an invalid property set. Missing='$($missing -join ',')' Unexpected='$($unexpected -join ',')'."
    }
}

function Get-KnowledgeContentPreparedAuthorityPin {
    [CmdletBinding()]
    param()

    $files = [ordered]@{}
    foreach ($entry in $script:KnowledgeContentPreparedAuthorityFiles.GetEnumerator()) {
        $files[[string]$entry.Key] = [string]$entry.Value
    }
    return [pscustomobject][ordered]@{
        repository = $script:KnowledgeContentPreparedAuthorityRepository
        commit = $script:KnowledgeContentPreparedAuthorityCommit
        archiveUrl = "https://codeload.github.com/SyuanTsai/SyuanTsai-AI-Instructions/zip/$($script:KnowledgeContentPreparedAuthorityCommit)"
        archiveSha256 = $script:KnowledgeContentPreparedAuthorityArchiveSha256
        files = $files
    }
}

function Assert-KnowledgeContentPreparedAuthorityTuple {
    [CmdletBinding()]
    param([Parameter(Mandatory = $true)] $Authority)

    Assert-KnowledgeContentExactPropertySet -Value $Authority `
        -Expected @('repository', 'commit', 'archiveUrl', 'archiveSha256', 'files') `
        -Context 'Prepared source authority'

    $expected = Get-KnowledgeContentPreparedAuthorityPin
    foreach ($field in @('repository', 'commit', 'archiveUrl', 'archiveSha256')) {
        if ($Authority.$field -isnot [string] -or [string]$Authority.$field -cne [string]$expected.$field) {
            throw "Prepared source authority $field does not match the exact approved tuple."
        }
    }
    if ($Authority.files -isnot [array] -or @($Authority.files).Count -ne $expected.files.Count) {
        throw 'Prepared source authority file tuple is incomplete.'
    }

    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $expectedPaths = @($expected.files.Keys)
    for ($index = 0; $index -lt $expectedPaths.Count; $index++) {
        $file = @($Authority.files)[$index]
        Assert-KnowledgeContentExactPropertySet -Value $file -Expected @('path', 'sha256') `
            -Context "Prepared source authority file at index $index"
        if ($file.path -isnot [string] -or $file.sha256 -isnot [string]) {
            throw "Prepared source authority file fields must be strings at index $index."
        }

        $path = [string]$file.path
        if ([string]::IsNullOrWhiteSpace($path) -or $path.StartsWith('/', [StringComparison]::Ordinal) -or
            $path.Contains('\') -or $path.Contains(':') -or
            @($path.Split('/')) -contains '' -or @($path.Split('/')) -contains '.' -or @($path.Split('/')) -contains '..') {
            throw "Prepared source authority contains an unsafe file path at index $index."
        }
        if (-not $seen.Add($path)) { throw "Prepared source authority contains duplicate file path '$path'." }
        if ([string]$file.sha256 -cnotmatch '^[0-9a-f]{64}$') {
            throw "Prepared source authority file SHA-256 is invalid at index $index."
        }
        if ($path -cne [string]$expectedPaths[$index]) {
            throw "Prepared source authority file path or order mismatch at index $index."
        }
        if ([string]$file.sha256 -cne [string]$expected.files[$path]) {
            throw "Prepared source authority file identity mismatch at index $index."
        }
    }
    return $expected
}

function Assert-KnowledgeContentSourceRequest {
    [CmdletBinding()]
    param(
        [switch] $PrepareSourceTools,
        [switch] $SourceValidation,
        [string] $SourceToolsPath,
        [string] $AuthorityRepositoryRoot,
        [string] $TrustedToolRoot,
        $AuthorityArchivePath,
        $CandidateAuthority,
        [System.Collections.IDictionary] $BoundParameters
    )

    if ($PrepareSourceTools -and $SourceValidation) {
        throw 'PrepareSourceTools and SourceValidation are separate setup and execution requests.'
    }
    $hasSourcePurpose = $PrepareSourceTools -or $SourceValidation
    if (-not $hasSourcePurpose) {
        if (-not [string]::IsNullOrWhiteSpace($SourceToolsPath) -or
            -not [string]::IsNullOrWhiteSpace($AuthorityRepositoryRoot) -or
            -not [string]::IsNullOrWhiteSpace($TrustedToolRoot) -or
            ($null -ne $BoundParameters -and
                @($BoundParameters.Keys | Where-Object { $_ -cin @('SourceToolsPath', 'AuthorityRepositoryRoot', 'TrustedToolRoot') }).Count -gt 0)) {
            throw 'Source tools and authority roots are only valid for explicit source setup or validation.'
        }
        return
    }
    if (-not [string]::IsNullOrWhiteSpace($AuthorityArchivePath) -or
        ($null -ne $BoundParameters -and $BoundParameters.Keys -contains 'AuthorityArchivePath')) {
        throw 'Explicit source setup or validation does not accept AuthorityArchivePath.'
    }
    if ([string]::IsNullOrWhiteSpace($SourceToolsPath)) { throw 'Explicit source setup or validation requires SourceToolsPath.' }
    if ([string]::IsNullOrWhiteSpace($AuthorityRepositoryRoot)) { throw 'Explicit source setup or validation requires AuthorityRepositoryRoot.' }
    if ([string]::IsNullOrWhiteSpace($TrustedToolRoot)) { throw 'Explicit source setup or validation requires TrustedToolRoot.' }

    if ($SourceValidation) {
        if ($null -eq $CandidateAuthority) { throw 'SourceValidation requires the exact prepared candidate authority tuple.' }
        [void](Assert-KnowledgeContentPreparedAuthorityTuple -Authority $CandidateAuthority)
    }
}

function Resolve-KnowledgeContentSourceRoute {
    [CmdletBinding()]
    param(
        [switch] $PrepareSourceTools,
        [switch] $SourceValidation,
        [string] $SourceToolsPath,
        [string] $AuthorityRepositoryRoot,
        [string] $TrustedToolRoot,
        [string] $AuthorityArchivePath,
        $CandidateAuthority,
        [System.Collections.IDictionary] $BoundParameters
    )

    Assert-KnowledgeContentSourceRequest -PrepareSourceTools:$PrepareSourceTools -SourceValidation:$SourceValidation -SourceToolsPath $SourceToolsPath -AuthorityRepositoryRoot $AuthorityRepositoryRoot -TrustedToolRoot $TrustedToolRoot -AuthorityArchivePath $AuthorityArchivePath -CandidateAuthority $CandidateAuthority -BoundParameters $BoundParameters

    if ($PrepareSourceTools) {
        return [pscustomobject]@{ mode = 'prepare-source-tools'; authority = Get-KnowledgeContentPreparedAuthorityPin }
    }
    if ($SourceValidation) {
        return [pscustomobject]@{ mode = 'source-validation'; authority = Assert-KnowledgeContentPreparedAuthorityTuple -Authority $CandidateAuthority }
    }
    return [pscustomobject]@{ mode = 'ordinary'; authority = $CandidateAuthority }
}

function Assert-KnowledgeContentPreparedAuthorityCheckout {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $GitPath,
        [Parameter(Mandatory = $true)][string] $AuthorityRoot,
        [Parameter(Mandatory = $true)] $AuthorityPin
    )

    $fullRoot = [IO.Path]::GetFullPath($AuthorityRoot)
    if (-not (Test-Path -LiteralPath $fullRoot -PathType Container)) { throw "Prepared authority Git checkout is missing: $fullRoot" }
    Assert-NoReparseAncestors -Path $fullRoot -Context 'Prepared authority checkout'
    $top = @(& $GitPath -C $fullRoot rev-parse --show-toplevel 2>$null)
    if ($LASTEXITCODE -ne 0 -or $top.Count -ne 1 -or -not (Test-KnowledgeContentPathEqual -Left ([string]$top[0]) -Right $fullRoot)) {
        throw 'Prepared authority path is not the root of a Git checkout.'
    }
    $head = @(& $GitPath -C $fullRoot rev-parse --verify --end-of-options 'HEAD^{commit}' 2>$null)
    if ($LASTEXITCODE -ne 0 -or $head.Count -ne 1 -or ([string]$head[0]).Trim() -cne [string]$AuthorityPin.commit) {
        throw 'Prepared authority checkout HEAD does not match the exact ff85 revision.'
    }
    $origins = @(& $GitPath -C $fullRoot config --local --get-all remote.origin.url 2>$null)
    if ($LASTEXITCODE -ne 0 -or $origins.Count -ne 1) { throw 'Prepared authority checkout must have exactly one origin URL.' }
    $origin = ([string]$origins[0]).Trim().TrimEnd('/') -replace '\.git$', ''
    $expectedOrigin = ([string]$AuthorityPin.repository).Trim().TrimEnd('/') -replace '\.git$', ''
    if (-not $origin.Equals($expectedOrigin, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Prepared authority checkout origin does not match the pinned authority repository.'
    }
    $dirty = @(& $GitPath -C $fullRoot status --porcelain=v1 --untracked-files=all)
    if ($LASTEXITCODE -ne 0 -or $dirty.Count -ne 0) { throw 'Prepared authority checkout must be clean and immutable.' }

    foreach ($entry in $AuthorityPin.files.GetEnumerator()) {
        $filePath = [IO.Path]::GetFullPath((Join-Path $fullRoot ($entry.Key -replace '/', [IO.Path]::DirectorySeparatorChar)))
        if (-not (Test-PathWithinOrEqual -Path $filePath -Root $fullRoot)) { throw "Prepared authority file escaped its checkout: $($entry.Key)" }
        Assert-NoReparseAncestors -Path $filePath -Context 'Prepared authority file'
        if (-not (Test-Path -LiteralPath $filePath -PathType Leaf) -or (Get-FileSha256 -Path $filePath) -cne [string]$entry.Value) {
            throw "Prepared authority file identity mismatch: $($entry.Key)"
        }
        $treeEntry = @(& $GitPath -C $fullRoot ls-tree $head -- ([string]$entry.Key) 2>$null)
        if ($LASTEXITCODE -ne 0 -or $treeEntry.Count -ne 1 -or
            [string]$treeEntry[0] -cnotmatch ('^(?<mode>100644|100755) blob (?<objectId>[0-9a-f]{40})\t' + [regex]::Escape([string]$entry.Key) + '$')) {
            throw "Prepared authority path is not a regular Git blob: $($entry.Key)"
        }
        $expectedBlob = [string]$Matches.objectId
        $actualBlob = @(& $GitPath -C $fullRoot hash-object --no-filters -- ([string]$entry.Key) 2>$null)
        if ($LASTEXITCODE -ne 0 -or $actualBlob.Count -ne 1 -or ([string]$actualBlob[0]).Trim() -cne $expectedBlob) {
            throw "Prepared authority file bytes differ from its immutable Git blob: $($entry.Key)"
        }
    }
    return [pscustomobject]@{ root = $fullRoot; revision = [string]$AuthorityPin.commit; runnerPath = (Join-Path $fullRoot 'scripts/Invoke-StandardValidation.ps1') }
}

function New-KnowledgeContentCoreAuthoritySnapshot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $GitPath,
        [Parameter(Mandatory = $true)][string] $SourceRoot,
        [Parameter(Mandatory = $true)][string] $OwnedRoot,
        [Parameter(Mandatory = $true)] $AuthorityPin
    )

    $ownedFull = [IO.Path]::GetFullPath($OwnedRoot)
    Assert-NoReparseAncestors -Path $ownedFull -Context 'Core Pester adapter root'
    $snapshotRoot = Assert-PathWithinRoot -Path (Join-Path $ownedFull 'authority') -Root $ownedFull -Context 'Core Pester authority snapshot'
    if (Test-Path -LiteralPath $snapshotRoot) { throw 'Core Pester authority snapshot path already exists.' }
    $hooksRoot = Join-Path $ownedFull '.empty-git-hooks'
    [void](New-Item -ItemType Directory -Path $hooksRoot -ErrorAction Stop)
    Assert-NoReparseAncestors -Path $hooksRoot -Context 'Core Pester authority snapshot hooks'

    # Use an isolated, no-hardlink Git clone so the child test process can bind
    # its authority root to the exact prepared revision without sharing files.
    & $GitPath -c "core.hooksPath=$hooksRoot" -c core.autocrlf=false -c core.longpaths=true clone --quiet --local --no-hardlinks --no-checkout -- $SourceRoot $snapshotRoot
    if ($LASTEXITCODE -ne 0) { throw 'Could not materialize the no-hardlink authority Git snapshot for Core Pester.' }
    & $GitPath -C $snapshotRoot config --local core.autocrlf false
    if ($LASTEXITCODE -ne 0) { throw 'Could not disable line-ending conversion in the Core Pester authority snapshot.' }
    & $GitPath -C $snapshotRoot config --local core.longpaths true
    if ($LASTEXITCODE -ne 0) { throw 'Could not enable long paths in the Core Pester authority snapshot.' }
    $snapshotPaths = @($AuthorityPin.files.Keys) + @('docs/standards/standard-core-validation-v2.json')
    $snapshotPaths = @($snapshotPaths | Select-Object -Unique)
    & $GitPath -c "core.hooksPath=$hooksRoot" -C $snapshotRoot sparse-checkout set --no-cone -- $snapshotPaths
    if ($LASTEXITCODE -ne 0) { throw 'Could not select the pinned files in the Core Pester authority snapshot.' }
    & $GitPath -C $snapshotRoot config --local --replace-all remote.origin.url ([string]$AuthorityPin.repository)
    if ($LASTEXITCODE -ne 0) { throw 'Could not bind the Core Pester authority snapshot origin.' }
    & $GitPath -c "core.hooksPath=$hooksRoot" -c core.autocrlf=false -C $snapshotRoot checkout --quiet --detach ([string]$AuthorityPin.commit)
    if ($LASTEXITCODE -ne 0) { throw 'Could not check out the exact prepared authority revision for Core Pester.' }
    return Assert-KnowledgeContentPreparedAuthorityCheckout -GitPath $GitPath -AuthorityRoot $snapshotRoot -AuthorityPin $AuthorityPin
}

function Remove-KnowledgeContentOwnedCoreAdapterRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $OwnedRoot,
        [Parameter(Mandatory = $true)][string] $ArtifactsRoot,
        [Parameter(Mandatory = $true)][string] $RunId,
        [Parameter(Mandatory = $true)][string] $OwnerToken,
        [Parameter(Mandatory = $true)][string] $RepositoryRoot,
        [Parameter(Mandatory = $true)][string] $AuthorityRoot,
        [Parameter(Mandatory = $true)][string] $TrustedToolRoot,
        [Parameter(Mandatory = $true)][string] $CoreArtifactsRoot
    )

    if ($RunId -cnotmatch '^[0-9a-f]{32}$' -or $OwnerToken -cnotmatch '^[0-9a-f]{32}$') { throw 'Core Pester adapter cleanup identity is invalid.' }
    $expectedRoot = [IO.Path]::GetFullPath((Join-Path $ArtifactsRoot ".core-v2-adapter-$RunId"))
    $ownedFull = [IO.Path]::GetFullPath($OwnedRoot)
    if (-not (Test-KnowledgeContentPathEqual -Left $ownedFull -Right $expectedRoot) -or
        -not (Test-KnowledgeContentPathEqual -Left (Split-Path -Parent $ownedFull) -Right $ArtifactsRoot)) {
        throw 'Core Pester adapter cleanup path is not the exact run-owned sibling.'
    }
    if (-not (Test-Path -LiteralPath $ownedFull -PathType Container)) { return }
    Assert-OutsideRoot -Path $ownedFull -Root $RepositoryRoot -Context 'Core Pester adapter cleanup root'
    Assert-OutsideRoot -Path $ownedFull -Root $AuthorityRoot -Context 'Core Pester adapter cleanup root'
    Assert-OutsideRoot -Path $ownedFull -Root $TrustedToolRoot -Context 'Core Pester adapter cleanup root'
    Assert-OutsideRoot -Path $ownedFull -Root $CoreArtifactsRoot -Context 'Core Pester adapter cleanup root'
    Assert-NoReparseAncestors -Path $ownedFull -Context 'Core Pester adapter cleanup root'

    $markerPath = Join-Path $ownedFull '.source-owned.json'
    if (-not (Test-Path -LiteralPath $markerPath -PathType Leaf)) { throw 'Core Pester adapter cleanup ownership marker is missing.' }
    Assert-NoReparseAncestors -Path $markerPath -Context 'Core Pester adapter cleanup marker'
    $marker = Read-JsonFile -Path $markerPath -Context 'Core Pester adapter cleanup marker'
    Assert-KnowledgeContentExactPropertySet -Value $marker -Expected @('owner', 'runId', 'token') -Context 'Core Pester adapter cleanup marker'
    if ([string]$marker.owner -cne 'knowledge-content-source-core-adapter' -or
        [string]$marker.runId -cne $RunId -or [string]$marker.token -cne $OwnerToken) {
        throw 'Core Pester adapter cleanup marker does not match this source run.'
    }
    foreach ($item in @(Get-ChildItem -LiteralPath $ownedFull -Recurse -Force -ErrorAction Stop)) {
        if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw "Core Pester adapter cleanup found a reparse point: $($item.FullName)" }
    }
    Remove-Item -LiteralPath $ownedFull -Recurse -Force -ErrorAction Stop
    if (Test-Path -LiteralPath $ownedFull) { throw 'Core Pester adapter cleanup did not remove its exact run-owned root.' }
}

function Get-KnowledgeContentCorePesterLayout {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $ArtifactsRoot,
        [Parameter(Mandatory = $true)][string] $RunId
    )

    if ($RunId -cnotmatch '^[0-9a-f]{32}$') { throw 'Core Pester layout requires the canonical source setup RunId.' }
    $root = [IO.Path]::GetFullPath($ArtifactsRoot)
    $adapterRoot = [IO.Path]::GetFullPath((Join-Path $root ".core-v2-adapter-$RunId"))
    if (-not (Test-KnowledgeContentPathEqual -Left (Split-Path -Parent $adapterRoot) -Right $root)) {
        throw 'Core Pester adapter layout must be a direct ArtifactsRoot child.'
    }
    return [pscustomobject][ordered]@{
        adapterRoot = $adapterRoot
        adapterPath = [IO.Path]::GetFullPath((Join-Path $adapterRoot 'standard-core-adapter-v2.json'))
        authorityRoot = [IO.Path]::GetFullPath((Join-Path $adapterRoot 'authority'))
        ownerMarkerPath = [IO.Path]::GetFullPath((Join-Path $adapterRoot '.source-owned.json'))
    }
}

function New-KnowledgeContentSourceCoreAdapter {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $PowerShell,
        [Parameter(Mandatory = $true)][string] $RunId,
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][string[]] $ActiveSkillIds,
        [Parameter(Mandatory = $true)] $SourceValidation
    )

    if ($RunId -cnotmatch '^[0-9a-f]{32}$') { throw 'Core source adapter requires the canonical source setup RunId.' }
    $fullPowerShell = [IO.Path]::GetFullPath($PowerShell)
    if (-not (Test-Path -LiteralPath $fullPowerShell -PathType Leaf)) { throw 'Core source adapter PowerShell executable is missing.' }
    if ($ActiveSkillIds.Count -eq 0) { throw 'Core source adapter requires at least one active Skill.' }
    foreach ($skillId in $ActiveSkillIds) {
        if ([string]$skillId -cnotmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$') { throw "Core source adapter contains an invalid Skill ID: '$skillId'." }
    }
    $powerShellSha256 = Get-FileSha256 -Path $fullPowerShell
    return [ordered]@{
        schemaVersion = 2
        adapter = 'standard-core-adapter-v2'
        skillsRoot = 'skills'
        activeSkills = @($ActiveSkillIds)
        checks = @(
            [ordered]@{ id = 'repository-general'; kind = 'general'; executable = $fullPowerShell; executableSha256 = $powerShellSha256; arguments = @('-NoProfile', '-NonInteractive', '-File', 'scripts/Test-Repository.ps1', '-ReadOnlySnapshot') }
            [ordered]@{ id = 'repository-pester'; kind = 'pester'; executable = $fullPowerShell; executableSha256 = $powerShellSha256; arguments = @('-NoProfile', '-NonInteractive', '-File', 'scripts/Invoke-CorePester.ps1', '-CandidateAuthorityAdapterRunId', $RunId) }
        )
        sourceValidation = $SourceValidation
    }
}

function Write-KnowledgeContentUtf8CreateNew {
    param(
        [Parameter(Mandatory = $true)][string] $Path,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string] $Text
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    $parent = Split-Path -Parent $fullPath
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        throw "Create-only source setup parent directory is missing: $parent"
    }
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($Text)
    $stream = [IO.FileStream]::new($fullPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try {
        $stream.Write($bytes, 0, $bytes.Length)
        $stream.Flush($true)
    }
    finally { $stream.Dispose() }
}

function Assert-KnowledgeContentSourceReceiptClosureFrozen {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]] $Bindings,
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]] $FrozenFiles
    )

    if ($Bindings.Count -ne 3) { throw 'Source setup requires exactly three resolver receipts.' }
    $comparison = if ($IsWindows) { [StringComparer]::OrdinalIgnoreCase } else { [StringComparer]::Ordinal }
    $seenFrozen = [Collections.Generic.HashSet[string]]::new($comparison)
    foreach ($file in $FrozenFiles) {
        Assert-KnowledgeContentExactPropertySet -Value $file -Expected @('path', 'sha256') -Context 'Source frozen file'
        if ([string]$file.path -cne [IO.Path]::GetFullPath([string]$file.path) -or
            [string]$file.sha256 -cnotmatch '^[0-9a-f]{64}$' -or -not $seenFrozen.Add([string]$file.path)) {
            throw 'Source frozen files must have unique absolute paths and lowercase SHA-256 identities.'
        }
    }

    $seenTools = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($binding in $Bindings) {
        Assert-KnowledgeContentExactPropertySet -Value $binding -Expected @('path', 'sha256') -Context 'Source tool receipt binding'
        $receiptPath = [IO.Path]::GetFullPath([string]$binding.path)
        if ([string]$binding.sha256 -cnotmatch '^[0-9a-f]{64}$' -or
            (Get-FileHash -LiteralPath $receiptPath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant() -cne [string]$binding.sha256) {
            throw 'Source tool receipt does not match its frozen SHA-256 binding.'
        }
        $receiptFrozen = @($FrozenFiles | Where-Object {
            (Test-KnowledgeContentPathEqual -Left ([string]$_.path) -Right $receiptPath) -and [string]$_.sha256 -ceq [string]$binding.sha256
        })
        if ($receiptFrozen.Count -ne 1) { throw 'Source tool receipt file is not frozen exactly once.' }

        $receiptText = [IO.File]::ReadAllText($receiptPath, [Text.UTF8Encoding]::new($false, $true))
        $receipt = ConvertFrom-Json -InputObject $receiptText -Depth 50 -ErrorAction Stop
        $toolName = [string]$receipt.toolName
        if ($toolName -cnotin @('skill-validator', 'skill-tools', 'skillspector') -or -not $seenTools.Add($toolName)) {
            throw 'Source tool receipts must identify each approved tool exactly once.'
        }
        $pairs = [Collections.Generic.List[object]]::new()
        $pairs.Add(@('executablePath', 'executableSha256'))
        if ($toolName -ceq 'skill-tools') {
            $pairs.Add(@('entryPointPath', 'entryPointSha256'))
            $pairs.Add(@('nodePath', 'nodeSha256'))
        }
        foreach ($pair in $pairs) {
            $pathProperty = $receipt.PSObject.Properties[[string]$pair[0]]
            $hashProperty = $receipt.PSObject.Properties[[string]$pair[1]]
            if ($null -eq $pathProperty -or $null -eq $hashProperty -or
                $pathProperty.Value -isnot [string] -or $hashProperty.Value -isnot [string] -or
                [string]$hashProperty.Value -cnotmatch '^[0-9a-f]{64}$' -or
                -not [IO.Path]::IsPathRooted([string]$pathProperty.Value)) {
                throw "Source $toolName receipt has an invalid $($pair[0]) frozen identity."
            }
            $matches = @($FrozenFiles | Where-Object {
                (Test-KnowledgeContentPathEqual -Left ([string]$_.path) -Right ([string]$pathProperty.Value)) -and
                [string]$_.sha256 -ceq [string]$hashProperty.Value
            })
            if ($matches.Count -ne 1) {
                throw "Source $toolName receipt $($pair[0]) is not frozen exactly once."
            }
        }
    }
}

function New-KnowledgeContentSourceToolSetup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $Root,
        [Parameter(Mandatory = $true)][string] $AuthorityRoot,
        [Parameter(Mandatory = $true)] $AuthorityPin,
        [Parameter(Mandatory = $true)][string] $PowerShell,
        [Parameter(Mandatory = $true)][string] $CandidateRevision,
        [Parameter(Mandatory = $true)][string] $Git,
        [Parameter(Mandatory = $true)][string] $CandidateRoot,
        [Parameter(Mandatory = $true)][string] $PreparedPath,
        [Parameter(Mandatory = $true)][string] $GoVersion,
        [Parameter(Mandatory = $true)][int] $LimitSeconds
    )

    $setupId = [guid]::NewGuid().ToString('N')
    $owned = [IO.Path]::GetFullPath((Join-Path $Root "source-tools-$setupId"))
    if (Test-Path -LiteralPath $owned) { throw 'Source setup root already exists.' }
    [void](New-Item -ItemType Directory -Path $owned -ErrorAction Stop)
    Assert-NoReparseAncestors -Path $owned -Context 'Source setup owned root'

    $runner = Join-Path $AuthorityRoot 'scripts/Invoke-StandardValidation.ps1'
    if (-not (Test-Path -LiteralPath $runner -PathType Leaf)) { throw 'Pinned source authority runner is missing.' }
    . $runner -DefineFunctionsOnly -CandidateRoot $AuthorityRoot -AdapterPath $PreparedPath -ArtifactsRoot $Root -SourceRepository $script:SourceRepository -SourceRevision $CandidateRevision -BaseRevision $CandidateRevision -AuthorityRevision ([string]$AuthorityPin.commit)

    $resolver = Join-Path $AuthorityRoot 'scripts/Resolve-StandardValidationTool.ps1'
    $policy = Join-Path $AuthorityRoot 'docs/standards/validation-toolchain.json'
    $receipts = [ordered]@{}
    $receiptBindings = @()
    foreach ($tool in @('skill-validator', 'skill-tools', 'skillspector')) {
        $receiptPath = Join-Path $owned "receipt-$tool.json"
        $resolverArguments = @('-NoProfile', '-NonInteractive', '-File', $resolver, '-PolicyPath', $policy, '-ToolName', $tool, '-Install', '-InstallRoot', (Join-Path $owned 'installed'), '-ExpectedGoRuntimeVersion', $GoVersion, '-RunId', $setupId, '-OutputPath', $receiptPath)
        $result = Invoke-StandardValidationProcess -Command $PowerShell -Arguments $resolverArguments -WorkingDirectory $owned -Environment @{} -TimeoutSeconds $LimitSeconds -CoreLifecycleOnly
        Write-KnowledgeContentUtf8CreateNew -Path (Join-Path $owned "setup-$tool-process.json") -Text (($result | ConvertTo-Json -Depth 30) + [Environment]::NewLine)
        if ($result.status -cne 'passed' -or $result.exitCode -ne 0 -or -not $result.cleanedUp) {
            throw "Source setup $tool failed: $($result.status), exit=$($result.exitCode), cleanup=$($result.cleanedUp). $($result.stderr)"
        }
        $receipts[$tool] = Read-JsonFile -Path $receiptPath -Context "$tool source receipt"
        $receiptBindings += [pscustomobject]@{ path = $receiptPath; sha256 = Get-FileSha256 -Path $receiptPath }
    }

    $toolchain = [ordered]@{
        centralRunnerPath = [IO.Path]::GetFullPath($runner)
        centralRunnerSha256 = Get-FileSha256 -Path $runner
        upstreamAdapterValidatorPath = [IO.Path]::GetFullPath((Join-Path $AuthorityRoot 'scripts/Validate-UpstreamAdapter.ps1'))
        upstreamAdapterValidatorSha256 = Get-FileSha256 -Path (Join-Path $AuthorityRoot 'scripts/Validate-UpstreamAdapter.ps1')
        upstreamPolicyPath = [IO.Path]::GetFullPath((Join-Path $AuthorityRoot 'docs/standards/upstream-adapter.json'))
        upstreamPolicySha256 = Get-FileSha256 -Path (Join-Path $AuthorityRoot 'docs/standards/upstream-adapter.json')
        skillValidatorPath = [string]$receipts.'skill-validator'.executablePath
        skillValidatorSha256 = [string]$receipts.'skill-validator'.executableSha256
        skillToolsNodePath = [string]$receipts.'skill-tools'.nodePath
        skillToolsNodeSha256 = [string]$receipts.'skill-tools'.nodeSha256
        skillToolsEntryPointPath = [string]$receipts.'skill-tools'.entryPointPath
        skillToolsEntryPointSha256 = [string]$receipts.'skill-tools'.entryPointSha256
        skillSpectorPath = [string]$receipts.skillspector.executablePath
        skillSpectorSha256 = [string]$receipts.skillspector.executableSha256
        skillSpectorReceiptPath = [string]$receiptBindings[2].path
        skillSpectorReceiptSha256 = [string]$receiptBindings[2].sha256
    }
    $toolchainPath = Join-Path $owned 'toolchain.json'
    Write-KnowledgeContentUtf8CreateNew -Path $toolchainPath -Text (($toolchain | ConvertTo-Json -Depth 20) + [Environment]::NewLine)

    $wrapper = Join-Path $owned 'Invoke-KnowledgeContentValidationChild.ps1'
    Write-KnowledgeContentUtf8CreateNew -Path $wrapper -Text $childRunnerText
    $archive = Join-Path $owned 'candidate.zip'
    & $Git -C $CandidateRoot archive --format=zip "--output=$archive" $CandidateRevision
    if ($LASTEXITCODE -ne 0) { throw 'Source setup could not archive the exact candidate.' }
    $arguments = @('-NoProfile', '-NonInteractive', '-File', $wrapper, '-ToolchainPath', $toolchainPath, '-ToolchainSha256', (Get-FileSha256 -Path $toolchainPath), '-SourceRepository', $script:SourceRepository, '-SourceRevision', $CandidateRevision, '-ArchiveSha256', (Get-FileSha256 -Path $archive))
    $frozenPaths = @($PowerShell, $wrapper, $toolchainPath, $runner, $toolchain.upstreamAdapterValidatorPath, $toolchain.upstreamPolicyPath, $toolchain.skillValidatorPath, [string]$receipts.'skill-tools'.executablePath, $toolchain.skillToolsNodePath, $toolchain.skillToolsEntryPointPath, $toolchain.skillSpectorPath) + @($receiptBindings | ForEach-Object { [string]$_.path })
    $frozen = @(foreach ($file in @($frozenPaths | Select-Object -Unique)) {
        [pscustomobject]@{ path = [IO.Path]::GetFullPath($file); sha256 = Get-FileSha256 -Path $file }
    })
    Assert-KnowledgeContentSourceReceiptClosureFrozen -Bindings $receiptBindings -FrozenFiles $frozen
    Assert-StandardCoreFrozenFiles -Files $frozen
    Assert-StandardCoreSourceToolReceipts -Bindings $receiptBindings -FrozenFiles $frozen -RunId $setupId

    $dispatch = [ordered]@{
        packageAdapter = [ordered]@{ command = $PowerShell; arguments = @($arguments + @('-Mode', 'package-adapter')) }
        skillValidator = [ordered]@{ command = $PowerShell; arguments = @($arguments + @('-Mode', 'skill-validator')) }
        skillTools = [ordered]@{ command = $PowerShell; arguments = @($arguments + @('-Mode', 'skill-tools')) }
        staticAnalyzer = [ordered]@{ command = $PowerShell; arguments = @($arguments + @('-Mode', 'static')) }
        frozenFiles = $frozen
        toolReceipts = $receiptBindings
    }
    $prepared = [ordered]@{
        schemaVersion = 1
        preparation = 'knowledge-content-source-tools'
        runId = $setupId
        sourceRevision = $CandidateRevision
        authorityRevision = [string]$AuthorityPin.commit
        ownedRoot = $owned
        sourceValidation = $dispatch
    }
    Write-KnowledgeContentUtf8CreateNew -Path $PreparedPath -Text (($prepared | ConvertTo-Json -Depth 40) + [Environment]::NewLine)
}

function Test-KnowledgeContentPathEqual {
    param(
        [Parameter(Mandatory = $true)][string] $Left,
        [Parameter(Mandatory = $true)][string] $Right
    )

    $comparison = if ($IsWindows) { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
    return [IO.Path]::GetFullPath($Left).Equals([IO.Path]::GetFullPath($Right), $comparison)
}

function Write-KnowledgeContentSourceTimingSidecar {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $Path,
        [Parameter(Mandatory = $true)][string[]] $OutputLines,
        [Parameter(Mandatory = $true)][string] $RunId,
        [Parameter(Mandatory = $true)][string] $SourceRevision,
        [Parameter(Mandatory = $true)][string] $BaseRevision,
        [Parameter(Mandatory = $true)][string] $AuthorityRevision,
        [switch] $RequireCoreEvidence
    )

    $records = [Collections.Generic.List[object]]::new()
    $prefix = '[StandardValidation timing] '
    foreach ($line in $OutputLines) {
        $text = [string]$line
        if (-not $text.StartsWith($prefix, [StringComparison]::Ordinal)) { continue }
        try { $record = ConvertFrom-Json -InputObject $text.Substring($prefix.Length) -Depth 5 -ErrorAction Stop }
        catch { throw 'Source validation emitted a malformed structured timing record.' }
        Assert-KnowledgeContentExactPropertySet -Value $record -Expected @('stage', 'phase', 'state', 'calls', 'files', 'bytes', 'elapsedSeconds') -Context 'Source validation timing record'
        if ([string]$record.stage -cnotmatch '^[A-Za-z0-9][A-Za-z0-9_.-]{0,63}$' -or
            [string]$record.phase -cnotmatch '^[A-Za-z0-9][A-Za-z0-9_.-]{0,63}$' -or
            [string]$record.state -cnotin @('started', 'heartbeat', 'completed', 'failed', 'cancelled')) {
            throw 'Source validation timing record has an invalid stage, phase, or state.'
        }
        $calls = [long]$record.calls
        $files = [long]$record.files
        $bytes = [long]$record.bytes
        $elapsed = [double]$record.elapsedSeconds
        if ($calls -lt 0 -or $files -lt 0 -or $bytes -lt 0 -or [double]::IsNaN($elapsed) -or [double]::IsInfinity($elapsed) -or $elapsed -lt 0) {
            throw 'Source validation timing record has an invalid counter or duration.'
        }
        $records.Add([pscustomobject][ordered]@{
            stage = [string]$record.stage
            phase = [string]$record.phase
            state = [string]$record.state
            calls = $calls
            files = $files
            bytes = $bytes
            elapsedSeconds = $elapsed
        })
    }

    if ($RequireCoreEvidence) {
        foreach ($phase in @('candidate-inventory', 'file-inventory', 'inventory-sort', 'closure-content-hash')) {
            if (@($records | Where-Object { [string]$_.phase -ceq $phase -and [string]$_.state -ceq 'completed' }).Count -eq 0) {
                throw "Successful source validation omitted completed '$phase' timing evidence."
            }
        }
    }

    $sidecar = [ordered]@{
        schemaVersion = 1
        report = 'standard-core-source-timing-v1'
        runId = $RunId
        sourceRevision = $SourceRevision
        baseRevision = $BaseRevision
        authorityRevision = $AuthorityRevision
        records = @($records.ToArray())
    }
    Write-KnowledgeContentUtf8CreateNew -Path $Path -Text (($sidecar | ConvertTo-Json -Depth 10) + [Environment]::NewLine)
    return [IO.Path]::GetFullPath($Path)
}

function Read-KnowledgeContentSourceToolSetup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $Path,
        [Parameter(Mandatory = $true)][string] $SourceRevision,
        [Parameter(Mandatory = $true)][string] $AuthorityRevision,
        [Parameter(Mandatory = $true)][string] $PowerShell,
        [Parameter(Mandatory = $true)][string] $AuthorityRoot
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    $authorityRunner = Join-Path $AuthorityRoot 'scripts/Invoke-StandardValidation.ps1'
    . $authorityRunner -DefineFunctionsOnly -CandidateRoot $AuthorityRoot -AdapterPath $fullPath -ArtifactsRoot (Split-Path -Parent $fullPath) -SourceRepository $script:SourceRepository -SourceRevision $SourceRevision -BaseRevision $SourceRevision -AuthorityRevision $AuthorityRevision
    Assert-NoReparseAncestors -Path $fullPath -Context 'Prepared source setup'
    $prepared = Read-JsonFile -Path $fullPath -Context 'Prepared source setup'
    Assert-KnowledgeContentExactPropertySet -Value $prepared -Expected @('schemaVersion', 'preparation', 'runId', 'sourceRevision', 'authorityRevision', 'ownedRoot', 'sourceValidation') -Context 'Prepared source setup'
    if ([int]$prepared.schemaVersion -ne 1 -or
        [string]$prepared.preparation -cne 'knowledge-content-source-tools' -or
        [string]$prepared.runId -cnotmatch '^[0-9a-f]{32}$' -or
        [string]$prepared.sourceRevision -cne $SourceRevision -or
        [string]$prepared.authorityRevision -cne $AuthorityRevision) {
        throw 'Prepared source tools do not bind this candidate and authority.'
    }
    Assert-KnowledgeContentExactPropertySet -Value $prepared.sourceValidation -Expected @('packageAdapter', 'skillValidator', 'skillTools', 'staticAnalyzer', 'frozenFiles', 'toolReceipts') -Context 'Prepared source dispatch'
    foreach ($slot in @('packageAdapter', 'skillValidator', 'skillTools', 'staticAnalyzer')) {
        Assert-KnowledgeContentExactPropertySet -Value $prepared.sourceValidation.$slot -Expected @('command', 'arguments') -Context "Prepared source dispatch $slot"
        if ([string]$prepared.sourceValidation.$slot.command -cne $PowerShell) {
            throw "Prepared source dispatch $slot does not use the verified PowerShell runtime."
        }
    }
    $expectedOwned = Join-Path (Split-Path -Parent $fullPath) "source-tools-$($prepared.runId)"
    if (-not (Test-KnowledgeContentPathEqual -Left ([string]$prepared.ownedRoot) -Right $expectedOwned)) {
        throw 'Prepared source setup owned root differs.'
    }
    Assert-NoReparseAncestors -Path $expectedOwned -Context 'Prepared source setup owned root'
    $wrapper = Join-Path $expectedOwned 'Invoke-KnowledgeContentValidationChild.ps1'
    $wrapperHash = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($childRunnerText))).ToLowerInvariant()
    if ((Get-FileSha256 -Path $wrapper) -cne $wrapperHash) { throw 'Prepared source wrapper differs from the protected driver.' }
    $toolchain = Join-Path $expectedOwned 'toolchain.json'
    Assert-StandardCoreFrozenFiles -Files @($prepared.sourceValidation.frozenFiles)
    Assert-StandardCoreSourceToolReceipts -Bindings @($prepared.sourceValidation.toolReceipts) -FrozenFiles @($prepared.sourceValidation.frozenFiles) -RunId ([string]$prepared.runId)

    $receipts = @{}
    foreach ($receiptBinding in @($prepared.sourceValidation.toolReceipts)) {
        $receipt = Read-JsonFile -Path ([string]$receiptBinding.path) -Context 'Prepared source resolver receipt'
        $receipts[[string]$receipt.toolName] = $receipt
    }
    $preparedToolchain = Read-JsonFile -Path $toolchain -Context 'Prepared source toolchain'
    Assert-KnowledgeContentExactPropertySet -Value $preparedToolchain -Expected @('centralRunnerPath', 'centralRunnerSha256', 'upstreamAdapterValidatorPath', 'upstreamAdapterValidatorSha256', 'upstreamPolicyPath', 'upstreamPolicySha256', 'skillValidatorPath', 'skillValidatorSha256', 'skillToolsNodePath', 'skillToolsNodeSha256', 'skillToolsEntryPointPath', 'skillToolsEntryPointSha256', 'skillSpectorPath', 'skillSpectorSha256', 'skillSpectorReceiptPath', 'skillSpectorReceiptSha256') -Context 'Prepared source toolchain'
    foreach ($authorityBinding in @(
        @('centralRunnerPath', 'centralRunnerSha256', 'scripts/Invoke-StandardValidation.ps1'),
        @('upstreamAdapterValidatorPath', 'upstreamAdapterValidatorSha256', 'scripts/Validate-UpstreamAdapter.ps1'),
        @('upstreamPolicyPath', 'upstreamPolicySha256', 'docs/standards/upstream-adapter.json')
    )) {
        $expectedAuthorityFile = [IO.Path]::GetFullPath((Join-Path $AuthorityRoot $authorityBinding[2]))
        if (-not (Test-KnowledgeContentPathEqual -Left ([string]$preparedToolchain.($authorityBinding[0])) -Right $expectedAuthorityFile) -or
            [string]$preparedToolchain.($authorityBinding[1]) -cne (Get-FileSha256 -Path $expectedAuthorityFile)) {
            throw 'Prepared source toolchain differs from the verified authority files.'
        }
    }
    foreach ($binding in @(
        @{ actualPath = $preparedToolchain.skillValidatorPath; actualSha = $preparedToolchain.skillValidatorSha256; expectedPath = $receipts.'skill-validator'.executablePath; expectedSha = $receipts.'skill-validator'.executableSha256; name = 'skill-validator' },
        @{ actualPath = $preparedToolchain.skillToolsNodePath; actualSha = $preparedToolchain.skillToolsNodeSha256; expectedPath = $receipts.'skill-tools'.nodePath; expectedSha = $receipts.'skill-tools'.nodeSha256; name = 'skill-tools Node' },
        @{ actualPath = $preparedToolchain.skillToolsEntryPointPath; actualSha = $preparedToolchain.skillToolsEntryPointSha256; expectedPath = $receipts.'skill-tools'.entryPointPath; expectedSha = $receipts.'skill-tools'.entryPointSha256; name = 'skill-tools entry point' },
        @{ actualPath = $preparedToolchain.skillSpectorPath; actualSha = $preparedToolchain.skillSpectorSha256; expectedPath = $receipts.skillspector.executablePath; expectedSha = $receipts.skillspector.executableSha256; name = 'skillspector' }
    )) {
        if ([string]$binding.actualPath -cne [string]$binding.expectedPath -or [string]$binding.actualSha -cne [string]$binding.expectedSha) {
            throw "Prepared source toolchain does not match the $($binding.name) resolver receipt."
        }
    }
    $staticReceipt = @($prepared.sourceValidation.toolReceipts | Where-Object { [string]$_.path -ceq [string]$preparedToolchain.skillSpectorReceiptPath })
    if ($staticReceipt.Count -ne 1 -or
        [string]$staticReceipt[0].sha256 -cne [string]$preparedToolchain.skillSpectorReceiptSha256 -or
        (Read-JsonFile -Path ([string]$staticReceipt[0].path) -Context 'Prepared Static receipt').toolName -cne 'skillspector') {
        throw 'Prepared source Static receipt differs.'
    }

    $archive = Join-Path $expectedOwned 'candidate.zip'
    $arguments = @('-NoProfile', '-NonInteractive', '-File', $wrapper, '-ToolchainPath', $toolchain, '-ToolchainSha256', (Get-FileSha256 -Path $toolchain), '-SourceRepository', $script:SourceRepository, '-SourceRevision', $SourceRevision, '-ArchiveSha256', (Get-FileSha256 -Path $archive))
    foreach ($entry in @(
        @('packageAdapter', 'package-adapter'),
        @('skillValidator', 'skill-validator'),
        @('skillTools', 'skill-tools'),
        @('staticAnalyzer', 'static')
    )) {
        $command = $prepared.sourceValidation.($entry[0])
        $expectedArguments = @($arguments + @('-Mode', $entry[1]))
        if ((ConvertTo-Json -InputObject @($command.arguments) -Compress) -cne (ConvertTo-Json -InputObject $expectedArguments -Compress)) {
            throw 'Prepared source dispatch differs from the protected driver.'
        }
    }
    return $prepared
}

function Invoke-KnowledgeContentSourcePurpose {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][ValidateSet('prepare-source-tools', 'source-validation')][string] $Mode,
        [Parameter(Mandatory = $true)][string] $RepositoryRoot,
        [Parameter(Mandatory = $true)][string] $ArtifactsRoot,
        [Parameter(Mandatory = $true)][string] $SourceToolsPath,
        [Parameter(Mandatory = $true)][string] $AuthorityRepositoryRoot,
        [Parameter(Mandatory = $true)][string] $TrustedToolRoot,
        [Parameter(Mandatory = $true)] $AuthorityPin,
        $CandidateAuthority,
        [string] $BaseCommit,
        [string] $ExpectedGoRuntimeVersion,
        [string] $OutputPath,
        [int] $TimeoutSeconds = 900
    )

    $repoRoot = [IO.Path]::GetFullPath($RepositoryRoot)
    if (-not (Test-Path -LiteralPath $repoRoot -PathType Container)) { throw "RepositoryRoot does not exist: $repoRoot" }
    $gitPath = Get-ResolvedGitPath
    $pwshPath = Get-ResolvedPowerShellPath
    $candidateCommit = Resolve-GitRevision -GitPath $gitPath -Root $repoRoot -Revision 'HEAD' -Context 'Candidate revision'
    $dirty = @(& $gitPath -C $repoRoot status --porcelain=v1 --untracked-files=all)
    if ($LASTEXITCODE -ne 0 -or $dirty.Count -ne 0) { throw 'Explicit source purposes require a clean immutable candidate commit.' }

    if ($Mode -ceq 'source-validation') {
        [void](Assert-KnowledgeContentPreparedAuthorityTuple -Authority $CandidateAuthority)
        if ([string]$CandidateAuthority.commit -cne [string]$AuthorityPin.commit) { throw 'Source validation candidate authority differs from the prepared ff85 authority.' }
        if ([string]::IsNullOrWhiteSpace($BaseCommit)) { $BaseCommit = 'HEAD^' }
        $baseRevision = Resolve-GitRevision -GitPath $gitPath -Root $repoRoot -Revision $BaseCommit -Context 'Base commit'
        & $gitPath -C $repoRoot merge-base --is-ancestor $baseRevision $candidateCommit
        if ($LASTEXITCODE -ne 0 -or $baseRevision -ceq $candidateCommit) { throw 'Base commit must be a distinct ancestor of the immutable source candidate.' }
    }

    $authorityCheckout = Assert-KnowledgeContentPreparedAuthorityCheckout -GitPath $gitPath -AuthorityRoot $AuthorityRepositoryRoot -AuthorityPin $AuthorityPin
    $trustedRoot = [IO.Path]::GetFullPath($TrustedToolRoot)
    if (-not (Test-Path -LiteralPath $trustedRoot -PathType Container)) { throw "Trusted PowerShell root is missing: $trustedRoot" }
    Assert-NoReparseAncestors -Path $trustedRoot -Context 'Trusted PowerShell root'
    $comparison = if ($IsWindows) { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
    if (-not (Test-KnowledgeContentPathEqual -Left $pwshPath -Right $trustedRoot) -and
        -not $pwshPath.StartsWith($trustedRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar, $comparison)) {
        throw 'Trusted PowerShell executable must be within TrustedToolRoot.'
    }

    $artifactsRootFull = [IO.Path]::GetFullPath($ArtifactsRoot)
    Assert-OutsideRoot -Path $artifactsRootFull -Root $repoRoot -Context 'Source artifacts root'
    Assert-OutsideRoot -Path $artifactsRootFull -Root $authorityCheckout.root -Context 'Source artifacts root'
    Assert-OutsideRoot -Path $artifactsRootFull -Root $trustedRoot -Context 'Source artifacts root'
    [void](New-Item -ItemType Directory -Path $artifactsRootFull -Force)
    Assert-NoReparseAncestors -Path $artifactsRootFull -Context 'Source artifacts root'

    if ($Mode -ceq 'prepare-source-tools') {
        $preparedPath = Assert-PathWithinRoot -Path $SourceToolsPath -Root $artifactsRootFull -Context 'Source tools output'
        if (-not (Test-KnowledgeContentPathEqual -Left (Split-Path -Parent $preparedPath) -Right $artifactsRootFull)) {
            throw 'Source tools output must be directly within ArtifactsRoot.'
        }
        if (Test-Path -LiteralPath $preparedPath) { throw 'Source tools output already exists.' }
        $goVersion = Resolve-GoRuntimeVersion -Expected $ExpectedGoRuntimeVersion
        New-KnowledgeContentSourceToolSetup -Root $artifactsRootFull -AuthorityRoot $authorityCheckout.root -AuthorityPin $AuthorityPin `
            -PowerShell $pwshPath -CandidateRevision $candidateCommit -Git $gitPath -CandidateRoot $repoRoot `
            -PreparedPath $preparedPath -GoVersion $goVersion -LimitSeconds $TimeoutSeconds
        return 0
    }

    $preparedPath = [IO.Path]::GetFullPath($SourceToolsPath)
    Assert-OutsideRoot -Path $preparedPath -Root $repoRoot -Context 'Source tools input'
    Assert-OutsideRoot -Path $preparedPath -Root $authorityCheckout.root -Context 'Source tools input'
    Assert-OutsideRoot -Path $preparedPath -Root $trustedRoot -Context 'Source tools input'
    $prepared = Read-KnowledgeContentSourceToolSetup -Path $preparedPath -SourceRevision $candidateCommit -AuthorityRevision ([string]$AuthorityPin.commit) -PowerShell $pwshPath -AuthorityRoot $authorityCheckout.root
    $eventName = Get-EventName
    $activeSkills = @(Get-ActiveSkillIds -Root $repoRoot)
    $runId = [string]$prepared.runId
    $coreArtifactsRoot = Join-Path $artifactsRootFull "source-validation-$runId"
    $adapterLayout = Get-KnowledgeContentCorePesterLayout -ArtifactsRoot $artifactsRootFull -RunId $runId
    $adapterRoot = [string]$adapterLayout.adapterRoot
    if ((Test-Path -LiteralPath $coreArtifactsRoot) -or (Test-Path -LiteralPath $adapterRoot)) { throw 'Source validation run-owned path unexpectedly exists.' }
    [void](New-Item -ItemType Directory -Path $coreArtifactsRoot -ErrorAction Stop)
    Assert-NoReparseAncestors -Path $coreArtifactsRoot -Context 'Source validation artifacts root'
    $outputFull = if ([string]::IsNullOrWhiteSpace($OutputPath)) {
        Join-Path $coreArtifactsRoot 'knowledge-content-source-validation.json'
    }
    else { Assert-PathWithinRoot -Path $OutputPath -Root $coreArtifactsRoot -Context 'Source validation OutputPath' }
    if (Test-Path -LiteralPath $outputFull) { throw 'Source validation output path is not create-only.' }
    $adapterRoot = Assert-PathWithinRoot -Path $adapterRoot -Root $artifactsRootFull -Context 'Core Pester adapter root'
    $adapterOwned = $false
    $adapterOwnerToken = [guid]::NewGuid().ToString('N')
    try {
        [void](New-Item -ItemType Directory -Path $adapterRoot -ErrorAction Stop)
        $adapterOwned = $true
        Assert-NoReparseAncestors -Path $adapterRoot -Context 'Core Pester adapter root'
        Assert-OutsideRoot -Path $adapterRoot -Root $repoRoot -Context 'Core Pester adapter root'
        Assert-OutsideRoot -Path $adapterRoot -Root $authorityCheckout.root -Context 'Core Pester adapter root'
        Assert-OutsideRoot -Path $adapterRoot -Root $trustedRoot -Context 'Core Pester adapter root'
        Assert-OutsideRoot -Path $adapterRoot -Root $coreArtifactsRoot -Context 'Core Pester adapter root'
        $ownerMarker = [ordered]@{ owner = 'knowledge-content-source-core-adapter'; runId = $runId; token = $adapterOwnerToken }
        Write-KnowledgeContentUtf8CreateNew -Path ([string]$adapterLayout.ownerMarkerPath) -Text (($ownerMarker | ConvertTo-Json -Compress) + [Environment]::NewLine)

        $adapterPath = [string]$adapterLayout.adapterPath
        $adapter = New-KnowledgeContentSourceCoreAdapter -PowerShell $pwshPath -RunId $runId -ActiveSkillIds $activeSkills -SourceValidation $prepared.sourceValidation
        Write-KnowledgeContentUtf8CreateNew -Path $adapterPath -Text (($adapter | ConvertTo-Json -Depth 30) + [Environment]::NewLine)
        $authoritySnapshot = New-KnowledgeContentCoreAuthoritySnapshot -GitPath $gitPath -SourceRoot $authorityCheckout.root -OwnedRoot $adapterRoot -AuthorityPin $AuthorityPin

        $centralRunnerPath = [string]$authoritySnapshot.runnerPath
        . $centralRunnerPath -DefineFunctionsOnly -CandidateRoot $repoRoot -AdapterPath $adapterPath -ArtifactsRoot $coreArtifactsRoot `
            -SourceRepository $script:SourceRepository -SourceRevision $candidateCommit -BaseRevision $baseRevision `
            -AuthorityRevision ([string]$AuthorityPin.commit)
        $arguments = @(
            '-CandidateRoot', $repoRoot,
            '-AdapterPath', $adapterPath,
            '-ArtifactsRoot', $coreArtifactsRoot,
            '-OutputPath', $outputFull,
            '-SourceRepository', $script:SourceRepository,
            '-SourceRevision', $candidateCommit,
            '-BaseRevision', $baseRevision,
            '-EventName', $eventName,
            '-AuthorityRevision', [string]$AuthorityPin.commit,
            '-TimeoutSeconds', [string]$TimeoutSeconds,
            '-TrustedToolRoot', $trustedRoot,
            '-SourceValidation',
            '-RunId', $runId
        )
        $centralOutput = @(& $pwshPath -NoProfile -NonInteractive -File $centralRunnerPath @arguments 2>&1)
        $centralExitCode = $LASTEXITCODE
        $centralOutput | Out-Host
        $timingSidecarPath = Join-Path $artifactsRootFull "source-validation-timing-$runId.json"
        [void](Write-KnowledgeContentSourceTimingSidecar -Path $timingSidecarPath -OutputLines @($centralOutput | ForEach-Object { [string]$_ }) `
            -RunId $runId -SourceRevision $candidateCommit -BaseRevision $baseRevision -AuthorityRevision ([string]$AuthorityPin.commit) `
            -RequireCoreEvidence:($centralExitCode -eq 0))
        Write-Host "Source validation timing sidecar: $timingSidecarPath"
        if ($centralExitCode -ne 0) { return [int]$centralExitCode }
        if (-not (Test-Path -LiteralPath $outputFull -PathType Leaf)) { throw 'Source validation did not write its canonical report.' }
        $reportHashBeforeProjection = Get-FileSha256 -Path $outputFull
        $report = Read-JsonFile -Path $outputFull -Context 'Source validation report projection'
        [void](Assert-StandardCoreSourceCheckReport -Report $report -ExpectedSourceRevision $candidateCommit -ExpectedBaseRevision $baseRevision `
            -ExpectedAuthorityRevision ([string]$AuthorityPin.commit) -ExpectedEventName $eventName -ArtifactsRoot $coreArtifactsRoot `
            -OutputPath $outputFull -ProcessExitCode $centralExitCode)
        if ((Get-FileSha256 -Path $outputFull) -cne $reportHashBeforeProjection) { throw 'Source validation report bytes changed during final projection.' }
        return 0
    }
    finally {
        if ($adapterOwned) {
            Remove-KnowledgeContentOwnedCoreAdapterRoot -OwnedRoot $adapterRoot -ArtifactsRoot $artifactsRootFull -RunId $runId `
                -OwnerToken $adapterOwnerToken -RepositoryRoot $repoRoot -AuthorityRoot $authorityCheckout.root `
                -TrustedToolRoot $trustedRoot -CoreArtifactsRoot $coreArtifactsRoot
        }
    }
}
