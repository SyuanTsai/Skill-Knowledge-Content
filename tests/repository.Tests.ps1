# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
$ErrorActionPreference = 'Stop'

BeforeAll {
    $script:repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

Describe 'Knowledge & Content repository contract' {
    It 'validates the repository' {
        { & (Join-Path $script:repoRoot 'scripts/validate.ps1') } | Should -Not -Throw
    }

    It 'contains only declared top-level Skill directories' {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $script:repoRoot 'catalog/source.json') | ConvertFrom-Json
        $declared = @($source.skills.id | Sort-Object)
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:repoRoot '.agents/skills') -Directory | ForEach-Object Name | Sort-Object)
        ($actual -join "`n") | Should -BeExactly ($declared -join "`n")
    }

    It 'keeps the stable source ID' {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $script:repoRoot 'catalog/source.json') | ConvertFrom-Json
        $source.sourceId | Should -BeExactly 'knowledge-content'
    }
}
