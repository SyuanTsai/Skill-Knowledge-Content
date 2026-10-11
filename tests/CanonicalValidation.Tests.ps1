# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
Describe 'Canonical Standard v1 validation adapter' {
    BeforeAll {
        $script:RepositoryRoot = Split-Path -Parent $PSScriptRoot
        $script:ValidatorPath = Join-Path $script:RepositoryRoot 'scripts/Validate.ps1'
        $script:Validator = Get-Content -LiteralPath $script:ValidatorPath -Raw
        $script:Adapter = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'config/standard-v1.json') -Raw |
            ConvertFrom-Json -Depth 20
        $script:ExpectedAuthorityCommit = 'ff85d5f80fe795b96354e753074b5ce59ad04ecd'
        $script:ExpectedAuthorityArchiveSha256 = '3dc38613f2e2316ad8fcc79d4bf48d0b03fd8398f8dacc72d156abcbce95ea9d'
        $script:ExpectedAuthorityFiles = [ordered]@{
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
    }

    # Scenario: The Knowledge adapter and validator are loaded with the reviewed ff85 authority inventory.
    # Purpose: Reject mismatched commit, archive, or required-file hashes before validation.
    It 'UnitT10_pins_exact_authority_without_local_deviation_policy' {
        @($script:Adapter.PSObject.Properties.Name) | Should -Be @('schemaVersion', 'standardVersion', 'authority')
        $script:Adapter.authority.commit | Should -Be $script:ExpectedAuthorityCommit
        $script:Adapter.authority.archiveUrl | Should -Be "https://codeload.github.com/SyuanTsai/SyuanTsai-AI-Instructions/zip/$($script:ExpectedAuthorityCommit)"
        $script:Adapter.authority.archiveSha256 | Should -Be $script:ExpectedAuthorityArchiveSha256
        $script:Validator | Should -Match 'https://codeload\.github\.com/SyuanTsai/SyuanTsai-AI-Instructions/zip/'
        @($script:Adapter.authority.files).Count | Should -Be $script:ExpectedAuthorityFiles.Count
        foreach ($file in @($script:Adapter.authority.files)) {
            $script:ExpectedAuthorityFiles.Contains($file.path) | Should -BeTrue
            $file.sha256 | Should -Be $script:ExpectedAuthorityFiles[$file.path]
        }
        $script:Adapter.PSObject.Properties.Name | Should -Not -Contain 'deviations'
    }

    # Scenario: the production validator carries an ordered authority map alongside the public JSON config.
    # Purpose: keep the runtime approval table byte-for-byte aligned with all 32 approved ff85 file identities.
    It 'UnitT15_binds_the_production_authority_table_to_the_complete_ff85_config' {
        $marker = '$script:AuthorityFiles = [ordered]@{'
        $start = $script:Validator.IndexOf($marker, [StringComparison]::Ordinal)
        $start | Should -BeGreaterOrEqual 0
        $end = $script:Validator.IndexOf("`n}", $start, [StringComparison]::Ordinal)
        $end | Should -BeGreaterThan $start
        $tableText = $script:Validator.Substring($start, $end - $start)
        $entries = @([regex]::Matches($tableText, "(?m)^\s*'(?<path>[^']+)'\s*=\s*'(?<sha256>[0-9a-f]{64})'\s*$"))
        $entries.Count | Should -Be 32
        foreach ($index in 0..31) {
            $entries[$index].Groups['path'].Value | Should -BeExactly $script:Adapter.authority.files[$index].path
            $entries[$index].Groups['sha256'].Value | Should -BeExactly $script:Adapter.authority.files[$index].sha256
        }
    }

    It 'verifies authority before resolving or executing any validation tool' {
        $archiveIndex = $script:Validator.IndexOf('Expand-Archive')
        $archiveHashIndex = $script:Validator.IndexOf('Authority archive SHA-256 does not match')
        $fileHashIndex = $script:Validator.IndexOf('Authority file identity mismatch')
        $resolverIndex = $script:Validator.LastIndexOf('resolverPath = Join-Path')
        $centralIndex = $script:Validator.LastIndexOf('centralRunnerPath = Join-Path')

        $archiveIndex | Should -BeGreaterThan -1
        $archiveHashIndex | Should -BeGreaterThan $archiveIndex
        $fileHashIndex | Should -BeGreaterThan $archiveHashIndex
        $resolverIndex | Should -BeGreaterThan $fileHashIndex
        $centralIndex | Should -BeGreaterThan $resolverIndex
    }

    It 'passes resolver named arguments through the trusted PowerShell host' {
        $script:Validator | Should -Match '& \$PowerShellPath -NoProfile -NonInteractive -File \$ResolverPath @Arguments'
        $script:Validator | Should -Match 'Invoke-Resolver -PowerShellPath \$pwshPath'
    }

    It 'expands collection-valued package reports before validating each result' {
        $script:Validator | Should -Match 'return \$Object\.PSObject\.Properties\[\$Name\]\.Value'
        $script:Validator | Should -Not -Match 'return ,\$Object\.PSObject\.Properties\[\$Name\]\.Value'
        $script:Validator | Should -Match 'foreach \(\$result in \$results\)'
    }

    It 'keeps repository Pester child output JSON-only' {
        $script:Validator | Should -Match '\$result = Invoke-Pester -Path \$testRoot -Output None -PassThru 6>\$null'
    }

    It 'keeps repository domain child output JSON-only' {
        # Scenario: the domain validator writes a human-readable success line as well as its JSON report.
        # Purpose: prevent non-JSON child output from corrupting the central runner envelope.
        $script:Validator | Should -Match '& \$validatorPath -RepositoryRoot \$candidateRoot -OutputPath \$reportPath -ReadOnlySnapshot \*> \$null'
    }

    It 'normalizes a singleton active Skill inventory before child comparisons' {
        # Scenario: a source repository contains exactly one active Skill.
        # Purpose: keep cross-platform PowerShell child validation from treating the Skill ID as a scalar string.
        $script:Validator | Should -Match '\$activeSkills = @\(Get-ActiveSkills\)'
    }

    It 'uses the P02 central runner as the only stage and severity orchestrator' {
        $script:Validator | Should -Match 'Invoke-StandardValidation\.ps1'
        $script:Validator | Should -Match '-DevelopmentHarness'
        $script:Validator | Should -Match '& \$pwshPath -NoProfile -NonInteractive -File \$centralRunnerPath @centralRunnerArgs'
        $script:Validator | Should -Match 'standard-validation-adapter\.json'
        $script:Validator | Should -Match 'packageAdapter'
        $script:Validator | Should -Match 'skillValidator'
        $script:Validator | Should -Match 'skillTools'
        $script:Validator | Should -Match 'staticAnalyzer'
        $script:Validator | Should -Match 'repositoryTests'
        $script:Validator | Should -Not -Match 'ConvertTo-ValidationSecurityFinding'
        $script:Validator | Should -Not -Match 'deviations\s*='
        $script:Validator | Should -Not -Match 'Get-ValidationSecurityAction'
    }

    It 'keeps Test-Repository and Pester in repository-test dispatch after Static' {
        $script:Validator | Should -Match 'repository-test-knowledge'
        $script:Validator | Should -Match 'repository-test-pester'
        $script:Validator | Should -Match 'Test-Repository\.ps1'
        $script:Validator | Should -Match 'Invoke-Pester'
        $repositoryTestsIndex = $script:Validator.IndexOf('repositoryTests = @(')
        $centralIndex = $script:Validator.IndexOf('Invoke-StandardValidation.ps1')
        $repositoryTestsIndex | Should -BeGreaterThan -1
        $centralIndex | Should -BeGreaterThan -1
    }

    # Scenario: the Knowledge source builds a repository-test adapter for the merged PR60 central runner.
    # Purpose: keep each repository-test ID paired with a schema-valid kind before Stage 1 starts.
    It 'UnitT20_declares_exact_repository_test_kinds' {
        $script:Validator | Should -Match "id = 'repository-test-knowledge'; kind = 'general';"
        $script:Validator | Should -Match "id = 'repository-test-pester'; kind = 'pester';"
    }

    It 'binds an immutable distinct base ancestor before invoking the central runner' {
        $script:Validator | Should -Match 'rev-parse --verify --end-of-options'
        $script:Validator | Should -Match 'merge-base --is-ancestor'
        $script:Validator | Should -Match 'Base commit must be a distinct ancestor'
        $script:Validator | Should -Match 'BaseRevision'
        $script:Validator | Should -Match '--prefix=candidate-\$candidateCommit/'
    }

    It 'keeps generated adapter and evidence roots outside the candidate' {
        $script:Validator | Should -Match 'Assert-OutsideRoot -Path \$artifactsRootPath -Root \$repoRoot'
        $script:Validator | Should -Match 'trustedRoot'
        $script:Validator | Should -Match 'skcv1-resolved-tools-\$runId'
        $script:Validator | Should -Match 'Assert-NoReparseAncestors -Path \$resolvedToolsRoot'
        $script:Validator | Should -Match 'Assert-PathWithinRoot'
        $script:Validator | Should -Match 'OutputPath'
        $script:Validator | Should -Match '\(\(Test-Path -LiteralPath \$trustedRoot\) -or \(Test-Path -LiteralPath \$candidateExtractRoot\)\)'
    }

    It 'does not execute a candidate domain test before the central runner' {
        $directDomainCall = [regex]::Escape("& (Join-Path `$repoRoot 'scripts/Test-Repository.ps1')")
        $script:Validator | Should -Not -Match $directDomainCall
        $childRunnerMarker = '$childRunnerText = @' + [char]39
        $entryPoint = $script:Validator.Substring(0, $script:Validator.IndexOf($childRunnerMarker))
        $entryPoint | Should -Not -Match 'Import-Module.*Pester'
    }
}
