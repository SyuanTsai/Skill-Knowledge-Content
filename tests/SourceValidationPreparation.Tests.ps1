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

    function New-PreparedAuthorityCandidate {
        $pin = Get-KnowledgeContentPreparedAuthorityPin
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
    # Scenario: the active public config and the protected source driver select the same reviewed ff85 authority.
    # Purpose: bind the active Standard v1 pin to the complete 32-file prepared source authority.
    It 'UnitT00_preserves_active_pin_and_returns_exact_32_file_ff85_pin' {
        $config = Get-Content -LiteralPath (Join-Path $script:repositoryRoot 'config/standard-v1.json') -Raw | ConvertFrom-Json -Depth 20
        $config.authority.commit | Should -Be 'ff85d5f80fe795b96354e753074b5ce59ad04ecd'
        $config.authority.archiveSha256 | Should -Be '3dc38613f2e2316ad8fcc79d4bf48d0b03fd8398f8dacc72d156abcbce95ea9d'

        $pin = Get-KnowledgeContentPreparedAuthorityPin
        $pin.repository | Should -Be 'https://github.com/SyuanTsai/SyuanTsai-AI-Instructions.git'
        $pin.commit | Should -Be 'ff85d5f80fe795b96354e753074b5ce59ad04ecd'
        $pin.archiveUrl | Should -Be 'https://codeload.github.com/SyuanTsai/SyuanTsai-AI-Instructions/zip/ff85d5f80fe795b96354e753074b5ce59ad04ecd'
        $pin.archiveSha256 | Should -Be '3dc38613f2e2316ad8fcc79d4bf48d0b03fd8398f8dacc72d156abcbce95ea9d'
        @($config.authority.files).Count | Should -Be 32
        for ($index = 0; $index -lt $pin.files.Count; $index++) {
            $path = @($pin.files.Keys)[$index]
            $config.authority.files[$index].path | Should -BeExactly $path
            $config.authority.files[$index].sha256 | Should -BeExactly $pin.files[$path]
        }
        @($pin.files.Keys).Count | Should -Be 32
        @($pin.files.Keys | Sort-Object -Unique -CaseSensitive).Count | Should -Be 32
        $pin.files['docs/standards/standard-core-validation-v2.json'] | Should -Be '2ba91aec827a642517fd90d294524e0dfc3fed9ae19c27d867d442d73b4915d6'
        $pin.files['docs/standards/third-party-raw-skill-sources.md'] | Should -Be '18649fd56eada4a94a5d47de778669b0ebcecfb85b84f5c581d283b21979f7ac'
    }

    # Scenario: a candidate authority contains the exact fields, ordered files, and identities in the prepared ff85 pin.
    # Purpose: establish positive acceptance before testing mutations to every authority identity dimension.
    It 'UnitT05_accepts_the_complete_exact_prepared_authority_tuple' {
        $authority = New-PreparedAuthorityCandidate
        $accepted = Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority

        $accepted.commit | Should -Be $authority.commit
        @($authority.files).Count | Should -Be 32
    }

    # Scenario: a candidate authority omits one member of its file inventory.
    # Purpose: reject incomplete authority tuples even when the remaining records are valid.
    It 'UnitT10_rejects_a_missing_file_member' {
        $authority = New-PreparedAuthorityCandidate
        $authority.files = @($authority.files | Select-Object -First 31)

        { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } | Should -Throw '*file tuple is incomplete*'
    }

    # Scenario: a candidate authority repeats one path while retaining the nominal inventory length.
    # Purpose: reject ambiguous duplicate members instead of accepting a count-only match.
    It 'UnitT15_rejects_a_duplicate_file_path' {
        $authority = New-PreparedAuthorityCandidate
        $authority.files[31].path = $authority.files[0].path

        { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } | Should -Throw '*duplicate file path*'
    }

    # Scenario: one expected path is paired with another lowercase SHA-256 value.
    # Purpose: bind every authority file path to its approved content digest.
    It 'UnitT20_rejects_an_altered_file_hash' {
        $authority = New-PreparedAuthorityCandidate
        $authority.files[0].sha256 = '0' * 64

        { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } | Should -Throw '*file identity mismatch*'
    }

    # Scenario: a file member contains a parent traversal path instead of an authority-relative path.
    # Purpose: fail closed on unsafe paths before any source checkout or file access occurs.
    It 'UnitT25_rejects_an_unsafe_file_path' {
        $authority = New-PreparedAuthorityCandidate
        $authority.files[0].path = '../docs/standards/README.md'

        { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } | Should -Throw '*unsafe file path*'
    }

    # Scenario: all file members are valid but two neighboring records are swapped.
    # Purpose: preserve the exact canonical file ordering used by the approved tuple.
    It 'UnitT30_rejects_file_member_reordering' {
        $authority = New-PreparedAuthorityCandidate
        $first = $authority.files[0]
        $authority.files[0] = $authority.files[1]
        $authority.files[1] = $first

        { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } | Should -Throw '*file path or order mismatch*'
    }

    # Scenario: a candidate authority has the wrong archive digest or URL for the approved commit.
    # Purpose: prevent archive acquisition from accepting a commit-only or digest-only identity.
    It 'UnitT35_rejects_wrong_archive_digest_and_url' {
        $wrongDigest = New-PreparedAuthorityCandidate
        $wrongDigest.archiveSha256 = '0' * 64
        { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $wrongDigest } | Should -Throw '*archiveSha256*'

        $wrongUrl = New-PreparedAuthorityCandidate
        $wrongUrl.archiveUrl = $wrongUrl.archiveUrl.Replace($wrongUrl.commit, '8aabd22694a05771f98639f6d726cc9a620eb94b')
        { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $wrongUrl } | Should -Throw '*archiveUrl*'
    }

    # Scenario: a candidate authority changes only the reviewed source commit.
    # Purpose: ensure source execution cannot select a different or future authority snapshot.
    It 'UnitT40_rejects_a_wrong_prepared_commit' {
        $authority = New-PreparedAuthorityCandidate
        $authority.commit = '8aabd22694a05771f98639f6d726cc9a620eb94b'

        { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $authority } | Should -Throw '*commit*'
    }

    # Scenario: setup and execution are requested separately with all required roots and paths.
    # Purpose: permit setup and execution against the same complete active ff85 pin.
    It 'UnitT45_accepts_complete_separate_setup_and_execution_requests' {
        { Assert-KnowledgeContentSourceRequest -PrepareSourceTools -SourceToolsPath 'C:/owned/source-tools.json' -AuthorityRepositoryRoot 'C:/authority' -TrustedToolRoot 'C:/runtime' } | Should -Not -Throw
        $authority = New-PreparedAuthorityCandidate
        { Assert-KnowledgeContentSourceRequest -SourceValidation -SourceToolsPath 'C:/owned/source-tools.json' -AuthorityRepositoryRoot 'C:/authority' -TrustedToolRoot 'C:/runtime' -CandidateAuthority $authority } | Should -Not -Throw
    }

    # Scenario: both setup and validation are requested in one invocation.
    # Purpose: keep source acquisition and protected execution as distinct operator actions.
    It 'UnitT50_rejects_mixed_setup_and_execution_modes' {
        { Assert-KnowledgeContentSourceRequest -PrepareSourceTools -SourceValidation -SourceToolsPath 'C:/owned/source-tools.json' -AuthorityRepositoryRoot 'C:/authority' -TrustedToolRoot 'C:/runtime' } | Should -Throw '*separate setup and execution*'
    }

    # Scenario: source validation is requested with the active ff85 config, an obsolete 8a config, or incomplete setup locations.
    # Purpose: accept only the complete active pin while continuing to reject stale receipts and missing trust roots.
    It 'UnitT55_accepts_active_ff85_and_rejects_obsolete_or_incomplete_requests' {
        $activeAuthority = (Get-Content -LiteralPath (Join-Path $script:repositoryRoot 'config/standard-v1.json') -Raw | ConvertFrom-Json -Depth 20).authority
        { Assert-KnowledgeContentSourceRequest -SourceValidation -SourceToolsPath 'C:/owned/source-tools.json' -AuthorityRepositoryRoot 'C:/authority' -TrustedToolRoot 'C:/runtime' -CandidateAuthority $activeAuthority } | Should -Not -Throw

        $obsoleteAuthority = New-PreparedAuthorityCandidate
        $obsoleteAuthority.commit = '8aabd22694a05771f98639f6d726cc9a620eb94b'
        { Assert-KnowledgeContentSourceRequest -SourceValidation -SourceToolsPath 'C:/owned/source-tools.json' -AuthorityRepositoryRoot 'C:/authority' -TrustedToolRoot 'C:/runtime' -CandidateAuthority $obsoleteAuthority } | Should -Throw '*commit*'
        { Assert-KnowledgeContentSourceRequest -SourceValidation -AuthorityRepositoryRoot 'C:/authority' -TrustedToolRoot 'C:/runtime' -CandidateAuthority (New-PreparedAuthorityCandidate) } | Should -Throw '*SourceToolsPath*'
        { Assert-KnowledgeContentSourceRequest -SourceValidation -SourceToolsPath 'C:/owned/source-tools.json' -AuthorityRepositoryRoot 'C:/authority' -CandidateAuthority (New-PreparedAuthorityCandidate) } | Should -Throw '*TrustedToolRoot*'
    }

    # Scenario: the public entry point is invoked without a source purpose while the active config is pinned to ff85.
    # Purpose: fail closed before ordinary validation can acquire tools or report an unprotected v1 pass.
    It 'UnitT56_rejects_ordinary_validation_while_ff85_is_active' {
        $validatePath = Join-Path $script:repositoryRoot 'scripts/Validate.ps1'
        $output = @(& $script:verifiedPowerShellExecutable -NoProfile -NonInteractive -File $validatePath -RepositoryRoot $script:repositoryRoot 2>&1)
        $exitCode = $LASTEXITCODE
        $text = $output -join "`n"

        $exitCode | Should -Be 1
        $text | Should -Match 'Active ff85 authority requires explicit -PrepareSourceTools or -SourceValidation'
    }

    # Scenario: an explicit source request includes the legacy archive path or an ordinary call supplies an empty new root.
    # Purpose: reject arguments that would otherwise be silently ignored by public source-purpose routing.
    It 'UnitT65_rejects_ignored_legacy_archive_and_roots_without_source_purpose' {
        $authority = New-PreparedAuthorityCandidate
        { Resolve-KnowledgeContentSourceRoute -SourceValidation -SourceToolsPath 'C:/owned/source-tools.json' -AuthorityRepositoryRoot 'C:/authority' -TrustedToolRoot 'C:/runtime' -AuthorityArchivePath 'C:/legacy/authority.zip' -CandidateAuthority $authority } | Should -Throw '*does not accept AuthorityArchivePath*'
        { Resolve-KnowledgeContentSourceRoute -BoundParameters @{ TrustedToolRoot = '' } } | Should -Throw '*only valid for explicit source setup or validation*'
    }

    # Scenario: setup and source execution are routed from the active ff85 candidate config.
    # Purpose: bind both explicit public modes to the exact active tuple without acquiring tools in this test.
    It 'UnitT70_routes_setup_and_validation_from_active_ff85' {
        $activeAuthority = (Get-Content -LiteralPath (Join-Path $script:repositoryRoot 'config/standard-v1.json') -Raw | ConvertFrom-Json -Depth 20).authority
        $route = Resolve-KnowledgeContentSourceRoute -PrepareSourceTools -SourceToolsPath 'C:/owned/source-tools.json' -AuthorityRepositoryRoot 'C:/authority' -TrustedToolRoot 'C:/runtime' -CandidateAuthority $activeAuthority -BoundParameters @{
            PrepareSourceTools = $true
            SourceToolsPath = 'C:/owned/source-tools.json'
            AuthorityRepositoryRoot = 'C:/authority'
            TrustedToolRoot = 'C:/runtime'
        }

        $route.mode | Should -BeExactly 'prepare-source-tools'
        $route.authority.commit | Should -BeExactly 'ff85d5f80fe795b96354e753074b5ce59ad04ecd'
        $activeAuthority.commit | Should -BeExactly $route.authority.commit
        { Resolve-KnowledgeContentSourceRoute -SourceValidation -SourceToolsPath 'C:/owned/source-tools.json' -AuthorityRepositoryRoot 'C:/authority' -TrustedToolRoot 'C:/runtime' -CandidateAuthority $activeAuthority } | Should -Not -Throw
    }

    # Scenario: the public Validate entrypoint accepts explicit source purposes while its active config uses ff85.
    # Purpose: keep source route selection ahead of the ordinary active-authority gate and bind it to the tested route helper.
    It 'UnitT75_public_entrypoint_uses_prepared_source_routing_before_ordinary_authority_gate' {
        $validatePath = Join-Path $script:repositoryRoot 'scripts/Validate.ps1'
        $validate = Get-Content -LiteralPath $validatePath -Raw
        $validate | Should -Match '\[switch\]\s+\$PrepareSourceTools'
        $validate | Should -Match '\[switch\]\s+\$SourceValidation'
        $route = $validate.IndexOf('Resolve-KnowledgeContentSourceRoute', [StringComparison]::Ordinal)
        $activeGate = $validate.IndexOf('Assert-AuthorityConfig -Config $config', [StringComparison]::Ordinal)
        $route | Should -BeGreaterThan -1
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
        { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $wrongCoreRunId -OuterRunId $outerRunId } |
            Should -Throw '*candidate snapshot does not match the trusted run identity*'
        { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $coreRunId -OuterRunId ([guid]::NewGuid().ToString('N')) } |
            Should -Throw '*outer adapter identity does not select the run-owned adapter snapshot*'
        { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $coreRunId -OuterRunId $outerRunId -CheckId 'repository-knowledge' } |
            Should -Throw '*trusted repository-pester run identity*'

        Remove-Item -LiteralPath $adapterPath -Force
        { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $coreRunId -OuterRunId $outerRunId } |
            Should -Throw '*outer adapter identity does not select the run-owned adapter snapshot*'
        [IO.File]::WriteAllText($adapterPath, ($adapter | ConvertTo-Json -Depth 10 -Compress), [Text.UTF8Encoding]::new($false))

        $reparseTarget = Join-Path $artifacts 'reparse-authority-target'
        [void](New-Item -ItemType Directory -Path $reparseTarget -Force)
        Remove-Item -LiteralPath $authorityRoot -Force
        try {
            New-SourceTestDirectoryReparsePoint -Path $authorityRoot -Target $reparseTarget
            { Invoke-CorePesterAuthorityDependency -CandidateRoot $candidateRoot -CoreRunId $coreRunId -OuterRunId $outerRunId } |
                Should -Throw '*authority snapshot contains a reparse ancestor*'
        }
        finally {
            if (Test-Path -LiteralPath $authorityRoot) { Remove-Item -LiteralPath $authorityRoot -Force }
        }
    }

    # Scenario: the source adapter and its Pester child are generated from the exact source wrapper and resolver receipt identities.
    # Purpose: keep native report fields and Static's direct skillspector argv/exit binding required by the ff85 Core assertion.
    It 'UnitT85_binds_static_native_report_to_its_frozen_skillspector_receipt_and_exact_invocation' {
        $driver = Get-Content -LiteralPath (Join-Path $script:repositoryRoot 'scripts/Validate.ps1') -Raw
        $driver | Should -Match '\$script:NativeReports\s*=\s*@\(\)'
        $driver | Should -Match 'nativeReports\s*=\s*@\(\$script:NativeReports\)'
        $driver | Should -Match 'Add-NativeReport\s+-Command \(\[string\]\$toolchain\.skillSpectorPath\)\s+-Arguments \$nativeArguments\s+-ExitCode \$nativeExit\s+-Path \$reportPath\s+-SkillId \$skillId'
        $driver | Should -Match '\$nativeArguments = @\(''scan'', \$skillRoot, ''--no-llm'', ''--format'', ''json'', ''--output'', \$reportPath\)'
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
            [Environment]::SetEnvironmentVariable('PYTHONDONTWRITEBYTECODE', $null, 'Process')
            [Environment]::SetEnvironmentVariable('PYTHONPYCACHEPREFIX', $null, 'Process')
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
            [Environment]::SetEnvironmentVariable('PYTHONDONTWRITEBYTECODE', $previousBytecode, 'Process')
            [Environment]::SetEnvironmentVariable('PYTHONPYCACHEPREFIX', $previousCachePrefix, 'Process')
        }
    }

    # Scenario: Three approved source-tool receipts bind the skill-tools launcher, JavaScript payload, and Node runtime.
    # Purpose: Require the receipt and all three execution identities in the frozen source inventory.
    It 'UnitT60_requires_every_source_receipt_and_skill_tools_launcher_payload_runtime_to_be_frozen' {
        $root = Join-Path $TestDrive 'frozen-source-tools'
        [void](New-Item -ItemType Directory -Path $root)
        $toolPaths = [ordered]@{
            validator = Join-Path $root 'skill-validator.exe'
            shim = Join-Path $root 'skill-tools.cmd'
            entry = Join-Path $root 'skill-tools.js'
            node = Join-Path $root 'node.exe'
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
        foreach ($path in $toolPaths.Values) {
            $frozen += [pscustomobject]@{ path = $path; sha256 = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant() }
        }

        { Assert-KnowledgeContentSourceReceiptClosureFrozen -Bindings $bindings -FrozenFiles $frozen } | Should -Not -Throw
        foreach ($missingPath in @($toolPaths.shim, $toolPaths.entry, $toolPaths.node)) {
            $withoutRequiredIdentity = @($frozen | Where-Object { [string]$_.path -cne $missingPath })
            { Assert-KnowledgeContentSourceReceiptClosureFrozen -Bindings $bindings -FrozenFiles $withoutRequiredIdentity } | Should -Throw '*is not frozen exactly once*'
        }
        $sourceDriver = Get-Content -LiteralPath $script:sourceDriverPath -Raw
        $sourceDriver | Should -Match '\[string\]\$receipts\.\x27skill-tools\x27\.executablePath'
    }
}
