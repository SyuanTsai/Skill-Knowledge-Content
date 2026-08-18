$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

Describe 'Knowledge & Content repository contract' {
    It 'validates the repository' {
        { & (Join-Path $root 'scripts/validate.ps1') } | Should -Not -Throw
    }

    It 'contains only declared top-level Skill directories' {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $root 'catalog/source.json') | ConvertFrom-Json
        $declared = @($source.skills.id | Sort-Object)
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $root '.agents/skills') -Directory | ForEach-Object Name | Sort-Object)
        ($actual -join "`n") | Should -BeExactly ($declared -join "`n")
    }

    It 'keeps the stable source ID' {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $root 'catalog/source.json') | ConvertFrom-Json
        $source.sourceId | Should -BeExactly 'knowledge-content'
    }
}
