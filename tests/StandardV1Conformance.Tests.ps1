# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0

Describe 'Knowledge Content package conformance' {
    BeforeAll {
        $script:RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
        $script:Source = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'catalog/source.json') | ConvertFrom-Json
    }

    It 'uses the exact source inventory contract' {
        (@($script:Source.PSObject.Properties.Name) -join "`n") | Should -BeExactly (@('schemaVersion', 'sourceId', 'repository', 'skillsRoot', 'skills') -join "`n")
        $script:Source.schemaVersion | Should -Be 2
        $script:Source.sourceId | Should -BeExactly 'knowledge-content'
        $script:Source.skillsRoot | Should -BeExactly 'skills'
    }

    It 'keeps the declared Skill IDs unique and ordinally sorted' {
        @($script:Source.skills | Sort-Object -Unique) | Should -HaveCount @($script:Source.skills).Count
        (@($script:Source.skills) -join "`n") | Should -BeExactly (@($script:Source.skills | Sort-Object -CaseSensitive) -join "`n")
        foreach ($skillId in @($script:Source.skills)) {
            [string]$skillId | Should -Match '^[a-z0-9]+(?:-[a-z0-9]+)*$'
        }
    }

    It 'matches the source inventory to the package directories' {
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot 'skills') -Directory -Force | ForEach-Object Name | Sort-Object -CaseSensitive)
        ($actual -join "`n") | Should -BeExactly (@($script:Source.skills) -join "`n")
    }

    It 'requires Skill instructions and OpenAI metadata in every package' {
        foreach ($skillId in @($script:Source.skills)) {
            $skillRoot = Join-Path $script:RepositoryRoot ('skills/' + [string]$skillId)
            Test-Path -LiteralPath (Join-Path $skillRoot 'SKILL.md') -PathType Leaf | Should -BeTrue
            Test-Path -LiteralPath (Join-Path $skillRoot 'agents/openai.yaml') -PathType Leaf | Should -BeTrue
        }
    }

    It 'binds each Skill frontmatter name to its package ID' {
        foreach ($skillId in @($script:Source.skills)) {
            $text = [IO.File]::ReadAllText((Join-Path $script:RepositoryRoot ('skills/' + [string]$skillId + '/SKILL.md')), [Text.UTF8Encoding]::new($false, $true)).Replace("`r`n", "`n")
            $text | Should -Match '(?s)\A---\n.*?\n---\n\S'
            $nameLine = @($text.Split("`n") | Where-Object { $_ -cmatch '^name:\s+' })
            $nameLine | Should -HaveCount 1
            $nameLine[0].Substring(5).Trim() | Should -BeExactly ([string]$skillId)
        }
    }

    It 'provides the required quoted interface metadata' {
        foreach ($skillId in @($script:Source.skills)) {
            $text = [IO.File]::ReadAllText((Join-Path $script:RepositoryRoot ('skills/' + [string]$skillId + '/agents/openai.yaml')), [Text.UTF8Encoding]::new($false, $true))
            $text | Should -Match '(?m)^interface:$'
            $text | Should -Match '(?m)^  display_name: "[^"\r\n]+"$'
            $text | Should -Match '(?m)^  short_description: "[^"\r\n]+"$'
            $text | Should -Match '(?m)^  default_prompt: "[^"\r\n]+"$'
        }
    }
}
