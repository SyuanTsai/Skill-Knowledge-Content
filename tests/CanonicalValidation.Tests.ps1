# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
Describe 'Canonical Standard v1 validation adapter' {
    BeforeAll {
        $script:RepositoryRoot = Split-Path -Parent $PSScriptRoot
        $script:ValidatorPath = Join-Path $script:RepositoryRoot 'scripts/Validate.ps1'
        $script:Validator = Get-Content -LiteralPath $script:ValidatorPath -Raw
        $script:Adapter = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'config/standard-v1.json') -Raw |
            ConvertFrom-Json -Depth 20
        $script:ExpectedAuthorityCommit = 'ead467c3488c103546f316d137196b447a1ff58a'
        $script:ExpectedAuthorityArchiveSha256 = 'ab304bc6caabe4bb9b605f403c852650e19e25f72999010db61bbad695e1c60b'
        $script:ExpectedAuthorityFiles = [ordered]@{}
        foreach ($entry in @($script:Adapter.authority.files)) { $script:ExpectedAuthorityFiles[[string]$entry.path] = [string]$entry.sha256 }
    }

    # Scenario: The Knowledge adapter and validator are loaded with the reviewed ead467c authority inventory.
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
    # Purpose: keep the runtime approval table byte-for-byte aligned with all 51 approved ead467c file identities.
    It 'UnitT15_binds_the_protected_authority_table_to_the_complete_ead467c_config' {
        $helper = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'scripts/StandardCoreSourceValidation.ps1') -Raw
        $marker = '$script:KnowledgeContentActiveAuthorityFiles = [ordered]@{'
        $start = $helper.IndexOf($marker, [StringComparison]::Ordinal)
        $start | Should -BeGreaterOrEqual 0
        $end = $helper.IndexOf("`n}", $start, [StringComparison]::Ordinal)
        $end | Should -BeGreaterThan $start
        $tableText = $helper.Substring($start, $end - $start)
        $entries = @([regex]::Matches($tableText, "(?m)^\s*'(?<path>[^']+)'\s*=\s*'(?<sha256>[0-9a-f]{64})'\s*$"))
        $entries.Count | Should -Be 51
        foreach ($index in 0..50) {
            $entries[$index].Groups['path'].Value | Should -BeExactly $script:Adapter.authority.files[$index].path
            $entries[$index].Groups['sha256'].Value | Should -BeExactly $script:Adapter.authority.files[$index].sha256
        }
        $script:Validator | Should -Match 'StandardCoreSourceValidation\.ps1'
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
