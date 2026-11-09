# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0

BeforeAll {
    $script:repositoryRoot = Split-Path -Parent $PSScriptRoot
    $script:sourceDriverPath = Join-Path $script:repositoryRoot 'scripts/StandardCoreSourceValidation.ps1'
    $script:verifiedPowerShellExecutable = [IO.Path]::GetFullPath([Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
    Import-Module -Name (Join-Path $script:repositoryRoot 'scripts/CorePesterIntegrity.psm1') -Force -ErrorAction Stop
    function Get-FileSha256 {
        param([Parameter(Mandatory = $true)][string] $Path)
        return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
    }
    . $script:sourceDriverPath
    $script:SourceRepository = 'https://github.com/SyuanTsai/SyuanTsai-AI-Instructions.git'
    $script:fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) 'knowledge-content-source-fixture'
    $script:fixtureSourceToolsPath = Join-Path $script:fixtureRoot 'source-tools.json'
    $script:fixtureAuthorityRoot = Join-Path $script:fixtureRoot 'authority'
    $script:fixtureRuntimeRoot = Join-Path $script:fixtureRoot 'runtime'
    $script:fixtureLegacyArchivePath = Join-Path $script:fixtureRoot 'legacy-authority.zip'

    function Assert-TestThrowsLike {
        param([scriptblock] $ScriptBlock, [string] $Pattern)
        $caught = $null
        try { & $ScriptBlock } catch { $caught = $_ }
        $caught | Should -Not -BeNullOrEmpty
        ([string]$caught.Exception.Message) | Should -BeLike $Pattern
    }

    function New-PreparedAuthorityCandidate {
        param([string] $Commit = 'ead467c3488c103546f316d137196b447a1ff58a')

        $pin = Get-KnowledgeContentPreparedAuthorityPin -Commit $Commit
        $files = @(
            foreach ($path in $pin.files.Keys) {
                [pscustomobject]@{ path = [string]$path; sha256 = [string]$pin.files[$path] }
            }
        )
        return [pscustomobject]@{
            repository = [string]$pin.repository
            commit = [string]$pin.commit
            archiveUrl = [string]$pin.archiveUrl
            archiveSha256 = [string]$pin.archiveSha256
            files = $files
        }
    }

    function New-ScopedAuthorityCandidate {
        $authority = New-PreparedAuthorityCandidate
        $authority.commit = 'ead467c3488c103546f316d137196b447a1ff58a'
        $authority.archiveUrl = 'https://codeload.github.com/SyuanTsai/SyuanTsai-AI-Instructions/zip/ead467c3488c103546f316d137196b447a1ff58a'
        $authority.archiveSha256 = 'ab304bc6caabe4bb9b605f403c852650e19e25f72999010db61bbad695e1c60b'
        return $authority
    }

    function New-ApprovedSourceAuthorityCandidate {
        return New-PreparedAuthorityCandidate -Commit 'ead467c3488c103546f316d137196b447a1ff58a'
    }

    function Assert-NoReparseAncestors {
        param([Parameter(Mandatory = $true)][string] $Path, [Parameter(Mandatory = $true)][string] $Context)

        $current = [IO.Path]::GetFullPath($Path)
        while (-not [string]::IsNullOrWhiteSpace($current)) {
            if (Test-Path -LiteralPath $current) {
                $item = Get-Item -LiteralPath $current -Force -ErrorAction Stop
                if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw "$Context contains a reparse point: $current" }
            }
            $parent = Split-Path -Parent $current
            if ([string]::IsNullOrWhiteSpace($parent) -or $parent -ceq $current) { break }
            $current = $parent
        }
    }

    function Assert-OutsideRoot {
        param([Parameter(Mandatory = $true)][string] $Path, [Parameter(Mandatory = $true)][string] $Root, [Parameter(Mandatory = $true)][string] $Context)

        $fullPath = [IO.Path]::GetFullPath($Path)
        $fullRoot = [IO.Path]::GetFullPath($Root)
        $comparison = if ($IsWindows) { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
        $prefix = $fullRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
        if ($fullPath.Equals($fullRoot, $comparison) -or $fullPath.StartsWith($prefix, $comparison)) { throw "$Context is inside a protected root." }
    }

    function Assert-PathWithinRoot {
        param([Parameter(Mandatory = $true)][string] $Path, [Parameter(Mandatory = $true)][string] $Root, [Parameter(Mandatory = $true)][string] $Context)

        $fullPath = [IO.Path]::GetFullPath($Path)
        $fullRoot = [IO.Path]::GetFullPath($Root)
        $comparison = if ($IsWindows) { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
        $prefix = $fullRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
        if (-not $fullPath.Equals($fullRoot, $comparison) -and -not $fullPath.StartsWith($prefix, $comparison)) { throw "$Context escaped its root." }
        return $fullPath
    }

    function Get-ResolvedGitPath {
        $git = Get-Command git -CommandType Application -ErrorAction Stop | Select-Object -First 1
        return [IO.Path]::GetFullPath($git.Source)
    }

    function Get-ResolvedPowerShellPath {
        return [IO.Path]::GetFullPath([Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
    }

    function Resolve-GitRevision {
        param([Parameter(Mandatory = $true)][string] $GitPath, [Parameter(Mandatory = $true)][string] $Root,
            [Parameter(Mandatory = $true)][string] $Revision, [Parameter(Mandatory = $true)][string] $Context)

        $resolved = @(& $GitPath -C $Root rev-parse --verify --end-of-options "$Revision^{commit}" 2>&1)
        if ($LASTEXITCODE -ne 0 -or $resolved.Count -ne 1 -or [string]$resolved[0] -cnotmatch '^[0-9a-f]{40}$') { throw "$Context did not resolve to one commit." }
        return ([string]$resolved[0]).Trim()
    }

    function Get-EventName { return 'pull_request' }
    function Get-ActiveSkillIds { param([string] $Root); return @('source-validation-preparation-fixture') }

    function New-SourceValidationImportProbeRunner {
        param([Parameter(Mandatory = $true)][string] $AuthorityRoot)

        $runnerDirectory = Join-Path $AuthorityRoot 'scripts'
        [void](New-Item -ItemType Directory -Path $runnerDirectory -Force)
        $runnerPath = Join-Path $runnerDirectory 'Invoke-StandardValidation.ps1'
        $runnerText = @'
[CmdletBinding()]
param(
    [switch] $DefineFunctionsOnly,
    [string] $CandidateRoot,
    [string] $AdapterPath,
    [string] $ArtifactsRoot,
    [string] $SourceRepository,
    [string] $SourceRevision,
    [string] $BaseRevision,
    [string] $EventName = 'local',
    [string] $AuthorityRevision,
    [int] $TimeoutSeconds = 300,
    [string] $RunId = ''
)
$sourceCheckout = Get-Variable -Name SourceCheckoutRoot -Scope 0 -ValueOnly -ErrorAction SilentlyContinue
$candidate = Get-Variable -Name CandidateRoot -Scope 0 -ValueOnly -ErrorAction SilentlyContinue
$probe = [ordered]@{
    candidateRoot = if ($null -eq $candidate) { $null } else { [string]$candidate }
    sourceCheckoutRoot = if ($null -eq $sourceCheckout) { $null } else { [string]$sourceCheckout }
    runId = [string]$RunId
    eventName = [string]$EventName
    timeoutSeconds = [int]$TimeoutSeconds
}
[IO.File]::WriteAllText($env:KCC_SOURCE_IMPORT_PROBE_PATH, ($probe | ConvertTo-Json -Compress), [Text.UTF8Encoding]::new($false))
throw 'source-import-probe-stop'
'@
        [IO.File]::WriteAllText($runnerPath, $runnerText, [Text.UTF8Encoding]::new($false))
        return $runnerPath
    }

    function New-SourceValidationTestCandidate {
        param([Parameter(Mandatory = $true)][string] $Path)

        [void](New-Item -ItemType Directory -Path $Path -Force)
        $git = Get-ResolvedGitPath
        & $git -C $Path init --quiet
        if ($LASTEXITCODE -ne 0) { throw 'Could not initialize source-validation fixture repository.' }
        & $git -C $Path config --local maintenance.auto false
        if ($LASTEXITCODE -ne 0) { throw 'Could not disable maintenance.auto in the source-validation fixture.' }
        & $git -C $Path config --local maintenance.autoDetach false
        if ($LASTEXITCODE -ne 0) { throw 'Could not disable maintenance.autoDetach in the source-validation fixture.' }
        & $git -C $Path config --local gc.auto 0
        if ($LASTEXITCODE -ne 0) { throw 'Could not disable gc.auto in the source-validation fixture.' }
        & $git -C $Path config --local gc.autoDetach false
        if ($LASTEXITCODE -ne 0) { throw 'Could not disable gc.autoDetach in the source-validation fixture.' }
        ([string](& $git -C $Path config --local --get maintenance.auto)).Trim() | Should -BeExactly 'false'
        ([string](& $git -C $Path config --local --get gc.auto)).Trim() | Should -BeExactly '0'
        & $git -C $Path config --local core.autocrlf false
        & $git -C $Path config --local user.name 'Source Validation Test'
        & $git -C $Path config --local user.email 'source-validation-test@example.invalid'
        & $git -C $Path config --local commit.gpgsign false
        [IO.File]::WriteAllText((Join-Path $Path 'README.md'), "base`n", [Text.UTF8Encoding]::new($false))
        & $git -C $Path add --all
        & $git -C $Path commit --quiet -m 'base'
        if ($LASTEXITCODE -ne 0) { throw 'Could not create source-validation fixture base commit.' }
        $base = Resolve-GitRevision -GitPath $git -Root $Path -Revision 'HEAD' -Context 'Fixture base revision'
        [IO.File]::WriteAllText((Join-Path $Path 'README.md'), "candidate`n", [Text.UTF8Encoding]::new($false))
        & $git -C $Path add --all
        & $git -C $Path commit --quiet -m 'candidate'
        if ($LASTEXITCODE -ne 0) { throw 'Could not create source-validation fixture candidate commit.' }
        $head = Resolve-GitRevision -GitPath $git -Root $Path -Revision 'HEAD' -Context 'Fixture candidate revision'
        return [pscustomobject]@{ root = [IO.Path]::GetFullPath($Path); git = $git; base = $base; head = $head }
    }

    function Invoke-KnowledgeContentSourceRouteWithActualParameters {
        [CmdletBinding()]
        param(
            [switch] $PrepareSourceTools,
            [switch] $SourceValidation,
            [string] $SourceToolsPath,
            [string] $AuthorityRepositoryRoot,
            [string] $TrustedToolRoot,
            [AllowNull()][AllowEmptyString()][string] $AuthorityArchivePath,
            $CandidateAuthority
        )

        return Resolve-KnowledgeContentSourceRoute @PSBoundParameters -BoundParameters $PSBoundParameters
    }

    function New-SourceTestDirectoryReparsePoint {
        param([Parameter(Mandatory = $true)][string] $Path, [Parameter(Mandatory = $true)][string] $Target)

        if ($IsWindows) {
            New-Item -ItemType Junction -Path $Path -Target $Target -ErrorAction Stop | Out-Null
        }
        else {
            New-Item -ItemType SymbolicLink -Path $Path -Target $Target -ErrorAction Stop | Out-Null
        }
    }

    function Invoke-CorePesterAuthorityDependency {
        param(
            [Parameter(Mandatory = $true)][string] $CandidateRoot,
            [Parameter(Mandatory = $true)][string] $CoreRunId,
            [Parameter(Mandatory = $true)][string] $OuterRunId,
            [string] $CheckId = 'repository-pester'
        )

        $names = @('STANDARD_VALIDATION_CORE_RUN_ID', 'STANDARD_VALIDATION_CORE_CHECK_ID')
        $prior = @{}
        foreach ($name in $names) { $prior[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }
        $previousLocation = Get-Location
        try {
            [Environment]::SetEnvironmentVariable('STANDARD_VALIDATION_CORE_RUN_ID', $CoreRunId, 'Process')
            [Environment]::SetEnvironmentVariable('STANDARD_VALIDATION_CORE_CHECK_ID', $CheckId, 'Process')
            Set-Location -LiteralPath $CandidateRoot
            return Get-VerifiedCoreAuthoritySnapshotPath -OuterAdapterRunId $OuterRunId
        }
        finally {
            Set-Location -LiteralPath $previousLocation
            foreach ($name in $names) { [Environment]::SetEnvironmentVariable($name, $prior[$name], 'Process') }
        }
    }
}

Describe 'Knowledge Content protected source driver preparation' {
    # Scenario: the active public config selects the reviewed ead467c authority through the prepared reader.
    # Purpose: bind the active Standard v1 pin to the complete 51-file prepared source authority.
    It 'UnitT00_returns_the_complete_active_51_file_scoped_pin' {
        $config = Get-Content -LiteralPath (Join-Path $script:repositoryRoot 'config/standard-v1.json') -Raw | ConvertFrom-Json -Depth 20
        $config.authority.commit | Should -Be 'ead467c3488c103546f316d137196b447a1ff58a'
        $config.authority.archiveSha256 | Should -Be 'ab304bc6caabe4bb9b605f403c852650e19e25f72999010db61bbad695e1c60b'

        $pin = Get-KnowledgeContentPreparedAuthorityPin -Commit $config.authority.commit
        $pin.repository | Should -Be 'https://github.com/SyuanTsai/SyuanTsai-AI-Instructions.git'
        $pin.commit | Should -Be 'ead467c3488c103546f316d137196b447a1ff58a'
        $pin.archiveUrl | Should -Be 'https://codeload.github.com/SyuanTsai/SyuanTsai-AI-Instructions/zip/ead467c3488c103546f316d137196b447a1ff58a'
        $pin.archiveSha256 | Should -Be 'ab304bc6caabe4bb9b605f403c852650e19e25f72999010db61bbad695e1c60b'
        @($config.authority.files).Count | Should -Be 51
        for ($index = 0; $index -lt $pin.files.Count; $index++) {
            $path = @($pin.files.Keys)[$index]
            $config.authority.files[$index].path | Should -BeExactly $path
            $config.authority.files[$index].sha256 | Should -BeExactly $pin.files[$path]
        }
        @($pin.files.Keys).Count | Should -Be 51
        @($pin.files.Keys | Sort-Object -Unique -CaseSensitive).Count | Should -Be 51
        $pin.files['docs/standards/standard-core-validation-v2.json'] | Should -Be 'dd3c3d1bb83a439895ed35a949ff376b9d59d25e69063c86714eb42edaad84df'
        $pin.files['docs/standards/third-party-raw-skill-sources.md'] | Should -Be '18649fd56eada4a94a5d47de778669b0ebcecfb85b84f5c581d283b21979f7ac'
    }

    # Scenario: the active candidate selects the complete reviewed ead467c authority tuple.
    # Purpose: keep both protected source purposes on one exact approved pin.
    It 'UnitT01_accepts_exact_scoped_authority_with_all_51_members' {
        $authority = New-ScopedAuthorityCandidate
        $accepted = Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority
        $accepted.commit | Should -BeExactly $authority.commit
        $accepted.archiveSha256 | Should -BeExactly $authority.archiveSha256
        $accepted.files.Count | Should -Be 51
        foreach ($file in $authority.files) {
            $accepted.files[$file.path] | Should -BeExactly $file.sha256
        }
    }

    # Scenario: both explicit purposes receive the same approved ead467c successor candidate tuple.
    # Purpose: setup and execution must resolve the same authority instead of preparing old tools for a new runner.
    It 'UnitT02_routes_both_source_purposes_to_the_candidate_scoped_authority' {
        $authority = New-ApprovedSourceAuthorityCandidate
        $expectedRunnerSha256 = [string](Get-KnowledgeContentPreparedAuthorityPin -Commit $authority.commit).files['scripts/Invoke-StandardValidation.ps1']
        foreach ($purpose in @('PrepareSourceTools', 'SourceValidation')) {
            $request = @{ SourceToolsPath = $script:fixtureSourceToolsPath; AuthorityRepositoryRoot = $script:fixtureAuthorityRoot; TrustedToolRoot = $script:fixtureRuntimeRoot; CandidateAuthority = $authority }
            $request[$purpose] = $true
            $route = Resolve-KnowledgeContentSourceRoute @request
            $route.authority.commit | Should -BeExactly $authority.commit
            $route.authority.files['scripts/Invoke-StandardValidation.ps1'] | Should -BeExactly $expectedRunnerSha256
        }
    }

    # Scenario: the ead467c tuple retains an old runner or archive, omits or adds a member, or selects an unapproved revision.
    # Purpose: reject mixed authority identities at both setup and execution boundaries.
    It 'UnitT03_rejects_mixed_or_incomplete_scoped_tuple_<Mutation>' -TestCases @(
        @{ Mutation = 'runner' }, @{ Mutation = 'archive' }, @{ Mutation = 'missing' }, @{ Mutation = 'extra' }, @{ Mutation = 'commit' }, @{ Mutation = 'uppercase' }
    ) {
        param($Mutation)
        $authority = New-ApprovedSourceAuthorityCandidate
        switch ($Mutation) {
            'runner' { ($authority.files | Where-Object path -CEQ 'scripts/Invoke-StandardValidation.ps1').sha256 = 'a4ee880810171428a6abd2e8fd5db2da1eaeda4abc0fc6c72dc259b4a709174b' }
            'archive' { $authority.archiveSha256 = '0' * 64 }
            'missing' { $authority.files = @($authority.files | Select-Object -SkipLast 1) }
            'extra' { $authority.files += [pscustomobject]@{ path = 'extra'; sha256 = '0' * 64 } }
            'commit' { $authority.commit = '0' * 40 }
            'uppercase' {
                $authority = New-ApprovedSourceAuthorityCandidate
                $authority.commit = 'EAD467C3488C103546F316D137196B447A1FF58A'
                $authority.archiveUrl = "https://codeload.github.com/SyuanTsai/SyuanTsai-AI-Instructions/zip/$($authority.commit)"
            }
        }
        foreach ($purpose in @('PrepareSourceTools', 'SourceValidation')) {
            $request = @{ SourceToolsPath = $script:fixtureSourceToolsPath; AuthorityRepositoryRoot = $script:fixtureAuthorityRoot; TrustedToolRoot = $script:fixtureRuntimeRoot; CandidateAuthority = $authority }
            $request[$purpose] = $true
            { Resolve-KnowledgeContentSourceRoute @request } | Should -Throw
        }
    }

    # Scenario: the protected reader selects the complete ead467c runner dependency closure before config adoption.
    # Purpose: bind all ordered registry and platform-runtime members to one reviewable canonical digest.
    It 'UnitT04_accepts_only_the_complete_approved_source_tuple' {
        $authority = New-ApprovedSourceAuthorityCandidate
        $accepted = Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority

        $accepted.commit | Should -BeExactly 'ead467c3488c103546f316d137196b447a1ff58a'
        $accepted.archiveSha256 | Should -BeExactly 'ab304bc6caabe4bb9b605f403c852650e19e25f72999010db61bbad695e1c60b'
        @($accepted.files.Keys).Count | Should -Be 51
        @($accepted.files.Keys) | Should -Contain 'docs/standards/skillspector-approved-sources.json'
        @($accepted.files.Keys) | Should -Contain 'docs/standards/schemas/skillspector-approved-sources-v1.schema.json'
        @($accepted.files.Keys) | Should -Contain 'scripts/WindowsDacl.psm1'
        @($accepted.files.Keys) | Should -Contain 'scripts/platform/WindowsInstallerMutation.cs'
        $canonical = (@($accepted.files.GetEnumerator() | ForEach-Object { $_.Key + [char]9 + $_.Value }) -join "`n") + "`n"
        [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($canonical))).ToLowerInvariant() |
            Should -BeExactly 'aec3d84a1709b4435dc65f9a5ae471dafac3a9101d6469eeee607b911f872a75'
    }

    # Scenario: a candidate authority contains the exact fields, ordered files, and identities in the prepared pin.
    # Purpose: establish positive acceptance before testing mutations to every authority identity dimension.
    It 'UnitT05_accepts_the_complete_exact_prepared_authority_tuple' {
        $authority = New-PreparedAuthorityCandidate
        $accepted = Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority

        $accepted.commit | Should -Be $authority.commit
        @($authority.files).Count | Should -Be 51
    }

    # Scenario: a candidate authority omits one member of its file inventory.
    # Purpose: reject incomplete authority tuples even when the remaining records are valid.
    It 'UnitT10_rejects_a_missing_file_member' {
        $authority = New-PreparedAuthorityCandidate
        $authority.files = @($authority.files | Select-Object -First 48)

        Assert-TestThrowsLike { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } '*file tuple is incomplete*'
    }

    # Scenario: a candidate authority repeats one path while retaining the nominal inventory length.
    # Purpose: reject ambiguous duplicate members instead of accepting a count-only match.
    It 'UnitT15_rejects_a_duplicate_file_path' {
        $authority = New-PreparedAuthorityCandidate
        $authority.files[48].path = $authority.files[0].path

        Assert-TestThrowsLike { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } '*duplicate file path*'
    }

    # Scenario: one expected path is paired with another lowercase SHA-256 value.
    # Purpose: bind every authority file path to its approved content digest.
    It 'UnitT20_rejects_an_altered_file_hash' {
        $authority = New-PreparedAuthorityCandidate
        $authority.files[0].sha256 = '0' * 64

        Assert-TestThrowsLike { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } '*file identity mismatch*'
    }

    # Scenario: a file member contains a parent traversal path instead of an authority-relative path.
    # Purpose: fail closed on unsafe paths before any source checkout or file access occurs.
    It 'UnitT25_rejects_an_unsafe_file_path' {
        $authority = New-PreparedAuthorityCandidate
        $authority.files[0].path = '../docs/standards/README.md'

        Assert-TestThrowsLike { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } '*unsafe file path*'
    }

    # Scenario: all file members are valid but two neighboring records are swapped.
    # Purpose: preserve the exact canonical file ordering used by the approved tuple.
    It 'UnitT30_rejects_file_member_reordering' {
        $authority = New-PreparedAuthorityCandidate
        $first = $authority.files[0]
        $authority.files[0] = $authority.files[1]
        $authority.files[1] = $first

        Assert-TestThrowsLike { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } '*file path or order mismatch*'
    }

    # Scenario: a candidate authority has the wrong archive digest or URL for the approved commit.
    # Purpose: prevent archive acquisition from accepting a commit-only or digest-only identity.
    It 'UnitT35_rejects_wrong_archive_digest_and_url' {
        $wrongDigest = New-PreparedAuthorityCandidate
        $wrongDigest.archiveSha256 = '0' * 64
        Assert-TestThrowsLike { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $wrongDigest } '*archiveSha256*'

        $wrongUrl = New-PreparedAuthorityCandidate
        $wrongUrl.archiveUrl = $wrongUrl.archiveUrl.Replace($wrongUrl.commit, '8aabd22694a05771f98639f6d726cc9a620eb94b')
        Assert-TestThrowsLike { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $wrongUrl } '*archiveUrl*'
    }

    # Scenario: a candidate authority changes only the reviewed source commit.
    # Purpose: ensure source execution cannot select a different or future authority snapshot.
    It 'UnitT40_rejects_a_wrong_prepared_commit' {
        $authority = New-PreparedAuthorityCandidate
        $authority.commit = '8aabd22694a05771f98639f6d726cc9a620eb94b'

        Assert-TestThrowsLike { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } '*commit*'
    }

    # Scenario: setup and execution are requested separately with all required roots and paths.
    # Purpose: permit setup and execution against the same complete active pin.
    It 'UnitT45_accepts_complete_separate_setup_and_execution_requests' {
        { Assert-KnowledgeContentSourceRequest -PrepareSourceTools -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot } | Should -Not -Throw
        $authority = New-PreparedAuthorityCandidate
        { Assert-KnowledgeContentSourceRequest -SourceValidation -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot -CandidateAuthority $authority } | Should -Not -Throw
    }

    # Scenario: setup routes through a wrapper's real advanced-function bound-parameter dictionary.
    # Purpose: accept a complete setup request when the legacy archive path was not bound.
    It 'UnitT46_routes_setup_using_actual_advanced_function_parameters' {
        {
            Invoke-KnowledgeContentSourceRouteWithActualParameters -PrepareSourceTools `
                -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot
        } | Should -Not -Throw
    }

    # Scenario: execution routes through a wrapper's real advanced-function bound-parameter dictionary.
    # Purpose: accept a complete source-validation request when the legacy archive path was not bound.
    It 'UnitT47_routes_execution_using_actual_advanced_function_parameters' {
        $authority = New-PreparedAuthorityCandidate
        {
            Invoke-KnowledgeContentSourceRouteWithActualParameters -SourceValidation `
                -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot `
                -CandidateAuthority $authority
        } | Should -Not -Throw
    }

    # Scenario: source validation explicitly binds the legacy archive parameter to null.
    # Purpose: reject the obsolete argument by name even when its value is null.
    It 'UnitT48_rejects_explicitly_bound_null_archive_path' {
        $authority = New-PreparedAuthorityCandidate
        $nullArchivePath = $null
        Assert-TestThrowsLike {
            Invoke-KnowledgeContentSourceRouteWithActualParameters -SourceValidation `
                -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot `
                -AuthorityArchivePath $nullArchivePath -CandidateAuthority $authority
        } '*does not accept AuthorityArchivePath*'
    }

    # Scenario: source validation explicitly binds the legacy archive parameter to an empty string.
    # Purpose: reject the obsolete argument by name even when its value is empty.
    It 'UnitT49_rejects_explicitly_bound_empty_archive_path' {
        $authority = New-PreparedAuthorityCandidate
        Assert-TestThrowsLike {
            Invoke-KnowledgeContentSourceRouteWithActualParameters -SourceValidation `
                -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot `
                -AuthorityArchivePath '' -CandidateAuthority $authority
        } '*does not accept AuthorityArchivePath*'
    }

    # Scenario: both setup and validation are requested in one invocation.
    # Purpose: keep source acquisition and protected execution as distinct operator actions.
    It 'UnitT50_rejects_mixed_setup_and_execution_modes' {
        Assert-TestThrowsLike { Assert-KnowledgeContentSourceRequest -PrepareSourceTools -SourceValidation -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot } '*separate setup and execution*'
    }

    # Scenario: the real setup function imports the pinned runner with its AuthorityRoot in the runner's CandidateRoot parameter.
    # Purpose: keep the original source checkout binding distinct and unchanged until archive creation.
    It 'UnitT51_setup_runner_import_preserves_the_actual_source_checkout_binding' {
        $authorityRoot = Join-Path $TestDrive 'setup-import-authority'
        $candidate = New-SourceValidationTestCandidate -Path (Join-Path $TestDrive 'setup-import-candidate')
        $null = New-SourceValidationImportProbeRunner -AuthorityRoot $authorityRoot
        $probePath = Join-Path $TestDrive 'setup-import-probe.json'
        $probeName = 'KCC_SOURCE_IMPORT_PROBE_PATH'
        $priorProbePath = [Environment]::GetEnvironmentVariable($probeName, 'Process')
        [Environment]::SetEnvironmentVariable($probeName, $probePath, 'Process')
        $candidateHeadBefore = Resolve-GitRevision -GitPath $candidate.git -Root $candidate.root -Revision 'HEAD' -Context 'Candidate before setup import'
        $candidateBytesBefore = Get-FileSha256 -Path (Join-Path $candidate.root 'README.md')

        try {
            $setupCommand = Get-Command New-KnowledgeContentSourceToolSetup -ErrorAction Stop
            $sourceCheckoutParameter = if ($setupCommand.Parameters.ContainsKey('SourceCheckoutRoot')) { 'SourceCheckoutRoot' } else { 'CandidateRoot' }
            $setupArguments = @{
                Root = Join-Path $TestDrive 'setup-import-artifacts'
                AuthorityRoot = $authorityRoot
                AuthorityPin = Get-KnowledgeContentPreparedAuthorityPin -Commit 'ead467c3488c103546f316d137196b447a1ff58a'
                PowerShell = (Get-ResolvedPowerShellPath)
                CandidateRevision = $candidate.head
                Git = $candidate.git
                PreparedPath = Join-Path $TestDrive 'setup-import-artifacts/source-tools.json'
                GoVersion = '1.25.0'
                LimitSeconds = 30
            }
            $setupArguments[$sourceCheckoutParameter] = $candidate.root
            [void](New-Item -ItemType Directory -Path $setupArguments.Root -Force)

            Assert-TestThrowsLike { New-KnowledgeContentSourceToolSetup @setupArguments } '*source-import-probe-stop*'
            $probe = Get-Content -LiteralPath $probePath -Raw | ConvertFrom-Json
            $probe.candidateRoot | Should -BeExactly ([IO.Path]::GetFullPath($authorityRoot))
            $actualSourceCheckout = if ($sourceCheckoutParameter -ceq 'SourceCheckoutRoot') { [string]$probe.sourceCheckoutRoot } else { [string]$probe.candidateRoot }
            $actualSourceCheckout | Should -BeExactly $candidate.root

            (Resolve-GitRevision -GitPath $candidate.git -Root $candidate.root -Revision 'HEAD' -Context 'Candidate after setup import') | Should -BeExactly $candidateHeadBefore
            (Get-FileSha256 -Path (Join-Path $candidate.root 'README.md')) | Should -BeExactly $candidateBytesBefore
            @(& $candidate.git -C $candidate.root status --porcelain=v1 --untracked-files=all).Count | Should -Be 0
        }
        finally {
            [Environment]::SetEnvironmentVariable($probeName, $priorProbePath, 'Process')
        }
    }

    # Scenario: execution dot-sources the pinned runner after reading prepared tools and computing the invocation identity.
    # Purpose: preserve the run, event, timeout, candidate, and prepared input values across the actual import boundary.
    It 'UnitT52_execution_runner_import_preserves_bound_identity_and_leaves_source_inputs_unchanged' {
        $candidate = New-SourceValidationTestCandidate -Path (Join-Path $TestDrive 'execution-import-candidate')
        $authorityRoot = Join-Path $TestDrive 'execution-import-authority'
        $runnerPath = New-SourceValidationImportProbeRunner -AuthorityRoot $authorityRoot
        $sourceToolsPath = Join-Path $TestDrive 'execution-source-tools.json'
        $sourceToolsText = 'immutable prepared source tools fixture'
        [IO.File]::WriteAllText($sourceToolsPath, $sourceToolsText, [Text.UTF8Encoding]::new($false))
        $sourceToolsHashBefore = Get-FileSha256 -Path $sourceToolsPath
        $probePath = Join-Path $TestDrive 'execution-import-probe.json'
        $probeName = 'KCC_SOURCE_IMPORT_PROBE_PATH'
        $priorProbePath = [Environment]::GetEnvironmentVariable($probeName, 'Process')
        [Environment]::SetEnvironmentVariable($probeName, $probePath, 'Process')
        $runId = 'a1234567890b1234567890c123456789'
        $script:sourceValidationTestAuthorityRoot = $authorityRoot
        $script:sourceValidationTestRunnerPath = $runnerPath
        $script:sourceValidationTestPrepared = [pscustomobject]@{
            runId = $runId
            sourceValidation = [pscustomobject]@{ mode = 'actual-import-probe' }
        }

        Mock Assert-KnowledgeContentPreparedAuthorityCheckout {
            return [pscustomobject]@{ root = $script:sourceValidationTestAuthorityRoot; revision = 'fixture'; runnerPath = $script:sourceValidationTestRunnerPath }
        }
        Mock Read-KnowledgeContentSourceToolSetup { return $script:sourceValidationTestPrepared }
        Mock New-KnowledgeContentCoreAuthoritySnapshot { return [pscustomobject]@{ runnerPath = $script:sourceValidationTestRunnerPath } }
        Mock Remove-KnowledgeContentOwnedCoreAdapterRoot { }

        try {
            Assert-TestThrowsLike {
                Invoke-KnowledgeContentSourcePurpose -Mode source-validation -RepositoryRoot $candidate.root `
                    -ArtifactsRoot (Join-Path $TestDrive 'execution-import-artifacts') -SourceToolsPath $sourceToolsPath `
                    -AuthorityRepositoryRoot $authorityRoot -TrustedToolRoot $PSHOME -AuthorityPin (Get-KnowledgeContentPreparedAuthorityPin -Commit 'ead467c3488c103546f316d137196b447a1ff58a') `
                    -CandidateAuthority (New-PreparedAuthorityCandidate) -BaseCommit 'HEAD^' -TimeoutSeconds 1800
            } '*source-import-probe-stop*'

            $probe = Get-Content -LiteralPath $probePath -Raw | ConvertFrom-Json
            $probe.candidateRoot | Should -BeExactly $candidate.root
            $probe.runId | Should -BeExactly $runId
            $probe.eventName | Should -BeExactly 'pull_request'
            $probe.timeoutSeconds | Should -Be 1800
            (Get-FileSha256 -Path $sourceToolsPath) | Should -BeExactly $sourceToolsHashBefore
            (Resolve-GitRevision -GitPath $candidate.git -Root $candidate.root -Revision 'HEAD' -Context 'Candidate after execution import') | Should -BeExactly $candidate.head
            @(& $candidate.git -C $candidate.root status --porcelain=v1 --untracked-files=all).Count | Should -Be 0
        }
        finally {
            [Environment]::SetEnvironmentVariable($probeName, $priorProbePath, 'Process')
            Remove-Variable -Name sourceValidationTestAuthorityRoot, sourceValidationTestRunnerPath, sourceValidationTestPrepared -Scope Script -ErrorAction SilentlyContinue
        }
    }

    # Scenario: the workflow supplies a dedicated GitHub token while ambient GitHub CLI credentials are also present.
    # Purpose: consume the dedicated value once, remove every process-scoped credential immediately, and expose only the runner-namespaced API token to resolvers.
    It 'UnitT53_scopes_the_source_setup_token_to_the_resolver_environment' {
        $names = @('KC_SOURCE_SETUP_GITHUB_TOKEN', 'GITHUB_TOKEN', 'GH_TOKEN')
        $previous = @{}
        foreach ($name in $names) { $previous[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }
        try {
            [Environment]::SetEnvironmentVariable('KC_SOURCE_SETUP_GITHUB_TOKEN', 'fixture-source-setup-token', 'Process')
            [Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'ambient-github-token', 'Process')
            [Environment]::SetEnvironmentVariable('GH_TOKEN', 'ambient-gh-token', 'Process')

            $resolverEnvironment = Get-KnowledgeContentSourceResolverEnvironment -IncludeSetupToken

            @($resolverEnvironment.Keys) | Should -Be @('STANDARD_VALIDATION_GITHUB_API_TOKEN')
            $resolverEnvironment['STANDARD_VALIDATION_GITHUB_API_TOKEN'] | Should -BeExactly 'fixture-source-setup-token'
            foreach ($name in $names) {
                [Environment]::GetEnvironmentVariable($name, 'Process') | Should -BeNullOrEmpty
            }
            (Get-KnowledgeContentSourceResolverEnvironment -IncludeSetupToken).Count | Should -Be 0
        }
        finally {
            foreach ($name in $names) { [Environment]::SetEnvironmentVariable($name, $previous[$name], 'Process') }
        }
    }

    # Scenario: resolver process output or a later setup structure accidentally contains the credential value.
    # Purpose: pass the resolver environment only to the three setup processes and reject the credential before any driver-owned artifact is created.
    It 'UnitT54_limits_the_resolver_token_to_three_children_and_blocks_artifact_leakage' {
        $sourceDriver = Get-Content -LiteralPath $script:sourceDriverPath -Raw
        @([regex]::Matches($sourceDriver, "GetEnvironmentVariable\('KC_SOURCE_SETUP_GITHUB_TOKEN', 'Process'\)")).Count | Should -Be 1
        @([regex]::Matches($sourceDriver, 'Invoke-StandardValidationProcess')).Count | Should -Be 1
        $sourceDriver | Should -Match 'foreach \(\$tool in @\(''skill-validator'', ''skill-tools'', ''skillspector''\)\)'
        $sourceDriver | Should -Match 'Invoke-StandardValidationProcess[^\r\n]+-Environment \$ResolverEnvironment'
        $sourceDriver | Should -Not -Match 'Invoke-StandardValidationProcess[^\r\n]+-Environment @\{\s*GITHUB_TOKEN'
        $setupStart = $sourceDriver.IndexOf('function New-KnowledgeContentSourceToolSetup', [StringComparison]::Ordinal)
        $setupEnd = $sourceDriver.IndexOf('function Test-KnowledgeContentPathEqual', $setupStart, [StringComparison]::Ordinal)
        $setupBody = $sourceDriver.Substring($setupStart, $setupEnd - $setupStart)
        $setupBody | Should -Not -Match 'Write-KnowledgeContentUtf8CreateNew'
        @([regex]::Matches($setupBody, 'Write-KnowledgeContentSourceSetupArtifact')).Count | Should -Be 4

        $leakPath = Join-Path $TestDrive 'source-setup-token-leak.json'
        Assert-TestThrowsLike {
            Write-KnowledgeContentSourceSetupArtifact -Path $leakPath -Text '{"token":"fixture-source-setup-token"}' -ProtectedToken 'fixture-source-setup-token'
        } '*contains the protected resolver credential*'
        Test-Path -LiteralPath $leakPath | Should -BeFalse

        $safePath = Join-Path $TestDrive 'source-setup-safe.json'
        Write-KnowledgeContentSourceSetupArtifact -Path $safePath -Text '{"status":"passed"}' -ProtectedToken 'fixture-source-setup-token'
        (Get-Content -LiteralPath $safePath -Raw) | Should -BeExactly '{"status":"passed"}'
    }

    # Scenario: source validation is requested with the active ead467c config, an obsolete config, or incomplete setup locations.
    # Purpose: accept only the complete active pin while continuing to reject stale receipts and missing trust roots.
    It 'UnitT55_accepts_active_scoped_pin_and_rejects_obsolete_or_incomplete_requests' {
        $activeAuthority = (Get-Content -LiteralPath (Join-Path $script:repositoryRoot 'config/standard-v1.json') -Raw | ConvertFrom-Json -Depth 20).authority
        { Assert-KnowledgeContentSourceRequest -SourceValidation -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot -CandidateAuthority $activeAuthority } | Should -Not -Throw

        $obsoleteAuthority = New-PreparedAuthorityCandidate
        $obsoleteAuthority.commit = '8aabd22694a05771f98639f6d726cc9a620eb94b'
        Assert-TestThrowsLike { Assert-KnowledgeContentSourceRequest -SourceValidation -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot -CandidateAuthority $obsoleteAuthority } '*commit*'
        Assert-TestThrowsLike { Assert-KnowledgeContentSourceRequest -SourceValidation -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot -CandidateAuthority (New-PreparedAuthorityCandidate) } '*SourceToolsPath*'
        Assert-TestThrowsLike { Assert-KnowledgeContentSourceRequest -SourceValidation -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -CandidateAuthority (New-PreparedAuthorityCandidate) } '*TrustedToolRoot*'
    }

    # Scenario: the public entry point is invoked without either explicit source purpose under the active Standard authority.
    # Purpose: prevent ordinary development validation from being mistaken for protected source acceptance without pinning the gate to one authority commit.
    It 'UnitT56_rejects_bare_ordinary_validation_without_a_commit_specific_gate' {
        $validatePath = Join-Path $script:repositoryRoot 'scripts/Validate.ps1'
        $text = Get-Content -LiteralPath $validatePath -Raw

        $text | Should -Match 'if \(\[string\]\$sourceRoute\.mode -ceq ''ordinary''\)\s*\{\s*throw ''Active Standard authority requires explicit -PrepareSourceTools or -SourceValidation; ordinary validation is not protected source acceptance\.'''
        $text | Should -Not -Match '\$config\.authority\.commit\s+-ceq\s+[''"][0-9a-f]{40}[''"]'
    }

    # Scenario: an explicit source request includes the legacy archive path or an ordinary call supplies an empty new root.
    # Purpose: reject arguments that would otherwise be silently ignored by public source-purpose routing.
    It 'UnitT65_rejects_ignored_legacy_archive_and_roots_without_source_purpose' {
        $authority = New-PreparedAuthorityCandidate
        Assert-TestThrowsLike { Resolve-KnowledgeContentSourceRoute -SourceValidation -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot -AuthorityArchivePath $script:fixtureLegacyArchivePath -CandidateAuthority $authority } '*does not accept AuthorityArchivePath*'
        Assert-TestThrowsLike { Resolve-KnowledgeContentSourceRoute -BoundParameters @{ TrustedToolRoot = '' } } '*only valid for explicit source setup or validation*'
    }

    # Scenario: setup and source execution are routed from the active ead467c candidate config.
    # Purpose: bind both explicit public modes to the exact active tuple without acquiring tools in this test.
    It 'UnitT70_routes_setup_and_validation_from_active_scoped_pin' {
        $activeAuthority = (Get-Content -LiteralPath (Join-Path $script:repositoryRoot 'config/standard-v1.json') -Raw | ConvertFrom-Json -Depth 20).authority
        $route = Resolve-KnowledgeContentSourceRoute -PrepareSourceTools -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot -CandidateAuthority $activeAuthority -BoundParameters @{
            PrepareSourceTools = $true
            SourceToolsPath = $script:fixtureSourceToolsPath
            AuthorityRepositoryRoot = $script:fixtureAuthorityRoot
            TrustedToolRoot = $script:fixtureRuntimeRoot
        }

        $route.mode | Should -BeExactly 'prepare-source-tools'
        $route.authority.commit | Should -BeExactly 'ead467c3488c103546f316d137196b447a1ff58a'
        $activeAuthority.commit | Should -BeExactly $route.authority.commit
        { Resolve-KnowledgeContentSourceRoute -SourceValidation -SourceToolsPath $script:fixtureSourceToolsPath -AuthorityRepositoryRoot $script:fixtureAuthorityRoot -TrustedToolRoot $script:fixtureRuntimeRoot -CandidateAuthority $activeAuthority } | Should -Not -Throw
    }

    # Scenario: the public Validate entrypoint accepts explicit source purposes while its active config uses the current pin.
    # Purpose: keep source route selection ahead of the ordinary active-authority gate and bind it to the tested route helper.
    It 'UnitT75_public_entrypoint_uses_prepared_source_routing_before_ordinary_authority_gate' {
        $validatePath = Join-Path $script:repositoryRoot 'scripts/Validate.ps1'
        $validate = Get-Content -LiteralPath $validatePath -Raw
        $validate | Should -Match '\[switch\]\s+\$PrepareSourceTools'
        $validate | Should -Match '\[switch\]\s+\$SourceValidation'
        $route = $validate.IndexOf('Resolve-KnowledgeContentSourceRoute', [StringComparison]::Ordinal)
        $activeGate = $validate.IndexOf('Active Standard authority requires explicit -PrepareSourceTools or -SourceValidation', [StringComparison]::Ordinal)
        $route | Should -BeGreaterThan -1
        $activeGate | Should -BeGreaterThan -1
        $route | Should -BeLessThan $activeGate
    }

    # Scenario: the production Core Pester authority resolver receives a canonical candidate snapshot and parent adapter layout.
    # Purpose: verify run/check identity binding, adapter-file selection, and reparse rejection on every supported test host.
    It 'UnitT80_production_authority_resolver_binds_the_exact_run_owned_snapshot_and_rejects_mismatches' {
        $outerRunId = [guid]::NewGuid().ToString('N')
        $coreRunId = [guid]::NewGuid().ToString('N')
        $artifacts = Join-Path $TestDrive 'core-pester-parent-dependency'
        $layout = Get-KnowledgeContentCorePesterLayout -ArtifactsRoot $artifacts -RunId $outerRunId
        $adapterRoot = [string]$layout.adapterRoot
        $authorityRoot = [string]$layout.authorityRoot
        $candidateRoot = Join-Path $artifacts "source-validation-$outerRunId/runs/$coreRunId/candidate"
        [void](New-Item -ItemType Directory -Path $authorityRoot -Force)
        [void](New-Item -ItemType Directory -Path $candidateRoot -Force)
        $powerShell = [IO.Path]::GetFullPath([Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
        $adapter = New-KnowledgeContentSourceCoreAdapter -PowerShell $powerShell -RunId $outerRunId `
            -ActiveSkillIds @('authority-binding') -SourceValidation ([pscustomobject]@{ mode = 'test-source-validation' })
        $adapterPath = [string]$layout.adapterPath
        [IO.File]::WriteAllText($adapterPath, ($adapter | ConvertTo-Json -Depth 10 -Compress), [Text.UTF8Encoding]::new($false))
        @($adapter.checks | Where-Object { [string]$_.id -ceq 'repository-pester' })[0].arguments[-1] | Should -BeExactly $outerRunId
        $resolvedAuthorityRoot = Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $coreRunId -OuterRunId $outerRunId
        $resolvedAuthorityRoot | Should -BeExactly ([IO.Path]::GetFullPath($authorityRoot))

        $wrongCoreRunId = [guid]::NewGuid().ToString('N')
        Assert-TestThrowsLike { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $wrongCoreRunId -OuterRunId $outerRunId } '*candidate snapshot does not match the trusted run identity*'
        Assert-TestThrowsLike { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $coreRunId -OuterRunId ([guid]::NewGuid().ToString('N')) } '*outer adapter identity does not select the run-owned adapter snapshot*'
        Assert-TestThrowsLike { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $coreRunId -OuterRunId $outerRunId -CheckId 'repository-knowledge' } '*trusted repository-pester run identity*'

        Remove-Item -LiteralPath $adapterPath -Force
        Assert-TestThrowsLike { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $coreRunId -OuterRunId $outerRunId } '*outer adapter identity does not select the run-owned adapter snapshot*'
        [IO.File]::WriteAllText($adapterPath, ($adapter | ConvertTo-Json -Depth 10 -Compress), [Text.UTF8Encoding]::new($false))

        $reparseTarget = Join-Path $artifacts 'reparse-authority-target'
        [void](New-Item -ItemType Directory -Path $reparseTarget -Force)
        Remove-Item -LiteralPath $authorityRoot -Force
        try {
            New-SourceTestDirectoryReparsePoint -Path $authorityRoot -Target $reparseTarget
            Assert-TestThrowsLike { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $coreRunId -OuterRunId $outerRunId } '*authority snapshot contains a reparse ancestor*'
        }
        finally {
            if (Test-Path -LiteralPath $authorityRoot) { Remove-Item -LiteralPath $authorityRoot -Force }
        }
    }

    # Scenario: the source adapter and its Pester child are generated from the exact source wrapper and resolver receipt identities.
    # Purpose: keep native report fields and Static's direct skillspector argv/exit binding required by the Core assertion.
    It 'UnitT85_binds_static_native_report_to_its_frozen_skillspector_receipt_and_exact_invocation' {
        $driver = Get-Content -LiteralPath (Join-Path $script:repositoryRoot 'scripts/Validate.ps1') -Raw
        $driver | Should -Match '\$script:NativeReports\s*=\s*@\(\)'
        $driver | Should -Match 'nativeReports\s*=\s*@\(\$script:NativeReports\)'
        $driver | Should -Match 'Add-NativeReport\s+-Command \(\[string\]\$toolchain\.skillSpectorPath\)\s+-Arguments \$nativeArguments\s+-ExitCode \$nativeExit\s+-Path \$reportPath\s+-SkillId \$skillId'
        $driver | Should -Match 'if \(Test-Path -LiteralPath \$reportPath\) \{ throw "SkillSpector stdout report path already exists for ''\$skillId''\." \}'
        $driver | Should -Match '\$nativeArguments = @\(''scan'', \$skillRoot, ''--no-llm'', ''--format'', ''json''\)'
        $driver | Should -Not -Match '\$nativeArguments = @\([^\r\n]*''--output'''
        $driver | Should -Match '& \(\[string\]\$toolchain\.skillSpectorPath\) @nativeArguments 1> \$reportPath 2> \$staticStderrPath'
        $sourceDriver = Get-Content -LiteralPath $script:sourceDriverPath -Raw
        $sourceDriver | Should -Match 'skillSpectorPath\s*=\s*\[string\]\$receipts\.skillspector\.executablePath'
        $sourceDriver | Should -Match 'skillSpectorReceiptSha256\s*=\s*\[string\]\$receiptBindings\[2\]\.sha256'
        $sourceDriver | Should -Match 'Prepared source toolchain does not match the \$\(\$binding\.name\) resolver receipt'
    }

    # Scenario: SkillSpector performs a cold Python import from its frozen installed tool closure.
    # Purpose: Prove the Static child sets the Python bytecode guard before launch and that a cold import leaves a complete file inventory unchanged.
    It 'UnitT90_prevents_cold_import_bytecode_from_mutating_the_static_tool_closure' {
        $driver = Get-Content -LiteralPath (Join-Path $script:repositoryRoot 'scripts/Validate.ps1') -Raw
        $staticStart = $driver.IndexOf("        'static' {", [StringComparison]::Ordinal)
        $staticStart | Should -BeGreaterOrEqual 0
        $bytecodeGuard = $driver.IndexOf('$env:PYTHONDONTWRITEBYTECODE = ''1''', $staticStart, [StringComparison]::Ordinal)
        $skillSpectorLaunch = $driver.IndexOf('& ([string]$toolchain.skillSpectorPath) @nativeArguments', $staticStart, [StringComparison]::Ordinal)
        $bytecodeGuard | Should -BeGreaterOrEqual 0
        $skillSpectorLaunch | Should -BeGreaterThan $bytecodeGuard

        $python = $null
        $pythonNames = if ($IsWindows) { @('python', 'py', 'python3') } else { @('python3', 'python') }
        foreach ($name in $pythonNames) {
            $python = Get-Command -Name $name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($null -ne $python) { break }
        }
        if ($null -eq $python) { throw 'Cold-import closure verification requires a Python 3 executable.' }

        $fixtureRoot = Join-Path $TestDrive 'cold-python-import-closure'
        $defaultImportRoot = Join-Path $fixtureRoot 'default-import'
        $guardedImportRoot = Join-Path $fixtureRoot 'guarded-import'
        [void](New-Item -ItemType Directory -Path $defaultImportRoot -Force)
        [void](New-Item -ItemType Directory -Path $guardedImportRoot -Force)
        $moduleBytes = [Text.UTF8Encoding]::new($false).GetBytes("value = 'cold import'`n")
        [IO.File]::WriteAllBytes((Join-Path $defaultImportRoot 'cold_import_fixture.py'), $moduleBytes)
        [IO.File]::WriteAllBytes((Join-Path $guardedImportRoot 'cold_import_fixture.py'), $moduleBytes)
        $pythonCode = 'import importlib, sys; sys.path.insert(0, sys.argv[1]); importlib.import_module("cold_import_fixture")'
        $launcherArguments = if ([IO.Path]::GetFileNameWithoutExtension($python.Name) -ceq 'py') { @('-3') } else { @() }
        $previousBytecode = [Environment]::GetEnvironmentVariable('PYTHONDONTWRITEBYTECODE', 'Process')
        $previousCachePrefix = [Environment]::GetEnvironmentVariable('PYTHONPYCACHEPREFIX', 'Process')
        try {
            Remove-Item -LiteralPath 'Env:PYTHONDONTWRITEBYTECODE' -ErrorAction SilentlyContinue
            Remove-Item -LiteralPath 'Env:PYTHONPYCACHEPREFIX' -ErrorAction SilentlyContinue
            $defaultOutput = @(& $python.Source @launcherArguments -c $pythonCode $defaultImportRoot 2>&1)
            $defaultExitCode = $LASTEXITCODE
            $defaultExitCode | Should -Be 0 -Because ($defaultOutput -join "`n")
            @(Get-ChildItem -LiteralPath $defaultImportRoot -Filter '*.pyc' -File -Recurse -Force).Count | Should -BeGreaterThan 0
            $closureBefore = @(
                Get-ChildItem -LiteralPath $guardedImportRoot -File -Recurse -Force | Sort-Object FullName | ForEach-Object {
                    $relative = [IO.Path]::GetRelativePath($guardedImportRoot, $_.FullName).Replace([IO.Path]::DirectorySeparatorChar, '/')
                    "$relative=$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant())"
                }
            ) -join "`n"

            [Environment]::SetEnvironmentVariable('PYTHONDONTWRITEBYTECODE', '1', 'Process')
            $guardedOutput = @(& $python.Source @launcherArguments -c $pythonCode $guardedImportRoot 2>&1)
            $guardedExitCode = $LASTEXITCODE
            $guardedExitCode | Should -Be 0 -Because ($guardedOutput -join "`n")
            $closureAfter = @(
                Get-ChildItem -LiteralPath $guardedImportRoot -File -Recurse -Force | Sort-Object FullName | ForEach-Object {
                    $relative = [IO.Path]::GetRelativePath($guardedImportRoot, $_.FullName).Replace([IO.Path]::DirectorySeparatorChar, '/')
                    "$relative=$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant())"
                }
            ) -join "`n"
            $closureAfter | Should -BeExactly $closureBefore
            @(Get-ChildItem -LiteralPath $guardedImportRoot -Filter '*.pyc' -File -Recurse -Force).Count | Should -Be 0
        }
        finally {
            if ($null -eq $previousBytecode) {
                Remove-Item -LiteralPath 'Env:PYTHONDONTWRITEBYTECODE' -ErrorAction SilentlyContinue
            }
            else {
                Set-Item -LiteralPath 'Env:PYTHONDONTWRITEBYTECODE' -Value $previousBytecode
            }
            if ($null -eq $previousCachePrefix) {
                Remove-Item -LiteralPath 'Env:PYTHONPYCACHEPREFIX' -ErrorAction SilentlyContinue
            }
            else {
                Set-Item -LiteralPath 'Env:PYTHONPYCACHEPREFIX' -Value $previousCachePrefix
            }
        }
    }

    # Scenario: Three approved source-tool receipts bind executable tools plus the skill-tools JavaScript payload and Node runtime while its launcher shim remains outside the frozen inventory.
    # Purpose: Accept the platform-specific npm launcher through receipt integrity without freezing its symlink or .cmd path, while retaining every executed file identity.
    It 'UnitT60_accepts_the_skill_tools_launcher_outside_the_frozen_closure_but_requires_executed_files' {
        $root = Join-Path $TestDrive 'frozen-source-tools'
        [void](New-Item -ItemType Directory -Path $root)
        $toolPaths = [ordered]@{
            validator = Join-Path $root 'skill-validator.exe'
            shim = Join-Path $root 'skill-tools.cmd'
            entry = Join-Path $root 'skill-tools.js'
            node = Join-Path $root $(if ($IsWindows) { 'node.exe' } else { 'node' })
            spector = Join-Path $root 'skillspector.exe'
        }
        foreach ($path in $toolPaths.Values) {
            [IO.File]::WriteAllText($path, "fixture-$([IO.Path]::GetFileName($path))", [Text.UTF8Encoding]::new($false))
        }
        $receipts = @(
            [pscustomobject]@{ toolName = 'skill-validator'; executablePath = $toolPaths.validator; executableSha256 = (Get-FileHash -LiteralPath $toolPaths.validator -Algorithm SHA256).Hash.ToLowerInvariant() }
            [pscustomobject]@{ toolName = 'skill-tools'; executablePath = $toolPaths.shim; executableSha256 = (Get-FileHash -LiteralPath $toolPaths.shim -Algorithm SHA256).Hash.ToLowerInvariant(); entryPointPath = $toolPaths.entry; entryPointSha256 = (Get-FileHash -LiteralPath $toolPaths.entry -Algorithm SHA256).Hash.ToLowerInvariant(); nodePath = $toolPaths.node; nodeSha256 = (Get-FileHash -LiteralPath $toolPaths.node -Algorithm SHA256).Hash.ToLowerInvariant() }
            [pscustomobject]@{ toolName = 'skillspector'; executablePath = $toolPaths.spector; executableSha256 = (Get-FileHash -LiteralPath $toolPaths.spector -Algorithm SHA256).Hash.ToLowerInvariant() }
        )
        $bindings = @()
        $frozen = @()
        for ($index = 0; $index -lt $receipts.Count; $index++) {
            $receiptPath = Join-Path $root "receipt-$index.json"
            [IO.File]::WriteAllText($receiptPath, ($receipts[$index] | ConvertTo-Json -Compress), [Text.UTF8Encoding]::new($false))
            $receiptHash = (Get-FileHash -LiteralPath $receiptPath -Algorithm SHA256).Hash.ToLowerInvariant()
            $bindings += [pscustomobject]@{ path = $receiptPath; sha256 = $receiptHash }
            $frozen += [pscustomobject]@{ path = $receiptPath; sha256 = $receiptHash }
        }
        foreach ($path in @($toolPaths.validator, $toolPaths.entry, $toolPaths.node, $toolPaths.spector)) {
            $frozen += [pscustomobject]@{ path = $path; sha256 = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant() }
        }

        { Assert-KnowledgeContentSourceReceiptClosureFrozen -Bindings $bindings -FrozenFiles $frozen } | Should -Not -Throw
        foreach ($missingPath in @($toolPaths.entry, $toolPaths.node, $toolPaths.validator, $toolPaths.spector)) {
            $withoutRequiredIdentity = @($frozen | Where-Object { [string]$_.path -cne $missingPath })
            Assert-TestThrowsLike { Assert-KnowledgeContentSourceReceiptClosureFrozen -Bindings $bindings -FrozenFiles $withoutRequiredIdentity } '*is not frozen exactly once*'
        }
    }
}
