# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0

Describe 'Consumer repository layout' {
    BeforeAll {
        $script:RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
    }

    It 'contains only the repository check and authority bootstrap under scripts' {
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot 'scripts') -File | ForEach-Object Name | Sort-Object -CaseSensitive)
        $expected = @('Invoke-PinnedAuthority.ps1', 'Test-KnowledgeContentRepository.ps1')
        ($actual -join "`n") | Should -BeExactly ($expected -join "`n")
    }

    It 'contains exactly the consumer workflow pair' {
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot '.github/workflows') -File | ForEach-Object Name | Sort-Object -CaseSensitive)
        $expected = @('consumer-gate-transition.yml', 'consumer-gate.yml')
        ($actual -join "`n") | Should -BeExactly ($expected -join "`n")
    }

    It 'contains only consumer configuration files' {
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot 'config') -File | ForEach-Object Name | Sort-Object -CaseSensitive)
        $expected = @('authority-pin.json', 'consumer-gate.json')
        ($actual -join "`n") | Should -BeExactly ($expected -join "`n")
    }

    It 'keeps the gate identity consistent with source metadata' {
        $source = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'catalog/source.json') | ConvertFrom-Json
        $gate = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'config/consumer-gate.json') | ConvertFrom-Json
        $gate.sourceRepository | Should -BeExactly $source.repository
        (@($gate.activeSkills) -join "`n") | Should -BeExactly (@($source.skills) -join "`n")
    }

    It 'declares REUSE metadata for generated-format and copied files' {
        $reuse = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'REUSE.toml')
        foreach ($path in @(
                'config/authority-pin.json'
                'config/consumer-gate.json'
                'scripts/Invoke-PinnedAuthority.ps1'
                '.github/workflows/consumer-gate.yml'
                '.github/workflows/consumer-gate-transition.yml'
            )) {
            $text = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot $path)
            $covered = $reuse.Contains($path, [StringComparison]::Ordinal) -or $text.Contains('SPDX-License-Identifier:', [StringComparison]::Ordinal)
            $covered | Should -BeTrue
        }
    }
}
