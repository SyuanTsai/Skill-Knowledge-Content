# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0

Describe 'Snapshot repository check behavior' {
    BeforeAll {
        $script:RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
        $script:CheckPath = Join-Path $script:RepositoryRoot 'scripts/Test-KnowledgeContentRepository.ps1'

        function New-KnowledgeContentFixture {
            $root = Join-Path $TestDrive ([Guid]::NewGuid().ToString('N'))
            [void](New-Item -ItemType Directory -Path (Join-Path $root 'catalog') -Force)
            [void](New-Item -ItemType Directory -Path (Join-Path $root 'skills') -Force)
            Copy-Item -LiteralPath (Join-Path $script:RepositoryRoot 'catalog/source.json') -Destination (Join-Path $root 'catalog/source.json')
            Copy-Item -LiteralPath (Join-Path $script:RepositoryRoot 'skills/capture-private-course-knowledge') -Destination (Join-Path $root 'skills') -Recurse
            return $root
        }

        function Write-FixtureCatalog {
            param([Parameter(Mandatory)][string] $Root, [Parameter(Mandatory)] $Value)
            $json = $Value | ConvertTo-Json -Depth 20
            [IO.File]::WriteAllText((Join-Path $Root 'catalog/source.json'), $json + "`n", [Text.UTF8Encoding]::new($false))
        }
    }

    It 'validates a snapshot that has no repository metadata directory' {
        $fixture = New-KnowledgeContentFixture
        Test-Path -LiteralPath (Join-Path $fixture '.git') | Should -BeFalse
        $json = @(& $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot) -join "`n"
        ($json | ConvertFrom-Json).result | Should -BeExactly 'passed'
    }

    It 'does not write into the candidate snapshot' {
        $fixture = New-KnowledgeContentFixture
        $before = @(Get-ChildItem -LiteralPath $fixture -Recurse -File | ForEach-Object { [IO.Path]::GetRelativePath($fixture, $_.FullName) } | Sort-Object)
        [void](@(& $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot))
        $after = @(Get-ChildItem -LiteralPath $fixture -Recurse -File | ForEach-Object { [IO.Path]::GetRelativePath($fixture, $_.FullName) } | Sort-Object)
        ($after -join "`n") | Should -BeExactly ($before -join "`n")
    }

    It 'rejects an incorrect source identity' {
        $fixture = New-KnowledgeContentFixture
        $catalog = Get-Content -Raw -LiteralPath (Join-Path $fixture 'catalog/source.json') | ConvertFrom-Json
        $catalog.sourceId = 'wrong-source'
        Write-FixtureCatalog -Root $fixture -Value $catalog
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw
    }

    It 'rejects an incorrect source repository identity' {
        $fixture = New-KnowledgeContentFixture
        $catalog = Get-Content -Raw -LiteralPath (Join-Path $fixture 'catalog/source.json') | ConvertFrom-Json
        $catalog.repository = 'https://example.invalid/source.git'
        Write-FixtureCatalog -Root $fixture -Value $catalog
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw
    }

    It 'rejects duplicate Skill IDs' {
        $fixture = New-KnowledgeContentFixture
        $catalog = Get-Content -Raw -LiteralPath (Join-Path $fixture 'catalog/source.json') | ConvertFrom-Json
        $catalog.skills = @('capture-private-course-knowledge', 'capture-private-course-knowledge')
        Write-FixtureCatalog -Root $fixture -Value $catalog
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw
    }

    It 'rejects an undeclared package directory' {
        $fixture = New-KnowledgeContentFixture
        [void](New-Item -ItemType Directory -Path (Join-Path $fixture 'skills/undeclared-package'))
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw
    }

    It 'rejects a package missing required metadata' {
        $fixture = New-KnowledgeContentFixture
        Remove-Item -LiteralPath (Join-Path $fixture 'skills/capture-private-course-knowledge/agents/openai.yaml')
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw
    }

    It 'rejects frontmatter whose name differs from the package ID' {
        $fixture = New-KnowledgeContentFixture
        $path = Join-Path $fixture 'skills/capture-private-course-knowledge/SKILL.md'
        $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false, $true))
        $text = $text.Replace('name: capture-private-course-knowledge', 'name: different-package')
        [IO.File]::WriteAllText($path, $text, [Text.UTF8Encoding]::new($false))
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw
    }

    It 'rejects metadata without the required default prompt' {
        $fixture = New-KnowledgeContentFixture
        $path = Join-Path $fixture 'skills/capture-private-course-knowledge/agents/openai.yaml'
        $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false, $true))
        $text = [regex]::Replace($text, '(?m)^  default_prompt:.*(?:\r?\n|$)', '')
        [IO.File]::WriteAllText($path, $text, [Text.UTF8Encoding]::new($false))
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw
    }
}
