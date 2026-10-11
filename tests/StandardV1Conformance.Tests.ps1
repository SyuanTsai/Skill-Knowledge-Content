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

    It 'keeps public validation documentation on the canonical entry point' {
        $readme = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'README.md') -Raw
        $readme | Should -Match 'scripts/Validate\.ps1'
        $readme | Should -Not -Match 'scripts/(?:Invoke-StandardValidation|Test-Repository)\.ps1'
        $readme | Should -Not -Match 'tests/repository\.Tests\.ps1'
        $readme | Should -Not -Match '(?i)\b(?:Invoke-Pester|pytest|skill-validator|skill-tools|skillspector)\b'
    }
}
