# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
function Assert-TestThrowsLike {
    param([Parameter(Mandatory = $true)][scriptblock] $ScriptBlock, [Parameter(Mandatory = $true)][string] $Pattern)

    $caught = $null
    try { & $ScriptBlock }
    catch { $caught = $_ }
    $caught | Should -Not -BeNullOrEmpty
    ([string]$caught.Exception.Message) | Should -BeLike $Pattern
}

Describe 'Knowledge & Content Standard v1 reference implementation' {
    BeforeAll {
        $script:RepositoryRoot = Split-Path -Parent $PSScriptRoot
        $script:SourceInventoryPath = Join-Path $script:RepositoryRoot 'catalog/source.json'
        $script:AdapterPath = Join-Path $script:RepositoryRoot 'config/standard-v1.json'
        $script:CanonicalValidatorPath = Join-Path $script:RepositoryRoot 'scripts/Validate.ps1'
    }

    It 'uses the canonical skills source root and schema v2 inventory' {
        Test-Path -LiteralPath (Join-Path $script:RepositoryRoot 'skills') -PathType Container | Should -BeTrue
        Test-Path -LiteralPath (Join-Path $script:RepositoryRoot '.agents/skills') | Should -BeFalse
        Test-Path -LiteralPath $script:SourceInventoryPath -PathType Leaf | Should -BeTrue

        $inventory = Get-Content -LiteralPath $script:SourceInventoryPath -Raw | ConvertFrom-Json
        @($inventory.PSObject.Properties.Name) | Should -Be @(
            'schemaVersion', 'sourceId', 'repository', 'skillsRoot', 'skills'
        )
        $inventory.schemaVersion | Should -Be 2
        $inventory.sourceId | Should -Be 'knowledge-content'
        $inventory.repository | Should -Be 'https://github.com/SyuanTsai/Skill-Knowledge-Content.git'
        $inventory.skillsRoot | Should -Be 'skills'
        @($inventory.skills) | Should -Be @(
            'capture-private-course-knowledge'
        )
    }

    # Scenario: The Knowledge config is read from the extracted candidate.
    # Purpose: Keep one immutable authority snapshot and its complete required inventory.
    It 'UnitT10_pins_immutable_authority_and_required_inventory' {
        Test-Path -LiteralPath $script:AdapterPath -PathType Leaf | Should -BeTrue
        $adapter = Get-Content -LiteralPath $script:AdapterPath -Raw | ConvertFrom-Json

        $adapter.schemaVersion | Should -Be 1
        $adapter.standardVersion | Should -Be 'v1'
        $adapter.authority.repository | Should -Be 'https://github.com/SyuanTsai/SyuanTsai-AI-Instructions.git'
        $adapter.authority.commit | Should -Be '2f249f5c1acdb1e7b9eb03180a709d85408e9ac0'
        $adapter.authority.archiveSha256 | Should -Be 'a6c1ea639ec37ebc2fb754c4bfff1055d4eb3264dfd358472d5f24c57e5933ae'
        @($adapter.PSObject.Properties.Name) | Should -Not -Contain 'security'
        @($adapter.authority.files).Count | Should -Be 49
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/standard-core-validation-v2.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/schemas/standard-core-adapter-v2.schema.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/schemas/standard-core-evidence-v2.schema.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/third-party-raw-skill-sources.md'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/schemas/third-party-raw-skill-source-v1.schema.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/examples/third-party-raw-skill-source-v1.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/README.md'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/managed-skill-lifecycle.md'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/schemas/managed-skill-lifecycle-v1.schema.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/skill-repository-standard.md'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/skill-repository-review-matrix.md'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/upstream-interoperability.md'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/validation-security-gate.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/validation-toolchain.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/schemas/source-inventory-v2.schema.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/schemas/openai-agent-metadata.schema.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/schemas/validation-security-gate-v1.schema.json'
        @($adapter.authority.files.path) | Should -Contain 'scripts/Invoke-StandardAuthorityGate.ps1'
        @($adapter.authority.files.path) | Should -Contain 'scripts/Resolve-StandardValidationTool.ps1'
        @($adapter.authority.files.path) | Should -Contain 'scripts/Resolve-PythonWheelClosure.py'
        @($adapter.authority.files.path) | Should -Contain 'scripts/Invoke-StandardValidation.ps1'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/standard-validation-contract-v1.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/schemas/standard-validation-adapter-v1.schema.json'
        @($adapter.authority.files.path) | Should -Contain 'docs/standards/static-parser-host-ownership.json'
        @($adapter.authority.files.path) | Should -Contain 'scripts/platform-runtime.psd1'
        @($adapter.authority.files.path) | Should -Contain 'scripts/platform-runtime.psm1'
        @($adapter.authority.files.path | Where-Object { $_ -like 'scripts/platform/*' }).Count | Should -BeGreaterThan 0
        @($adapter.authority.files | Where-Object { $_.sha256 -notmatch '^[0-9a-f]{64}$' }).Count | Should -Be 0
        $adapter.PSObject.Properties.Name | Should -Not -Contain 'deviations'
    }

    It 'exposes one canonical validator for local and CI execution' {
        Test-Path -LiteralPath $script:CanonicalValidatorPath -PathType Leaf | Should -BeTrue
        $validator = Get-Content -LiteralPath $script:CanonicalValidatorPath -Raw
        $validator | Should -Match 'Invoke-StandardValidation\.ps1'
        $validator | Should -Match '-DevelopmentHarness'
        $validator | Should -Match 'standard-validation-adapter\.json'
        $validator | Should -Match 'repository-test-knowledge'
        $validator | Should -Match 'repository-test-pester'
        $validator | Should -Not -Match 'deviations\s*='
    }

    It 'runs repository smoke validation against an extracted snapshot' {
        # Scenario: the central runner executes repository regression in a candidate without .git metadata.
        # Purpose: keep the smoke test on the read-only snapshot path instead of requiring a local Git index.
        $repositoryTests = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'tests/repository.Tests.ps1') -Raw
        $repositoryTests | Should -Match 'Test-Repository\.ps1''\)\s+-ReadOnlySnapshot'
    }

    # Scenario: the protected workflow receives PR, push, or manual-dispatch events on three platforms.
    # Purpose: bind every leg and aggregate to exact identities while retaining the existing required contexts.
    It 'UnitT50_routes_protected_source_CI_through_the_canonical_validator' {
        $workflowPath = Join-Path $script:RepositoryRoot '.github/workflows/validate.yml'
        $workflow = Get-Content -LiteralPath $workflowPath -Raw

        $workflow | Should -Match 'scripts/Validate\.ps1'
        $workflow | Should -Match 'fail-fast:\s*false'
        @([regex]::Matches($workflow, '(?m)^\s+- os:\s*(windows-latest|ubuntu-latest|macos-latest)\s*$')).Count | Should -Be 3
        foreach ($entry in @(
            @{ Os = 'windows-latest'; Platform = 'windows'; Arch = 'x64' },
            @{ Os = 'ubuntu-latest'; Platform = 'linux'; Arch = 'x64' },
            @{ Os = 'macos-latest'; Platform = 'macos'; Arch = 'arm64' }
        )) {
            $workflow | Should -Match ("(?ms)- os:\s+{0}.*?platform:\s+{1}.*?architecture:\s+{2}" -f $entry.Os, $entry.Platform, $entry.Arch)
        }
        $workflow | Should -Match 'name:\s*Knowledge & Content Standard v1 \(\$\{\{ matrix\.platform \}\}\)'
        $workflow | Should -Match 'timeout-minutes:\s*60'
        $workflow | Should -Match 'ref:\s+2f249f5c1acdb1e7b9eb03180a709d85408e9ac0'
        $workflow | Should -Match '(?s)Preserve committed bytes before checkout.*?core\.autocrlf false.*?Checkout exact event candidate'
        $workflow | Should -Match 'Checkout exact event-base protected driver'
        $workflow | Should -Match 'Protected driver HEAD differs from the exact event base SHA'
        $workflow | Should -Match 'Protected driver checkout is not clean'
        $workflow | Should -Match 'Protected source helper raw bytes differ from the exact event-base Git blob'
        $workflow | Should -Match 'git_command_path=\$gitCommandPath'
        $workflow | Should -Match 'EXPECTED_GIT_COMMAND_PATH:'
        $workflow | Should -Match 'ResolveLinkTarget\(\$CommandPath, \$true\)'
        $workflow | Should -Match 'nodeCommandPath = \$nodeCommandPath'
        $workflow | Should -Match 'npmCommandPath = \$npmCommandPath'
        $workflow | Should -Match 'Approved Node runtime physical executable bytes changed after capture'
        $workflow | Should -Match 'SETUP_PYTHON_ACTION_REFERENCE:\s+&setup-python-action-reference\s+actions/setup-python@6d4fd22b20465ccc0f7354476588e8df7c9ca0e0'
        $pythonSetupStep = [regex]::Match($workflow, '(?ms)^      - name: Set up approved Python runtime\r?\n(?<body>.*?)(?=^      - name:|\z)')
        $pythonSetupStep.Success | Should -BeTrue
        $pythonSetupStep.Groups['body'].Value | Should -Match '(?m)^        uses:\s+\*setup-python-action-reference\s+# v7\.1\.0\r?$'
        $pythonSetupStep.Groups['body'].Value | Should -Match "(?m)^          python-version:\s+'3\.12'\s*$"
        $pythonSetupStep.Groups['body'].Value | Should -Match '(?m)^          check-latest:\s+false\s*$'
        $pythonSetupStep.Groups['body'].Value | Should -Not -Match '(?m)^\s+cache:'
        $workflow | Should -Match 'python-runtime-before-source-setup\.json'
        $workflow | Should -Match "pythonVersion = \[string\]\$pythonEvidence\.pythonVersion"
        $workflow | Should -Match 'receipt has no approved Python 3\.12 version'
        $workflow | Should -Match 'Python major\.minor differs across platform receipts'
        $workflow | Should -Match "Required workflow value '\$requiredName' is missing before final source evidence verification"
        $workflow | Should -Not -Match '\$matches\s*='
        $workflow | Should -Match '\$ownedRoot = Join-Path \$env:RUNNER_TEMP "kc-\$runNonce"'
        $workflow | Should -Match 'Join-Path \$env:RUNNER_TEMP "a-\$runNonce"'
        $workflow | Should -Match 'Prepare-WorkflowPowerShell\.ps1''\) -Mode Resolve'
        $workflow | Should -Match 'Prepare-WorkflowPowerShell\.ps1''\) -Mode Install'
        $workflow | Should -Match 'Prepare-WorkflowPowerShell\.ps1''\) -Mode Verify'
        $resolvePowerShellStep = [regex]::Match($workflow, '(?ms)^      - name: Resolve latest official PowerShell release metadata\r?\n(?<body>.*?)(?=^      - name:|\z)')
        $resolvePowerShellStep.Success | Should -BeTrue
        $resolvePowerShellStep.Groups['body'].Value | Should -Match '(?m)^          KC_GITHUB_API_TOKEN: \$\{\{ github\.token \}\}\r?$'
        @([regex]::Matches($workflow, '(?m)^\s+KC_GITHUB_API_TOKEN:')).Count | Should -Be 1
        $workflow | Should -Match 'scripts/Prepare-PesterRuntime\.ps1'
        $workflow | Should -Match 'KC_PESTER_PACKAGE_CACHE'
        $workflow | Should -Match 'hashFiles\(''driver/config/pester-\*-closure\.lock\.json''\)'
        $workflow | Should -Match 'kc-leg-receipt-\$\{\{ matrix\.platform \}\}-\$\{\{ github\.run_id \}\}-\$\{\{ github\.run_attempt \}\}'
        $workflow | Should -Match '(?ms)^  canonical-aggregate:.*?runs-on:\s+ubuntu-latest.*?needs:\s+canonical-validation.*?if:\s+\$\{\{ always\(\) \}\}'
        $workflow | Should -Match 'Platform ''\$platform'' must have exactly one receipt'
        $workflow | Should -Match 'GITHUB_STEP_SUMMARY'
        $workflow | Should -Not -Match '(?m)^\s*(Install-Module|npm install|go install|pip install)\b'

        $powerShellPreparer = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'scripts/Prepare-WorkflowPowerShell.ps1') -Raw
        $powerShellPreparer | Should -Match 'Discarded invalid PowerShell cache entry'
        $powerShellPreparer | Should -Match 'mandatory post-cache verification'
        $powerShellPreparer | Should -Match 'Get-AuthenticodeSignature'
        $powerShellPreparer | Should -Match 'Resolve-WorkflowPhysicalPath'
        $powerShellPreparer | Should -Match '@\(Get-ChildItem -LiteralPath \$Path -Force\)\.Count'
        $powerShellPreparer | Should -Not -Match '\$matches\s*='
        $powerShellPreparer | Should -Not -Match '\$home\s*='
        $powerShellPreparer | Should -Match '\$pshomeExecutable = Resolve-WorkflowPhysicalPath'
        $powerShellPreparer | Should -Match 'pshome=\$pshomeExecutable'
        $powerShellPreparer | Should -Match '\$releaseUri\.Host -ceq ''api\.github\.com'''
        $powerShellPreparer | Should -Match '\$metadataHeaders\.Authorization = "Bearer \$\(\$env:KC_GITHUB_API_TOKEN\)"'
        $powerShellPreparer | Should -Match '\$attempt -le 3'
        $powerShellPreparer | Should -Match '\$statusCode -eq 403 -or \$statusCode -eq 429 -or \$statusCode -ge 500'
        $powerShellPreparer | Should -Match '\$finalUri\.Host -cne ''api\.github\.com'''
        $powerShellPreparer | Should -Not -Match 'Invoke-WebRequest -Uri \(\[string\]\$hashAssets\[0\]\.browser_download_url\).*?-Headers'
        (Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'scripts/StandardCoreSourceValidation.ps1') -Raw) | Should -Not -Match '\$matches\s*='
        $pesterPreparer = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'scripts/Prepare-PesterRuntime.ps1') -Raw
        $pesterPreparer | Should -Match 'Test-CorePesterPackageArchive -ArchivePath \$cacheArchivePath'
        $pesterPreparer | Should -Match 'Discarded invalid cached Pester package'
        $pesterPreparer | Should -Match 'Fresh Pester cache copy failed closure verification'

        $anchors = @{}
        foreach ($anchorMatch in [regex]::Matches($workflow, '(?m)^\s+[A-Z_]+:\s+&(?<name>[a-z-]+)\s+(?<action>[^\s#]+)')) {
            $anchors[$anchorMatch.Groups['name'].Value] = $anchorMatch.Groups['action'].Value
            $anchorMatch.Groups['action'].Value | Should -Match '^[^@\s]+@[0-9a-f]{40}$'
        }
        foreach ($usesMatch in [regex]::Matches($workflow, '(?m)^\s+uses:\s+(?<reference>[^\s#]+)')) {
            $reference = $usesMatch.Groups['reference'].Value
            if ($reference.StartsWith('*', [StringComparison]::Ordinal)) {
                $anchors.ContainsKey($reference.Substring(1)) | Should -BeTrue
            }
            else {
                $reference | Should -Match '^[^@\s]+@[0-9a-f]{40}$'
            }
        }

        $checkoutBlocks = @([regex]::Matches($workflow, '(?ms)^\s+- name:\s+Checkout .*?(?=^\s+- name:|^  [a-z][a-z0-9-]*:|\z)'))
        $checkoutBlocks.Count | Should -Be 3
        foreach ($checkout in $checkoutBlocks) {
            $checkout.Value | Should -Match 'persist-credentials:\s*false'
        }

        foreach ($context in @('repository-contract', 'skill-validator', 'skill-tools')) {
            $job = [regex]::Match($workflow, "(?ms)^  $([regex]::Escape($context)):\s+.*?(?=^  [a-z][a-z0-9-]*:|\z)").Value
            $job | Should -Match "(?m)^    name:\s+$([regex]::Escape($context))\s*$"
            $job | Should -Match 'needs:\s*\[canonical-validation, canonical-aggregate\]'
            $job | Should -Match 'runs-on:\s+ubuntu-latest'
            $job | Should -Not -Match 'uses:'
            $job | Should -Match "needs\['canonical-validation'\]\.result"
            $job | Should -Match 'needs\.canonical-aggregate\.result'
        }
    }

    # Scenario: the verified PowerShell runtime root exists but contains no entries under strict mode.
    # Purpose: protect the empty-enumeration boundary that previously raised a property-binding error.
    It 'UnitT52_accepts_an_empty_fresh_PowerShell_runtime_root' {
        $preparerPath = Join-Path $script:RepositoryRoot 'scripts/Prepare-WorkflowPowerShell.ps1'
        . $preparerPath -Mode Verify -Platform $(if ($IsWindows) { 'windows' } elseif ($IsMacOS) { 'macos' } else { 'linux' }) `
            -ExpectedArchitecture ([Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant()) `
            -ExecutableName $(if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' }) -DefineFunctionsOnly
        $emptyRuntimeRoot = Join-Path $TestDrive 'empty-powershell-runtime'
        [void](New-Item -ItemType Directory -Path $emptyRuntimeRoot -Force)

        { Assert-WorkflowRuntimeRootEmpty -Path $emptyRuntimeRoot } | Should -Not -Throw
        [IO.File]::WriteAllText((Join-Path $emptyRuntimeRoot 'unexpected.txt'), 'unexpected')
        { Assert-WorkflowRuntimeRootEmpty -Path $emptyRuntimeRoot } | Should -Throw '*fresh and empty*'
    }

    # Scenario: candidate source steps may rewrite environment state and the driver checkout before final verification.
    # Purpose: execute the exact final binding guard against a real Git checkout and reject drift before importing its helper.
    It 'UnitT55_binds_the_final_protected_helper_to_immutable_workflow_outputs' {
        $workflowPath = Join-Path $script:RepositoryRoot '.github/workflows/validate.yml'
        $workflow = Get-Content -LiteralPath $workflowPath -Raw
        $beginMarker = '          # PROTECTED_SOURCE_BINDING_GUARD_BEGIN'
        $endMarker = '          # PROTECTED_SOURCE_BINDING_GUARD_END'
        $guardStart = $workflow.IndexOf($beginMarker, [StringComparison]::Ordinal)
        $guardEnd = $workflow.IndexOf($endMarker, $guardStart, [StringComparison]::Ordinal)
        $guardStart | Should -BeGreaterThan -1
        $guardEnd | Should -BeGreaterThan $guardStart
        $guardText = $workflow.Substring($guardStart, $guardEnd - $guardStart) -replace '(?m)^ {10}', ''
        $guardScript = [ScriptBlock]::Create($guardText + "`n[IO.Path]::GetFullPath(`$protectedHelperPath)")

        $gitCommand = Get-Command git -CommandType Application -ErrorAction Stop | Select-Object -First 1
        $gitPath = [IO.Path]::GetFullPath([string]$gitCommand.Path)
        $fixtureRoot = Join-Path $TestDrive 'protected-source-binding'
        $workspaceRoot = Join-Path $fixtureRoot 'workspace'
        $candidateRoot = Join-Path $workspaceRoot 'candidate'
        $driverRoot = Join-Path $workspaceRoot 'driver'
        $authorityRoot = Join-Path $workspaceRoot 'authority'
        $runnerTemp = Join-Path $fixtureRoot 'runner-temp'
        foreach ($directory in @($candidateRoot, $authorityRoot, $runnerTemp)) {
            [void](New-Item -ItemType Directory -Path $directory -Force)
        }

        & $gitPath -C $candidateRoot init --quiet
        if ($LASTEXITCODE -ne 0) { throw 'Could not initialize the protected source-binding fixture repository.' }
        & $gitPath -C $candidateRoot config user.name 'Conformance Fixture'
        if ($LASTEXITCODE -ne 0) { throw 'Could not configure the protected source-binding fixture repository.' }
        & $gitPath -C $candidateRoot config user.email 'fixture@example.invalid'
        if ($LASTEXITCODE -ne 0) { throw 'Could not configure the protected source-binding fixture repository.' }
        & $gitPath -C $candidateRoot config core.autocrlf false
        if ($LASTEXITCODE -ne 0) { throw 'Could not disable line-ending conversion in the protected source-binding fixture.' }
        & $gitPath -C $candidateRoot config core.longpaths true
        if ($LASTEXITCODE -ne 0) { throw 'Could not enable long paths in the protected source-binding fixture.' }
        $helperRelativePath = 'scripts/StandardCoreSourceValidation.ps1'
        $helperPath = Join-Path $candidateRoot $helperRelativePath
        [void](New-Item -ItemType Directory -Path (Split-Path -Parent $helperPath) -Force)
        $helperBytes = "# protected fixture helper`n"
        [IO.File]::WriteAllText($helperPath, $helperBytes, [Text.UTF8Encoding]::new($false))
        [IO.File]::WriteAllText((Join-Path $candidateRoot 'README.md'), "base`n", [Text.UTF8Encoding]::new($false))
        & $gitPath -C $candidateRoot add --all
        if ($LASTEXITCODE -ne 0) { throw 'Could not stage the protected source-binding fixture base.' }
        & $gitPath -C $candidateRoot commit --quiet -m 'fixture base'
        if ($LASTEXITCODE -ne 0) { throw 'Could not create the protected source-binding fixture base.' }
        $baseCommit = ([string](& $gitPath -C $candidateRoot rev-parse --verify 'HEAD^{commit}')).Trim()
        if ($LASTEXITCODE -ne 0) { throw 'Could not resolve the protected source-binding fixture base.' }
        [IO.File]::WriteAllText((Join-Path $candidateRoot 'README.md'), "candidate`n", [Text.UTF8Encoding]::new($false))
        & $gitPath -C $candidateRoot add --all
        if ($LASTEXITCODE -ne 0) { throw 'Could not stage the protected source-binding fixture candidate.' }
        & $gitPath -C $candidateRoot commit --quiet -m 'fixture candidate'
        if ($LASTEXITCODE -ne 0) { throw 'Could not create the protected source-binding fixture candidate.' }
        $headCommit = ([string](& $gitPath -C $candidateRoot rev-parse --verify 'HEAD^{commit}')).Trim()
        if ($LASTEXITCODE -ne 0) { throw 'Could not resolve the protected source-binding fixture candidate.' }
        & $gitPath -c core.autocrlf=false -c core.longpaths=true clone --quiet $candidateRoot $driverRoot
        if ($LASTEXITCODE -ne 0) { throw 'Could not clone the protected source-binding fixture driver.' }
        & $gitPath -C $driverRoot config --local core.longpaths true
        if ($LASTEXITCODE -ne 0) { throw 'Could not enable long paths in the protected source-binding driver fixture.' }
        & $gitPath -C $driverRoot checkout --quiet --detach $baseCommit
        if ($LASTEXITCODE -ne 0) { throw 'Could not check out the exact protected source-binding fixture base.' }

        $environmentNames = @(
            'PROTECTED_GITHUB_WORKSPACE', 'PROTECTED_RUNNER_TEMP', 'EXPECTED_EVENT_HEAD', 'EXPECTED_EVENT_BASE',
            'EXPECTED_HELPER_SHA256', 'EXPECTED_RUN_NONCE', 'EXPECTED_GIT_COMMAND_PATH', 'EXPECTED_GIT_PATH', 'EXPECTED_GIT_SHA256',
            'EXPECTED_SOURCE_TOOLS_RUN_ID', 'EXPECTED_SOURCE_TOOLS_SHA256', 'KC_CANDIDATE_ROOT', 'KC_DRIVER_ROOT',
            'KC_AUTHORITY_ROOT', 'KC_BASE_COMMIT', 'KC_HEAD_COMMIT', 'KC_OWNED_ROOT', 'KC_RUNTIME_ROOT',
            'KC_ARTIFACTS_ROOT', 'KC_SOURCE_TOOLS_PATH', 'KC_RUN_NONCE', 'RUN_OWNED_ROOT',
            'KC_SOURCE_TOOLS_RUN_ID', 'KC_SOURCE_TOOLS_SHA256'
        )
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) { $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, 'Process') }
        $runNonce = [Guid]::NewGuid().ToString('N')
        $setupRunId = [Guid]::NewGuid().ToString('N')
        $setupSha256 = 'a' * 64
        $helperSha256 = (Get-FileHash -LiteralPath (Join-Path $driverRoot $helperRelativePath) -Algorithm SHA256).Hash.ToLowerInvariant()
        $gitSha256 = (Get-FileHash -LiteralPath $gitPath -Algorithm SHA256).Hash.ToLowerInvariant()
        $ownedRoot = Join-Path $runnerTemp "kc-$runNonce"
        $runtimeRoot = Join-Path $ownedRoot 'runtime'
        $artifactsRoot = Join-Path ([IO.Path]::GetPathRoot($runnerTemp)) "a-$runNonce"
        $sourceToolsPath = Join-Path $artifactsRoot 'source-tools.json'
        try {
            $env:PROTECTED_GITHUB_WORKSPACE = $workspaceRoot
            $env:PROTECTED_RUNNER_TEMP = $runnerTemp
            $env:EXPECTED_EVENT_HEAD = $headCommit
            $env:EXPECTED_EVENT_BASE = $baseCommit
            $env:EXPECTED_HELPER_SHA256 = $helperSha256
            $env:EXPECTED_RUN_NONCE = $runNonce
            $env:EXPECTED_GIT_COMMAND_PATH = $gitPath
            $env:EXPECTED_GIT_PATH = $gitPath
            $env:EXPECTED_GIT_SHA256 = $gitSha256
            $env:EXPECTED_SOURCE_TOOLS_RUN_ID = $setupRunId
            $env:EXPECTED_SOURCE_TOOLS_SHA256 = $setupSha256
            $env:KC_CANDIDATE_ROOT = $candidateRoot
            $env:KC_DRIVER_ROOT = $driverRoot
            $env:KC_AUTHORITY_ROOT = $authorityRoot
            $env:KC_BASE_COMMIT = $baseCommit
            $env:KC_HEAD_COMMIT = $headCommit
            $env:KC_OWNED_ROOT = $ownedRoot
            $env:KC_RUNTIME_ROOT = $runtimeRoot
            $env:KC_ARTIFACTS_ROOT = $artifactsRoot
            $env:KC_SOURCE_TOOLS_PATH = $sourceToolsPath
            $env:KC_RUN_NONCE = $runNonce
            $env:RUN_OWNED_ROOT = $ownedRoot
            $env:KC_SOURCE_TOOLS_RUN_ID = $setupRunId
            $env:KC_SOURCE_TOOLS_SHA256 = $setupSha256

            $acceptedHelperPath = & $guardScript
            $acceptedHelperPath | Should -BeExactly ([IO.Path]::GetFullPath((Join-Path $driverRoot $helperRelativePath)))

            $env:KC_DRIVER_ROOT = Join-Path $workspaceRoot 'redirected-driver'
            Assert-TestThrowsLike { & $guardScript } '*Protected driver root differs from its immutable workflow binding.*'
            $env:KC_DRIVER_ROOT = $driverRoot

            $env:KC_BASE_COMMIT = 'a' * 40
            Assert-TestThrowsLike { & $guardScript } '*Protected source environment identity differs from immutable event or setup outputs.*'
            $env:KC_BASE_COMMIT = $baseCommit
            $env:KC_HEAD_COMMIT = 'b' * 40
            Assert-TestThrowsLike { & $guardScript } '*Protected source environment identity differs from immutable event or setup outputs.*'
            $env:KC_HEAD_COMMIT = $headCommit
            $env:KC_SOURCE_TOOLS_RUN_ID = 'c' * 32
            Assert-TestThrowsLike { & $guardScript } '*Protected source environment identity differs from immutable event or setup outputs.*'
            $env:KC_SOURCE_TOOLS_RUN_ID = $setupRunId
            $env:KC_SOURCE_TOOLS_SHA256 = 'd' * 64
            Assert-TestThrowsLike { & $guardScript } '*Protected source environment identity differs from immutable event or setup outputs.*'
            $env:KC_SOURCE_TOOLS_SHA256 = $setupSha256

            $env:EXPECTED_HELPER_SHA256 = 'e' * 64
            Assert-TestThrowsLike { & $guardScript } '*Protected source helper SHA256 differs from its immutable identity-binding output.*'
            $env:EXPECTED_HELPER_SHA256 = $helperSha256

            & $gitPath -C $driverRoot config --local core.autocrlf true
            if ($LASTEXITCODE -ne 0) { throw 'Could not enable line-ending conversion for the protected helper fixture.' }
            $savedGitConfigCount = [Environment]::GetEnvironmentVariable('GIT_CONFIG_COUNT', 'Process')
            try {
                # Isolate the fixture's local conversion setting from caller-scoped Git overrides.
                $env:GIT_CONFIG_COUNT = '0'
                [IO.File]::WriteAllText((Join-Path $driverRoot $helperRelativePath), "# protected fixture helper`r`n", [Text.UTF8Encoding]::new($false))
                & $gitPath -C $driverRoot add -- $helperRelativePath
                if ($LASTEXITCODE -ne 0) { throw 'Could not refresh the unchanged normalized helper blob in the fixture index.' }
                $driverStatus = @(& $gitPath -C $driverRoot status --porcelain=v1 --untracked-files=all)
                if ($LASTEXITCODE -ne 0 -or $driverStatus.Count -ne 0) { throw 'The CRLF protected helper fixture must remain clean after Git line-ending conversion.' }
                Assert-TestThrowsLike { & $guardScript } '*Protected source helper raw bytes differ from the immutable event-base Git blob.*'
            }
            finally {
                [Environment]::SetEnvironmentVariable('GIT_CONFIG_COUNT', $savedGitConfigCount, 'Process')
                [IO.File]::WriteAllText((Join-Path $driverRoot $helperRelativePath), $helperBytes, [Text.UTF8Encoding]::new($false))
                & $gitPath -C $driverRoot config --local core.autocrlf false
                if ($LASTEXITCODE -ne 0) { throw 'Could not restore line-ending configuration for the protected helper fixture.' }
            }
        }
        finally {
            foreach ($name in $environmentNames) { [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name], 'Process') }
        }
    }

    # Scenario: the active 2f249 pin requires the three-platform protected flow.
    # Purpose: document the two canonical purposes and the reusable adoption template.
    It 'UnitT60_documents_both_protected_purposes_under_the_single_canonical_entrypoint' {
        $readme = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'README.md') -Raw
        $release = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'RELEASING.md') -Raw
        foreach ($document in @($readme, $release)) {
            $document | Should -Match 'scripts/Validate\.ps1'
            $document | Should -Match '-PrepareSourceTools'
            $document | Should -Match '-SourceValidation'
            $document | Should -Match '2f249f5c1acdb1e7b9eb03180a709d85408e9ac0'
            $document | Should -Match 'releaseEligible=false'
            $document | Should -Match '\.github/workflows/validate\.yml'
            $document | Should -Match 'config/standard-v1\.json'
        }
        Test-Path -LiteralPath (Join-Path $script:RepositoryRoot 'docs/ci/three-platform-ci-template.md') -PathType Leaf | Should -BeTrue
        $readme | Should -Match 'Protected local run'
        $readme | Should -Match '\$DriverRoot'
        $readme | Should -Match '\$AuthorityRoot'
        $readme | Should -Match '\$BaseCommit'
        $readme | Should -Match '\$env:RUN_OWNED_ROOT'
        $readme | Should -Match 'Prepare-PesterRuntime\.ps1'
        $readme | Should -Not -Match 'scripts/(?:Invoke-StandardValidation|Test-Repository)\.ps1'
        $release | Should -Not -Match 'scripts/(?:Invoke-StandardValidation|Test-Repository)\.ps1'
    }

    # Scenario: workflow expressions are present only in YAML expression-capable fields, never inside shell scripts.
    # Purpose: prevent GitHub's single-expression expansion from rejecting an oversized run block.
    It 'UnitT51_rejects_expressions_inside_workflow_run_blocks' {
        $workflowPath = Join-Path $script:RepositoryRoot '.github/workflows/validate.yml'
        $workflow = Get-Content -LiteralPath $workflowPath -Raw
        $runBlocks = @([regex]::Matches($workflow, '(?m)^ {8}run:[ \t]*\|[ \t]*\r?\n(?<body>(?:^ {10}.*(?:\r?\n|$))*)'))

        $runBlocks.Count | Should -BeGreaterThan 0
        foreach ($runBlock in $runBlocks) {
            $runBlock.Groups['body'].Value | Should -Not -Match '\$\{\{'
        }
        $workflow | Should -Not -Match '(?m)^\s+run:.*\$\{\{'
    }

    # Scenario: the matrix or aggregate is unsuccessful before the protected status mirrors run.
    # Purpose: keep mirrors pure, Linux-hosted, and fail closed on both upstream results.
    It 'UnitT70_keeps_required_status_mirrors_pure_and_bound_to_matrix_and_aggregate' {
        $workflowPath = Join-Path $script:RepositoryRoot '.github/workflows/validate.yml'
        $workflow = Get-Content -LiteralPath $workflowPath -Raw
        $jobsSection = [regex]::Match($workflow, '(?ms)^jobs:[ \t]*\r?\n(?<body>.*)\z')
        $jobsSection.Success | Should -BeTrue
        $jobMatches = [regex]::Matches($jobsSection.Groups['body'].Value, '(?ms)^  (?<id>[a-z][a-z0-9-]*):[ \t]*\r?\n(?<body>.*?)(?=^  [a-z][a-z0-9-]*:[ \t]*\r?$|\z)')
        $jobIds = @($jobMatches | ForEach-Object { $_.Groups['id'].Value })
        $jobIds | Should -Be @('canonical-validation', 'canonical-aggregate', 'repository-contract', 'skill-validator', 'skill-tools')

        foreach ($jobMatch in $jobMatches) {
            $jobId = $jobMatch.Groups['id'].Value
            if ($jobId -in @('canonical-validation', 'canonical-aggregate')) { continue }

            $jobText = $jobMatch.Value
            $jobText | Should -Match ("(?m)^    name:[ \t]*{0}[ \t]*\r?$" -f [regex]::Escape($jobId))
            $jobText | Should -Match '(?m)^    if:[ \t]+\$\{\{[ \t]*always\(\)[ \t]*\}\}[ \t]*\r?$'
            $jobText | Should -Match 'needs:\s*\[canonical-validation, canonical-aggregate\]'
            $jobText | Should -Match '(?m)^    runs-on:\s+ubuntu-latest\s*$'
            $jobText | Should -Match 'MATRIX_RESULT:.*needs\[''canonical-validation''\]\.result'
            $jobText | Should -Match 'AGGREGATE_RESULT:.*needs\.canonical-aggregate\.result'
            $jobText | Should -Match "MATRIX_RESULT -cne 'success'.*AGGREGATE_RESULT -cne 'success'"
            $jobText | Should -Not -Match 'uses:'
            $jobText | Should -Not -Match 'checkout'
        }
    }

    It 'keeps public validation documentation on the canonical entry point' {
        $readme = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'README.md') -Raw
        $readme | Should -Match 'scripts/Validate\.ps1'
        $readme | Should -Not -Match 'scripts/(?:Invoke-StandardValidation|Test-Repository)\.ps1'
        $readme | Should -Not -Match 'tests/repository\.Tests\.ps1'
    }
}
