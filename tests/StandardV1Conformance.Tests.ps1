# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
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
        $adapter.authority.commit | Should -Be 'ff85d5f80fe795b96354e753074b5ce59ad04ecd'
        $adapter.authority.archiveSha256 | Should -Be '3dc38613f2e2316ad8fcc79d4bf48d0b03fd8398f8dacc72d156abcbce95ea9d'
        @($adapter.PSObject.Properties.Name) | Should -Not -Contain 'security'
        @($adapter.authority.files).Count | Should -Be 32
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

    # Scenario: the protected Windows workflow receives PR, push, or manual-dispatch events.
    # Purpose: bind one canonical validator to exact event revisions, raw checkout bytes, verified runtimes, and existing status contexts.
    It 'UnitT50_routes_protected_source_CI_through_the_canonical_validator' {
        $workflowPath = Join-Path $script:RepositoryRoot '.github/workflows/validate.yml'
        $workflow = Get-Content -LiteralPath $workflowPath -Raw
        $workflow | Should -Match 'scripts/Validate\.ps1'
        $workflow | Should -Match 'persist-credentials:\s*false'
        $workflow | Should -Match 'actions/checkout@[0-9a-f]{40}'
        $workflow | Should -Match 'uses:\s*\*checkout-action-reference'
        $workflow | Should -Match 'actions/setup-go@[0-9a-f]{40}'
        $workflow | Should -Match '\$artifactsRoot = Join-Path \(\[IO\.Path\]::GetPathRoot\(\$env:RUNNER_TEMP\)\) "a-\$runNonce"'
        $workflow | Should -Match 'path:\s+\$\{\{\s*env\.KC_ARTIFACTS_ROOT\s*\}\}'
        $workflow | Should -Not -Match 'knowledge-content-artifacts'
        $workflow | Should -Match 'actions/setup-node@49933ea5288caeca8642d1e84afbd3f7d6820020'
        $workflow | Should -Match "node-version:\s+'24\.21\.0'"
        $workflow | Should -Match 'nodeVersion -cne ''v24\.21\.0'''
        $workflow | Should -Match 'Join-Path \$nodeRoot ''node_modules/npm/package\.json'''
        $workflow | Should -Match '\$npmLauncherPath\.Equals\(\$expectedNpmLauncherPath'
        $workflow | Should -Match 'npmVersion -cne \$npmPackageVersion'
        $workflow | Should -Match 'nodeExecutableSha256'
        $workflow | Should -Match 'npmLauncherSha256'
        $workflow | Should -Match 'npmCliSha256'
        $workflow | Should -Match 'npmPackageJsonSha256'
        $workflow | Should -Match 'node-runtime-before-source-setup\.json'
        $nodeRuntimeCapture = $workflow.IndexOf('Capture and verify Node runtime before source setup', [StringComparison]::Ordinal)
        $sourceToolsSetup = $workflow.IndexOf('Prepare source tool receipts through the canonical validator', [StringComparison]::Ordinal)
        $nodeRuntimeCapture | Should -BeGreaterThan -1
        $nodeRuntimeCapture | Should -BeLessThan $sourceToolsSetup
        $workflow | Should -Match 'runs-on:\s+windows-latest'
        $workflow | Should -Match '(?s)Preserve committed bytes before checkout.*?core\.autocrlf false.*?Checkout exact event candidate'
        $workflow | Should -Match 'github\.event\.pull_request\.head\.sha\s*\|\|\s*github\.sha'
        $workflow | Should -Match 'PULL_REQUEST_BASE_SHA:\s*\$\{\{\s*github\.event\.pull_request\.base\.sha\s*\}\}'
        $workflow | Should -Match 'PUSH_BEFORE_SHA:\s*\$\{\{\s*github\.event\.before\s*\}\}'
        $workflow | Should -Match 'DISPATCH_BASE_SHA:\s*\$\{\{\s*inputs\.base_commit\s*\}\}'
        $workflow | Should -Match 'Checkout exact event-base protected driver'
        $workflow | Should -Match 'ref:\s+\$\{\{\s*github\.event\.pull_request\.base\.sha\s*\|\|\s*github\.event\.before\s*\|\|\s*inputs\.base_commit\s*\}\}'
        $workflow | Should -Match 'KC_DRIVER_ROOT'
        $workflow | Should -Match 'Protected driver HEAD differs from the exact event base SHA'
        $workflow | Should -Match 'Protected driver checkout is not clean'
        $workflow | Should -Match 'id:\s*bind_identities'
        $workflow | Should -Match 'git_sha256=\$gitExecutableSha256'
        $workflow | Should -Match 'hash-object --no-filters -- \$protectedHelperPath'
        $workflow | Should -Match 'EXPECTED_EVENT_BASE:\s*\$\{\{\s*github\.event\.pull_request\.base\.sha\s*\|\|\s*github\.event\.before\s*\|\|\s*inputs\.base_commit\s*\}\}'
        $workflow | Should -Match 'EXPECTED_SOURCE_TOOLS_RUN_ID:\s*\$\{\{\s*steps\.prepare_source_tools\.outputs\.run_id\s*\}\}'
        $workflow | Should -Match 'EXPECTED_SOURCE_TOOLS_SHA256:\s*\$\{\{\s*steps\.prepare_source_tools\.outputs\.source_tools_sha256\s*\}\}'
        $workflow | Should -Match 'EXPECTED_GIT_PATH:\s*\$\{\{\s*steps\.bind_identities\.outputs\.git_path\s*\}\}'
        $workflow | Should -Match 'EXPECTED_GIT_SHA256:\s*\$\{\{\s*steps\.bind_identities\.outputs\.git_sha256\s*\}\}'
        $workflow | Should -Match 'Protected source helper raw bytes differ from the immutable event-base Git blob'
        $sourceBindingGuardEnd = $workflow.IndexOf('# PROTECTED_SOURCE_BINDING_GUARD_END', [StringComparison]::Ordinal)
        $protectedHelperDotSource = $workflow.IndexOf('. $protectedHelperPath', [StringComparison]::Ordinal)
        $sourceBindingGuardEnd | Should -BeGreaterThan -1
        $protectedHelperDotSource | Should -BeGreaterThan $sourceBindingGuardEnd
        $workflow | Should -Match 'foreach \(\$root in @\(\$candidateRoot, \$driverRoot, \$authorityRoot\)\)'
        $workflow | Should -Match 'ref:\s+ff85d5f80fe795b96354e753074b5ce59ad04ecd'
        $workflow | Should -Match 'PowerShell/PowerShell/releases/latest'
        $workflow | Should -Match 'Get-AuthenticodeSignature'
        $workflow | Should -Match 'scripts/Prepare-PesterRuntime\.ps1'
        $workflow | Should -Match '\$env:RUN_OWNED_ROOT\s*=\s*\$env:KC_OWNED_ROOT'
        $workflow | Should -Match 'PrepareSourceTools'
        $workflow | Should -Match 'SourceValidation'
        $workflow | Should -Match 'Join-Path \$env:KC_DRIVER_ROOT ''scripts/Prepare-PesterRuntime\.ps1'''
        $workflow | Should -Match 'Join-Path \$env:KC_DRIVER_ROOT ''scripts/Validate\.ps1'''
        $workflow | Should -Not -Match 'Join-Path \$env:KC_CANDIDATE_ROOT ''scripts/(?:Validate|Prepare-PesterRuntime)\.ps1'''
        $workflow | Should -Match 'Assert-KnowledgeContentPreparedAuthorityCheckout'
        $workflow | Should -Match 'Assert-StandardCoreSourceCheckReport -Report \$report'
        $workflow | Should -Match '\-ExpectedSourceRevision \$env:KC_HEAD_COMMIT -ExpectedBaseRevision \$env:KC_BASE_COMMIT'
        $workflow | Should -Match '\-ExpectedEventName \$env:GITHUB_EVENT_NAME -ArtifactsRoot \$sourceValidationRoot'
        $workflow | Should -Match 'observedProcessExitCode -ne 0\)'
        $workflow | Should -Match '\$observedSourceExitCode = \[int\]\$phaseTiming\.observedProcessExitCode'
        $workflow | Should -Match '\-OutputPath \$sourceReport -ProcessExitCode \$observedSourceExitCode'
        $workflow | Should -Match 'sourceToolsSha256Before -cne \[string\]\$env:KC_SOURCE_TOOLS_SHA256'
        $workflow | Should -Match 'sourceToolsSha256After -cne \$sourceToolsSha256Before'
        $workflow | Should -Match 'sourceReportSha256After -cne \$sourceReportSha256Before'
        $workflow | Should -Match 'source-workflow-timing-\$runKey\.json'
        $workflow | Should -Match 'setupAndInstallSeconds'
        $workflow | Should -Match 'twentyMinuteTargetMet'
        $workflow | Should -Match 'actions/upload-artifact@[0-9a-f]{40}'
        $workflow | Should -Not -Match '(?m)^\s*(Install-Module|npm install|go install|pip install)\b'
        Test-Path -LiteralPath (Join-Path $script:RepositoryRoot '.github/workflows/skill-validator.yml') | Should -BeFalse

        foreach ($context in @('repository-contract', 'skill-validator', 'skill-tools')) {
            $pattern = "(?ms)^\s+{0}:\s+name:\s+{0}.*?needs:\s+- canonical-validation.*?{1}" -f `
                [regex]::Escape($context),
                [regex]::Escape("needs['canonical-validation'].result")
            $workflow | Should -Match $pattern
        }
        $workflow | Should -Not -Match '(?ms)repository-contract:.*?Run .*skill-validator|skill-validator:.*?Run .*skill-tools'
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
            'EXPECTED_HELPER_SHA256', 'EXPECTED_RUN_NONCE', 'EXPECTED_GIT_PATH', 'EXPECTED_GIT_SHA256',
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
        $ownedRoot = Join-Path $runnerTemp "knowledge-content-owned-$runNonce"
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
            { & $guardScript } | Should -Throw '*Protected driver root differs from its immutable workflow binding.*'
            $env:KC_DRIVER_ROOT = $driverRoot

            $env:KC_BASE_COMMIT = 'a' * 40
            { & $guardScript } | Should -Throw '*Protected source environment identity differs from immutable event or setup outputs.*'
            $env:KC_BASE_COMMIT = $baseCommit
            $env:KC_HEAD_COMMIT = 'b' * 40
            { & $guardScript } | Should -Throw '*Protected source environment identity differs from immutable event or setup outputs.*'
            $env:KC_HEAD_COMMIT = $headCommit
            $env:KC_SOURCE_TOOLS_RUN_ID = 'c' * 32
            { & $guardScript } | Should -Throw '*Protected source environment identity differs from immutable event or setup outputs.*'
            $env:KC_SOURCE_TOOLS_RUN_ID = $setupRunId
            $env:KC_SOURCE_TOOLS_SHA256 = 'd' * 64
            { & $guardScript } | Should -Throw '*Protected source environment identity differs from immutable event or setup outputs.*'
            $env:KC_SOURCE_TOOLS_SHA256 = $setupSha256

            $env:EXPECTED_HELPER_SHA256 = 'e' * 64
            { & $guardScript } | Should -Throw '*Protected source helper SHA256 differs from its immutable identity-binding output.*'
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
                { & $guardScript } | Should -Throw '*Protected source helper raw bytes differ from the immutable event-base Git blob.*'
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

    # Scenario: the active ff85 pin makes ordinary v1 validation intentionally incomplete.
    # Purpose: explain the two purposes while keeping the script path as the sole public validation command.
    It 'UnitT60_documents_both_protected_purposes_under_the_single_canonical_entrypoint' {
        $readme = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'README.md') -Raw
        $release = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'RELEASING.md') -Raw
        foreach ($document in @($readme, $release)) {
            $document | Should -Match 'scripts/Validate\.ps1'
            $document | Should -Match '-PrepareSourceTools'
            $document | Should -Match '-SourceValidation'
            $document | Should -Match 'ff85d5f80fe795b96354e753074b5ce59ad04ecd'
            $document | Should -Match 'releaseEligible=false'
            $document | Should -Match 'reverts the entire adoption'
            $document | Should -Match '\.github/workflows/validate\.yml'
            $document | Should -Match 'config/standard-v1\.json'
            $document | Should -Match '8aabd22694a05771f98639f6d726cc9a620eb94b'
            $document | Should -Match 'd92df1a8f0aa342970dc9c66a77b6211955b4708de12119cb7f9a360fd265311'
            $document | Should -Match '26-file hash inventory'
        }
        $readme | Should -Match 'Protected local run'
        $readme | Should -Match '\$DriverRoot'
        $readme | Should -Match '\$AuthorityRoot'
        $readme | Should -Match '\$BaseCommit'
        $readme | Should -Match '\$env:RUN_OWNED_ROOT'
        $readme | Should -Match 'Prepare-PesterRuntime\.ps1'
        $readme | Should -Not -Match 'scripts/(?:Invoke-StandardValidation|Test-Repository)\.ps1'
        $release | Should -Not -Match 'scripts/(?:Invoke-StandardValidation|Test-Repository)\.ps1'
    }

    # Scenario: one or more validation jobs return a non-success result before the three protected status mirrors run.
    # Purpose: verify the exact PowerShell mirror bodies fail closed and that every declared job runs on Windows.
    It 'UnitT70_runs_all_required_status_mirrors_on_Windows_and_rejects_non_success_results' {
        $workflowPath = Join-Path $script:RepositoryRoot '.github/workflows/validate.yml'
        $workflow = Get-Content -LiteralPath $workflowPath -Raw
        $jobsSection = [regex]::Match($workflow, '(?ms)^jobs:[ \t]*\r?\n(?<body>.*)\z')
        $jobsSection.Success | Should -BeTrue
        $jobMatches = [regex]::Matches($jobsSection.Groups['body'].Value, '(?ms)^  (?<id>[a-z][a-z0-9-]*):[ \t]*\r?\n(?<body>.*?)(?=^  [a-z][a-z0-9-]*:[ \t]*\r?$|\z)')
        $jobIds = @($jobMatches | ForEach-Object { $_.Groups['id'].Value })
        $jobIds | Should -Be @('canonical-validation', 'repository-contract', 'skill-validator', 'skill-tools')

        foreach ($jobMatch in $jobMatches) {
            $jobId = $jobMatch.Groups['id'].Value
            $jobText = $jobMatch.Value
            $runnerMatches = [regex]::Matches($jobText, '(?m)^    runs-on:[ \t]*(?<runner>[^\s#]+)[ \t]*\r?$')
            $runnerMatches.Count | Should -Be 1
            $runnerMatches[0].Groups['runner'].Value | Should -BeExactly 'windows-latest'
            $jobText | Should -Not -Match '(?m)^    container:'

            if ($jobId -ceq 'canonical-validation') { continue }
            $jobText | Should -Match ("(?m)^    name:[ \t]*{0}[ \t]*\r?$" -f [regex]::Escape($jobId))
            $jobText | Should -Match '(?m)^    if:[ \t]+\$\{\{[ \t]*always\(\)[ \t]*\}\}[ \t]*\r?$'
            $jobText | Should -Match '(?m)^    needs:[ \t]*\r?\n      - canonical-validation[ \t]*\r?$'
            $jobText | Should -Match '(?m)^        shell:[ \t]*pwsh[ \t]*\r?$'
            $jobText | Should -Match '(?m)^          CANONICAL_VALIDATION_RESULT:[ \t]*\$\{\{[ \t]*needs\[''canonical-validation''\]\.result[ \t]*\}\}[ \t]*\r?$'

            $jobLines = $jobText -split "\r?\n"
            $runLineIndex = -1
            for ($lineIndex = 0; $lineIndex -lt $jobLines.Count; $lineIndex++) {
                if ($jobLines[$lineIndex] -match '^        run:[ \t]*\|[ \t]*$') {
                    $runLineIndex = $lineIndex
                    break
                }
            }
            $runLineIndex | Should -BeGreaterThan -1
            $scriptLines = [System.Collections.Generic.List[string]]::new()
            for ($lineIndex = $runLineIndex + 1; $lineIndex -lt $jobLines.Count; $lineIndex++) {
                $line = [string]$jobLines[$lineIndex]
                if ($line.StartsWith('          ', [StringComparison]::Ordinal)) {
                    $scriptLines.Add($line.Substring(10))
                    continue
                }
                if ([string]::IsNullOrWhiteSpace($line)) {
                    $scriptLines.Add('')
                    continue
                }
                break
            }
            $scriptText = $scriptLines -join "`n"
            $scriptText | Should -Match '\$env:CANONICAL_VALIDATION_RESULT'
            $scriptPath = Join-Path $TestDrive "mirror-$jobId.ps1"
            [IO.File]::WriteAllText($scriptPath, $scriptText, [Text.UTF8Encoding]::new($false))

            $pwshCommand = Get-Command pwsh.exe -CommandType Application -ErrorAction Stop | Select-Object -First 1
            $pwshPath = [IO.Path]::GetFullPath([string]$pwshCommand.Source)
            $invokeMirror = {
                param([string]$Path, [bool]$SetResult, [AllowNull()][string]$Result)
                $startInfo = [Diagnostics.ProcessStartInfo]::new()
                $startInfo.FileName = $pwshPath
                $startInfo.UseShellExecute = $false
                $startInfo.CreateNoWindow = $true
                $startInfo.RedirectStandardOutput = $true
                $startInfo.RedirectStandardError = $true
                [void]$startInfo.ArgumentList.Add('-NoLogo')
                [void]$startInfo.ArgumentList.Add('-NoProfile')
                [void]$startInfo.ArgumentList.Add('-NonInteractive')
                [void]$startInfo.ArgumentList.Add('-File')
                [void]$startInfo.ArgumentList.Add($Path)
                if ($SetResult) {
                    $startInfo.Environment['CANONICAL_VALIDATION_RESULT'] = $Result
                } else {
                    [void]$startInfo.Environment.Remove('CANONICAL_VALIDATION_RESULT')
                }
                $process = [Diagnostics.Process]::Start($startInfo)
                try {
                    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
                    $stderrTask = $process.StandardError.ReadToEndAsync()
                    if (-not $process.WaitForExit(60000)) {
                        try {
                            $process.Kill($true)
                        }
                        catch {
                            # Keep the timeout as the primary failure; process cleanup is best effort.
                        }
                        [void]$process.WaitForExit(5000)
                        throw "Timed out waiting for mirror process '$Path'."
                    }
                    [pscustomobject]@{
                        ExitCode = $process.ExitCode
                        StandardOutput = $stdoutTask.GetAwaiter().GetResult()
                        StandardError = $stderrTask.GetAwaiter().GetResult()
                    }
                }
                finally {
                    $process.Dispose()
                }
            }

            $resultCases = @(
                [pscustomobject]@{ Label = 'success'; Value = 'success'; SetResult = $true; ExpectedExitCode = 0 },
                [pscustomobject]@{ Label = 'failure'; Value = 'failure'; SetResult = $true; ExpectedExitCode = 1 },
                [pscustomobject]@{ Label = 'cancelled'; Value = 'cancelled'; SetResult = $true; ExpectedExitCode = 1 },
                [pscustomobject]@{ Label = 'skipped'; Value = 'skipped'; SetResult = $true; ExpectedExitCode = 1 },
                [pscustomobject]@{ Label = 'empty'; Value = ''; SetResult = $true; ExpectedExitCode = 1 },
                [pscustomobject]@{ Label = 'missing'; Value = $null; SetResult = $false; ExpectedExitCode = 1 },
                [pscustomobject]@{ Label = 'unexpected'; Value = 'passed-with-warning'; SetResult = $true; ExpectedExitCode = 1 },
                [pscustomobject]@{ Label = 'wrong-case'; Value = 'Success'; SetResult = $true; ExpectedExitCode = 1 }
            )
            foreach ($resultCase in $resultCases) {
                $processResult = & $invokeMirror $scriptPath $resultCase.SetResult $resultCase.Value
                $processResult.ExitCode | Should -Be $resultCase.ExpectedExitCode -Because "$jobId must map result '$($resultCase.Label)' to its strict mirror exit code"
                $processResult.StandardError.Trim() | Should -BeExactly '' -Because "$jobId must not emit PowerShell errors for result '$($resultCase.Label)'"
                if ($resultCase.ExpectedExitCode -eq 0) {
                    $processResult.StandardOutput.TrimEnd() | Should -BeExactly 'Canonical Standard v1 validation passed.'
                } else {
                    $expectedMessage = "Canonical Standard v1 validation result: $([string]$resultCase.Value)"
                    $processResult.StandardOutput.TrimEnd() | Should -BeExactly $expectedMessage.TrimEnd()
                }
            }
        }
    }

    It 'keeps public validation documentation on the canonical entry point' {
        $readme = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'README.md') -Raw
        $readme | Should -Match 'scripts/Validate\.ps1'
        $readme | Should -Not -Match 'scripts/(?:Invoke-StandardValidation|Test-Repository)\.ps1'
        $readme | Should -Not -Match 'tests/repository\.Tests\.ps1'
        $readme | Should -Not -Match '(?i)\b(?:Invoke-Pester|pytest|skill-validator|skill-tools|skillspector)\b'
    }
}
