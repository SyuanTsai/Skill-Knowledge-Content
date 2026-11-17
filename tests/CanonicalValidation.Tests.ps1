# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0

Describe 'Consumer repository contract' {
    BeforeAll {
        $script:RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
        $script:CheckPath = Join-Path $script:RepositoryRoot 'scripts/Test-KnowledgeContentRepository.ps1'
        $script:Source = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'catalog/source.json') | ConvertFrom-Json
        $script:Gate = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'config/consumer-gate.json') | ConvertFrom-Json
        $script:Pin = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'config/authority-pin.json') | ConvertFrom-Json
    }

    It 'publishes the snapshot-safe repository check interface' {
        $command = Get-Command -Name $script:CheckPath -CommandType ExternalScript
        @($command.Parameters.Keys) | Should -Contain 'RepositoryRoot'
        @($command.Parameters.Keys) | Should -Contain 'ReadOnlySnapshot'
        $command.Parameters['ReadOnlySnapshot'].ParameterType | Should -Be ([switch])
    }

    It 'declares the active Skills from the source inventory' {
        @($script:Gate.activeSkills) | Should -HaveCount @($script:Source.skills).Count
        (@($script:Gate.activeSkills) -join "`n") | Should -BeExactly (@($script:Source.skills) -join "`n")
    }

    It 'declares exactly the repository-specific and complete-suite checks' {
        @($script:Gate.repositoryChecks) | Should -HaveCount 2
        $general = @($script:Gate.repositoryChecks | Where-Object kind -CEQ 'general')
        $pester = @($script:Gate.repositoryChecks | Where-Object kind -CEQ 'pester')
        $general | Should -HaveCount 1
        $general[0].id | Should -BeExactly 'repository-knowledge-content'
        $general[0].path | Should -BeExactly 'scripts/Test-KnowledgeContentRepository.ps1'
        $pester | Should -HaveCount 1
        $pester[0].id | Should -BeExactly 'repository-pester'
        $pester[0].path | Should -BeExactly 'tests'
    }

    It 'contains the three authority-published consumer templates' {
        @(
            'scripts/Invoke-PinnedAuthority.ps1'
            '.github/workflows/consumer-gate.yml'
            '.github/workflows/consumer-gate-transition.yml'
        ) | ForEach-Object {
            Test-Path -LiteralPath (Join-Path $script:RepositoryRoot $_) -PathType Leaf | Should -BeTrue
        }
    }

    It 'pins an immutable authority commit' {
        (@($script:Pin.PSObject.Properties.Name) -join "`n") | Should -BeExactly (@('schemaVersion', 'repository', 'commit') -join "`n")
        $script:Pin.schemaVersion | Should -Be 1
        $script:Pin.repository | Should -BeExactly 'https://github.com/SyuanTsai/SyuanTsai-AI-Instructions.git'
        $script:Pin.commit | Should -Match '^[0-9a-f]{40}$'
    }
}
