# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
Describe 'Knowledge child uses central package tool report rules' {
    BeforeAll {
        $validationPath = if ([string]::IsNullOrWhiteSpace($env:SYP154_TEST_VALIDATE_SOURCE)) { Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts/Validate.ps1' } else { [string]$env:SYP154_TEST_VALIDATE_SOURCE }
        $script:validationSource = Get-Content -LiteralPath $validationPath -Raw
        $script:childMatch = [regex]::Match($script:validationSource, '(?ms)^\$childRunnerText = @''\r?\n(?<body>.*?)^''@')
        if (-not $script:childMatch.Success) { throw 'Knowledge child runner source was not found.' }
        $sourceHelperPath = Join-Path (Split-Path -Parent $validationPath) 'StandardCoreSourceValidation.ps1'
        $quotedSourceHelperPath = ([IO.Path]::GetFullPath($sourceHelperPath)).Replace("'", "''")
        $script:driverPrefix = $script:validationSource.Substring(0, $script:childMatch.Index).Replace(
            ". (Join-Path `$PSScriptRoot 'StandardCoreSourceValidation.ps1')",
            ". '$quotedSourceHelperPath'"
        )

        function Assert-TestThrowsLike {
            param([scriptblock] $ScriptBlock, [string] $Pattern)
            $caught = $null
            try { & $ScriptBlock } catch { $caught = $_ }
            $caught | Should -Not -BeNullOrEmpty
            ([string]$caught.Exception.Message) | Should -BeLike $Pattern
        }
        $script:candidateRoot = Split-Path -Parent $PSScriptRoot
        function Get-KnowledgeCandidateBytesFingerprint {
            param([Parameter(Mandatory = $true)][string] $Root)
            $rows = @(
                Get-ChildItem -LiteralPath $Root -File -Recurse -Force -ErrorAction Stop |
                    Where-Object { ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -eq 0 } |
                    Sort-Object -Property FullName -CaseSensitive |
                    ForEach-Object {
                        $relative = [IO.Path]::GetRelativePath($Root, $_.FullName).Replace([IO.Path]::DirectorySeparatorChar, '/')
                        "$relative=$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant())"
                    }
            )
            return $rows -join "`n"
        }
        function Invoke-KnowledgeTestChild {
            param(
                [Parameter(Mandatory = $true)][string[]] $Arguments,
                [string] $WorkingDirectory = $script:testRoot
            )
            $previousLocation = Get-Location
            try {
                Set-Location -LiteralPath $WorkingDirectory
                $output = @(& $script:pwshPath @Arguments 2>&1)
                $exitCode = $LASTEXITCODE
                return [pscustomobject]@{ exitCode = $exitCode; output = @($output) }
            }
            finally { Set-Location -LiteralPath $previousLocation }
        }
        $script:testRoot = Join-Path ([IO.Path]::GetTempPath()) ('syp154-report-' + [guid]::NewGuid().ToString('N'))
        $script:skillRoot = Join-Path $script:testRoot 'skills/demo'
        [void](New-Item -ItemType Directory -Path $script:skillRoot -Force)
        [IO.File]::WriteAllText((Join-Path $script:skillRoot 'SKILL.md'), '# Demo')
        $script:childPath = Join-Path $script:testRoot 'child.ps1'
        [IO.File]::WriteAllText($script:childPath, $script:childMatch.Groups['body'].Value)
        $script:fakeToolPath = Join-Path $script:testRoot 'skill-validator.ps1'
        [IO.File]::WriteAllText($script:fakeToolPath, 'Get-Content -LiteralPath $env:SYP154_TEST_TOOL_REPORT -Raw; $global:LASTEXITCODE = 0')
        $script:fakeStaticToolPath = Join-Path $script:testRoot 'skillspector.ps1'
        $script:fakeStaticFailureToolPath = Join-Path $script:testRoot 'skillspector-failure.cmd'
        $script:fakeStaticFailureChildPath = Join-Path $script:testRoot 'skillspector-failure-child.ps1'
        $fakeStaticTool = @'
[IO.File]::WriteAllText($env:SYP154_STATIC_ARGUMENTS, ($args | ConvertTo-Json -Compress), [Text.UTF8Encoding]::new($false))
$report = [ordered]@{
    execution_successful = $true
    analysis_completeness = [ordered]@{
        execution_successful = $true
        is_complete = $true
        status = 'complete'
        coverage_percent = 100
        ledger_exceptions = @()
        scope_exclusions = @()
        limitations = @()
    }
    skill = [ordered]@{ name = 'demo'; source = $env:SYP154_STATIC_SKILL_ROOT }
    components = @([ordered]@{ path = 'SKILL.md' })
    issues = @()
}
Write-Output ($report | ConvertTo-Json -Depth 10 -Compress)
$global:LASTEXITCODE = 0
'@
        [IO.File]::WriteAllText($script:fakeStaticToolPath, $fakeStaticTool, [Text.UTF8Encoding]::new($false))
        [IO.File]::WriteAllText($script:fakeStaticFailureChildPath, "[Console]::Error.WriteLine('SkillSpector fixture stderr diagnostic')`nexit 73", [Text.UTF8Encoding]::new($false))
        $fakeStaticFailureWrapper = @'
@echo off
"%SYP154_TEST_PWSH%" -NoProfile -NonInteractive -File "%~dp0skillspector-failure-child.ps1" %*
exit /b %ERRORLEVEL%
'@
        [IO.File]::WriteAllText($script:fakeStaticFailureToolPath, $fakeStaticFailureWrapper, [Text.UTF8Encoding]::new($false))
        if ([string]::IsNullOrWhiteSpace($env:SYP154_CANDIDATE_AUTHORITY_ROOT)) {
            # Run the actual candidate driver against its immutable authority,
            # including when the protected CI driver still uses an older pin.
            $repositoryRoot = Split-Path -Parent $PSScriptRoot
            $authority = (Get-Content -LiteralPath (Join-Path $repositoryRoot 'config/standard-v1.json') -Raw | ConvertFrom-Json).authority
            $archive = Join-Path $script:testRoot 'authority.zip'
            Invoke-WebRequest -Uri ([string]$authority.archiveUrl) -OutFile $archive -TimeoutSec 60
            if ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant() -cne [string]$authority.archiveSha256) {
                throw 'Integration authority archive identity differs from the candidate pin.'
            }
            $extract = Join-Path $script:testRoot 'authority'
            Expand-Archive -LiteralPath $archive -DestinationPath $extract
            $roots = @(Get-ChildItem -LiteralPath $extract -Directory)
            if ($roots.Count -ne 1) { throw 'Integration authority archive must contain one root.' }
            $moduleRoot = $roots[0].FullName
            foreach ($entry in @($authority.files)) {
                $path = Join-Path $moduleRoot ([string]$entry.path)
                if ((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant() -cne [string]$entry.sha256) {
                    throw "Integration authority file identity differs: $($entry.path)"
                }
            }
        }
        else { $moduleRoot = [string]$env:SYP154_CANDIDATE_AUTHORITY_ROOT }
        $script:runnerPath = Join-Path $moduleRoot 'scripts/Invoke-StandardValidation.ps1'
        $script:pwshPath = (Get-Command pwsh -CommandType Application | Select-Object -First 1).Source
        $script:priorEnv = @{}
        foreach ($name in @('STANDARD_VALIDATION_ACTIVE_SKILLS', 'STANDARD_VALIDATION_SKILLS_ROOT', 'STANDARD_VALIDATION_SKILL_ID', 'STANDARD_VALIDATION_CANDIDATE_ID', 'STANDARD_VALIDATION_CANDIDATE_ROOT', 'STANDARD_VALIDATION_SKILL_INVENTORY_SHA256', 'SYP154_TEST_TOOL_REPORT', 'SYP154_STATIC_ARGUMENTS', 'SYP154_STATIC_SKILL_ROOT', 'SYP154_TEST_PWSH', 'SYP154_CANDIDATE_AUTHORITY_ROOT')) {
            $script:priorEnv[$name] = [Environment]::GetEnvironmentVariable($name)
        }
        $env:SYP154_TEST_PWSH = $script:pwshPath
        $env:STANDARD_VALIDATION_ACTIVE_SKILLS = 'demo'
        $env:STANDARD_VALIDATION_SKILLS_ROOT = Join-Path $script:testRoot 'skills'
        $env:STANDARD_VALIDATION_SKILL_ID = 'demo'
        $env:STANDARD_VALIDATION_CANDIDATE_ID = ('a' * 64)
        $env:STANDARD_VALIDATION_CANDIDATE_ROOT = $script:testRoot
        $env:STANDARD_VALIDATION_SKILL_INVENTORY_SHA256 = ('b' * 64)
        $toolchain = [ordered]@{
            centralRunnerPath = $script:runnerPath
            centralRunnerSha256 = if (Test-Path -LiteralPath $script:runnerPath -PathType Leaf) { (Get-FileHash -Algorithm SHA256 -LiteralPath $script:runnerPath).Hash.ToLowerInvariant() } else { '0' * 64 }
            skillValidatorPath = $script:fakeToolPath
            skillValidatorSha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $script:fakeToolPath).Hash.ToLowerInvariant()
        }
        $script:toolchainPath = Join-Path $script:testRoot 'toolchain.json'
        [IO.File]::WriteAllText($script:toolchainPath, ($toolchain | ConvertTo-Json -Compress))
        $script:toolchainHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $script:toolchainPath).Hash.ToLowerInvariant()
        $script:candidateFingerprintBefore = Get-KnowledgeCandidateBytesFingerprint -Root $script:candidateRoot
    }

    BeforeEach {
        $toolchain = [ordered]@{
            centralRunnerPath = $script:runnerPath
            centralRunnerSha256 = (Get-FileHash -LiteralPath $script:runnerPath -Algorithm SHA256).Hash.ToLowerInvariant()
            skillValidatorPath = $script:fakeToolPath
            skillValidatorSha256 = (Get-FileHash -LiteralPath $script:fakeToolPath -Algorithm SHA256).Hash.ToLowerInvariant()
        }
        [IO.File]::WriteAllText($script:toolchainPath, ($toolchain | ConvertTo-Json -Compress))
        $script:toolchainHash = (Get-FileHash -LiteralPath $script:toolchainPath -Algorithm SHA256).Hash.ToLowerInvariant()
    }

    AfterAll {
        foreach ($name in $script:priorEnv.Keys) { [Environment]::SetEnvironmentVariable($name, $script:priorEnv[$name]) }
        $expectedParent = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd([IO.Path]::DirectorySeparatorChar)
        $actualParent = [IO.Path]::GetFullPath((Split-Path -Parent $script:testRoot)).TrimEnd([IO.Path]::DirectorySeparatorChar)
        if ($actualParent -cne $expectedParent -or (Split-Path -Leaf $script:testRoot) -cnotmatch '^syp154-report-[0-9a-f]{32}$') {
            throw 'Integration test cleanup root is not the allocated temporary directory.'
        }
        $candidateRootChanged = (Get-KnowledgeCandidateBytesFingerprint -Root $script:candidateRoot) -cne $script:candidateFingerprintBefore
        Remove-Item -LiteralPath $script:testRoot -Recurse -Force
        if ($candidateRootChanged) { throw 'Native report integration tests changed candidate-root file bytes or inventory.' }
    }

    # Scenario: a package tool emits a success report with a string error count.
    # Purpose: the Knowledge child must reject malformed counts through the shared authority rule.
    It 'InterT10_rejects_string_error_count_from_the_real_Knowledge_child' {
        $reportPath = Join-Path $script:testRoot 'report.json'
        [IO.File]::WriteAllText($reportPath, (@{ skill_dir = $script:skillRoot; passed = $true; errors = '0'; warnings = 0; results = @(@{ level = 'pass'; file = 'SKILL.md' }) } | ConvertTo-Json -Depth 10 -Compress))
        $env:SYP154_TEST_TOOL_REPORT = $reportPath
        $child = Invoke-KnowledgeTestChild -Arguments @('-NoProfile', '-NonInteractive', '-File', $script:childPath, '-Mode', 'skill-validator', '-ToolchainPath', $script:toolchainPath, '-ToolchainSha256', $script:toolchainHash)
        $child.exitCode | Should -Be 1
        ($child.output -join "`n") | Should -Match 'typed nonnegative integer'
        Test-Path -LiteralPath (Join-Path $script:testRoot 'native-skill-validator-demo.json') | Should -BeTrue
    }

    # Scenario: the same candidate-bound tool returns typed zero counts.
    # Purpose: the shared report rule must allow the normal Knowledge envelope path.
    It 'InterT20_accepts_typed_zero_counts_through_the_real_Knowledge_child' {
        $reportPath = Join-Path $script:testRoot 'report.json'
        [IO.File]::WriteAllText($reportPath, (@{ skill_dir = $script:skillRoot; passed = $true; errors = 0; warnings = 0; results = @(@{ level = 'pass'; file = 'SKILL.md' }) } | ConvertTo-Json -Depth 10 -Compress))
        $env:SYP154_TEST_TOOL_REPORT = $reportPath
        $child = Invoke-KnowledgeTestChild -Arguments @('-NoProfile', '-NonInteractive', '-File', $script:childPath, '-Mode', 'skill-validator', '-ToolchainPath', $script:toolchainPath, '-ToolchainSha256', $script:toolchainHash)
        $child.exitCode | Should -Be 0 -Because ($child.output -join "`n")
        $envelope = ($child.output -join "`n") | ConvertFrom-Json -Depth 10
        $envelope.decision | Should -Be 'PASS'
        $envelope.candidateIdentity | Should -Be ('a' * 64)
        Test-Path -LiteralPath (Join-Path $script:testRoot 'native-skill-validator-demo.json') | Should -BeTrue
    }

    # Scenario: a clean report belongs to a neighboring candidate root.
    # Purpose: the actual candidate child must reject a report from another Skill.
    It 'InterT25_rejects_wrong_root_through_the_real_Knowledge_child' {
        $wrongRoot = Join-Path $script:testRoot 'skills/neighbor'
        [void](New-Item -ItemType Directory -Path $wrongRoot -Force)
        $reportPath = Join-Path $script:testRoot 'report.json'
        [IO.File]::WriteAllText($reportPath, (@{ skill_dir = $wrongRoot; passed = $true; errors = 0; warnings = 0; results = @(@{ level = 'pass'; file = 'SKILL.md' }) } | ConvertTo-Json -Depth 10 -Compress))
        $env:SYP154_TEST_TOOL_REPORT = $reportPath
        $child = Invoke-KnowledgeTestChild -Arguments @('-NoProfile', '-NonInteractive', '-File', $script:childPath, '-Mode', 'skill-validator', '-ToolchainPath', $script:toolchainPath, '-ToolchainSha256', $script:toolchainHash)
        $child.exitCode | Should -Be 1
        ($child.output -join "`n") | Should -Match 'report root does not match candidate Skill'
        Test-Path -LiteralPath (Join-Path $script:testRoot 'native-skill-validator-demo.json') | Should -BeTrue
    }

    # Scenario: the same report is supplied with a forged central runner digest.
    # Purpose: a candidate cannot substitute an unverified shared validator and still receive PASS.
    It 'InterT30_rejects_a_mismatched_central_runner_before_tool_execution' {
        $reportPath = Join-Path $script:testRoot 'report.json'
        [IO.File]::WriteAllText($reportPath, (@{ skill_dir = $script:skillRoot; passed = $true; errors = 0; warnings = 0; results = @(@{ level = 'pass'; file = 'SKILL.md' }) } | ConvertTo-Json -Depth 10 -Compress))
        $env:SYP154_TEST_TOOL_REPORT = $reportPath
        $toolchain = Get-Content -LiteralPath $script:toolchainPath -Raw | ConvertFrom-Json
        $toolchain.centralRunnerSha256 = '0' * 64
        [IO.File]::WriteAllText($script:toolchainPath, ($toolchain | ConvertTo-Json -Compress))
        $forgedToolchainHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $script:toolchainPath).Hash.ToLowerInvariant()
        $child = Invoke-KnowledgeTestChild -Arguments @('-NoProfile', '-NonInteractive', '-File', $script:childPath, '-Mode', 'skill-validator', '-ToolchainPath', $script:toolchainPath, '-ToolchainSha256', $forgedToolchainHash)
        $child.exitCode | Should -Be 1
        ($child.output -join "`n") | Should -Match 'central validation runner changed or is missing'
    }

    # Scenario: SkillSpector v2.13.3 only emits its JSON report to stdout.
    # Purpose: require a new stdout report file and forbid the removed --output argument.
    It 'InterT35_captures_the_SkillSpector_stdout_report_without_the_removed_output_argument' {
        $staticWorkingRoot = Join-Path $script:testRoot 'static-success'
        [void](New-Item -ItemType Directory -Path $staticWorkingRoot)
        $argumentsPath = Join-Path $staticWorkingRoot 'skillspector-arguments.json'
        $reportPath = Join-Path $staticWorkingRoot 'skillspector-demo.json'
        Test-Path -LiteralPath $reportPath | Should -BeFalse
        $env:SYP154_STATIC_ARGUMENTS = $argumentsPath
        $env:SYP154_STATIC_SKILL_ROOT = $script:skillRoot
        $toolchain = [ordered]@{
            skillSpectorPath = $script:fakeStaticToolPath
            skillSpectorSha256 = (Get-FileHash -LiteralPath $script:fakeStaticToolPath -Algorithm SHA256).Hash.ToLowerInvariant()
        }
        [IO.File]::WriteAllText($script:toolchainPath, ($toolchain | ConvertTo-Json -Compress), [Text.UTF8Encoding]::new($false))
        $toolchainHash = (Get-FileHash -LiteralPath $script:toolchainPath -Algorithm SHA256).Hash.ToLowerInvariant()

        $child = Invoke-KnowledgeTestChild -WorkingDirectory $staticWorkingRoot -Arguments @('-NoProfile', '-NonInteractive', '-File', $script:childPath, '-Mode', 'static', '-ToolchainPath', $script:toolchainPath, '-ToolchainSha256', $toolchainHash)

        $child.exitCode | Should -Be 0 -Because ($child.output -join "`n")
        Test-Path -LiteralPath $reportPath -PathType Leaf | Should -BeTrue
        $report = Get-Content -LiteralPath $reportPath -Raw | ConvertFrom-Json -Depth 20
        $report.execution_successful | Should -BeTrue
        $recordedArguments = @(Get-Content -LiteralPath $argumentsPath -Raw | ConvertFrom-Json -Depth 20)
        (@($recordedArguments) -join "`n") | Should -BeExactly (@('scan', $script:skillRoot, '--no-llm', '--format', 'json') -join "`n")
        $recordedArguments | Should -Not -Contain '--output'
        $envelope = ($child.output -join "`n") | ConvertFrom-Json -Depth 20
        $nativeReport = @($envelope.nativeReports)[0]
        $nativeReport.path | Should -BeExactly ([IO.Path]::GetFullPath($reportPath))
        $nativeReport.sha256 | Should -BeExactly ((Get-FileHash -LiteralPath $reportPath -Algorithm SHA256).Hash.ToLowerInvariant())
    }

    # Scenario: SkillSpector returns a nonzero exit code after writing a native stderr diagnostic.
    # Purpose: preserve bounded native diagnostics in the static-stage failure message.
    It 'InterT36_reports_SkillSpector_stderr_when_the_static_scan_fails' {
        $staticWorkingRoot = Join-Path $script:testRoot 'static-failure'
        [void](New-Item -ItemType Directory -Path $staticWorkingRoot)
        $toolchain = [ordered]@{
            skillSpectorPath = $script:fakeStaticFailureToolPath
            skillSpectorSha256 = (Get-FileHash -LiteralPath $script:fakeStaticFailureToolPath -Algorithm SHA256).Hash.ToLowerInvariant()
        }
        [IO.File]::WriteAllText($script:toolchainPath, ($toolchain | ConvertTo-Json -Compress), [Text.UTF8Encoding]::new($false))
        $toolchainHash = (Get-FileHash -LiteralPath $script:toolchainPath -Algorithm SHA256).Hash.ToLowerInvariant()

        $child = Invoke-KnowledgeTestChild -WorkingDirectory $staticWorkingRoot -Arguments @('-NoProfile', '-NonInteractive', '-File', $script:childPath, '-Mode', 'static', '-ToolchainPath', $script:toolchainPath, '-ToolchainSha256', $toolchainHash)

        $child.exitCode | Should -Be 1
        ($child.output -join "`n") | Should -Match 'SkillSpector fixture stderr diagnostic'
    }

    # Scenario: the reviewed new authority input is supplied to the actual candidate driver guard.
    # Purpose: prove the extracted real driver guard accepts a valid pin before
    # counting its rejection cases as coverage.
    It 'UnitT35_accepts_exact_candidate_authority_config' {
        $config = Get-Content -LiteralPath (Join-Path (Split-Path -Parent $PSScriptRoot) 'config/standard-v1.json') -Raw | ConvertFrom-Json
        & {
            param($DriverPrefix, $CandidateConfig)
            . ([scriptblock]::Create($DriverPrefix))
            Assert-AuthorityConfig -Config $CandidateConfig
        } $script:driverPrefix $config
    }

    # Scenario: candidate authority config substitutes commit, archive or member identity.
    # Purpose: exercise the driver's actual strict guard without acquiring any tools.
    It 'UnitT40_rejects_wrong_authority_archive_or_member_<Field>' -TestCases @(
        @{ Field = 'commit' }, @{ Field = 'archiveSha256' }, @{ Field = 'member' },
        @{ Field = 'obsoleteRevision' },
        @{ Field = 'scripts/Resolve-PythonWheelClosure.py' },
        @{ Field = 'scripts/Resolve-StandardValidationTool.ps1' },
        @{ Field = 'docs/standards/standard-validation-contract-v1.json' },
        @{ Field = 'scripts/Invoke-StandardValidation.ps1' }
    ) {
        param($Field)
        $config = Get-Content -LiteralPath (Join-Path (Split-Path -Parent $PSScriptRoot) 'config/standard-v1.json') -Raw | ConvertFrom-Json
        if ($Field -eq 'obsoleteRevision') {
            $config.authority.commit = '7c65254d96bd21083ae827e54b9e51afee8ce304'
            $config.authority.archiveUrl = 'https://codeload.github.com/SyuanTsai/SyuanTsai-AI-Instructions/zip/7c65254d96bd21083ae827e54b9e51afee8ce304'
            $config.authority.archiveSha256 = '093e511b8ca9d2618d74d42a5ed831a54524bb133cba9f310b33e7a107a6ff9d'
        }
        elseif ($Field.Contains('/')) { ($config.authority.files | Where-Object path -CEQ $Field).sha256 = '0' * 64 }
        elseif ($Field -eq 'member') { $config.authority.files[0].sha256 = '0' * 64 }
        elseif ($Field -eq 'commit') { $config.authority.commit = '0' * 40 }
        else { $config.authority.archiveSha256 = '0' * 64 }
        Assert-TestThrowsLike {
            & {
                param($DriverPrefix, $CandidateConfig)
                . ([scriptblock]::Create($DriverPrefix))
                Assert-AuthorityConfig -Config $CandidateConfig
            } $script:driverPrefix $config
        } $(if ($Field -eq 'member' -or $Field.Contains('/')) { '*authority file identity mismatch*' } else { '*exact approved P02 authority snapshot*' })
    }
}
