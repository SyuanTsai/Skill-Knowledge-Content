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

    It 'rejects a non-directory entry under the canonical Skill root' {
        $fixture = New-KnowledgeContentFixture
        $path = Join-Path $fixture 'skills/ignored.ps1'
        [IO.File]::WriteAllText($path, 'Write-Output unsafe', [Text.UTF8Encoding]::new($false))
        Test-Path -LiteralPath $path -PathType Leaf | Should -BeTrue
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw '*non-package or reparse entry*'
    }

    It 'rejects coexistence with the legacy Skill source root' {
        $fixture = New-KnowledgeContentFixture
        $legacyRoot = Join-Path (Join-Path $fixture '.agents') 'skills'
        [void](New-Item -ItemType Directory -Path $legacyRoot -Force)
        Test-Path -LiteralPath $legacyRoot -PathType Container | Should -BeTrue
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw '*Legacy .agents/skills source root*'
    }

    It 'rejects an incorrect catalog schema version' {
        $fixture = New-KnowledgeContentFixture
        $catalog = Get-Content -Raw -LiteralPath (Join-Path $fixture 'catalog/source.json') | ConvertFrom-Json
        $catalog.schemaVersion = 1
        $catalog.schemaVersion | Should -Be 1
        Write-FixtureCatalog -Root $fixture -Value $catalog
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw '*schemaVersion must be integer 2*'
    }

    It 'rejects an unknown catalog property' {
        $fixture = New-KnowledgeContentFixture
        $catalog = Get-Content -Raw -LiteralPath (Join-Path $fixture 'catalog/source.json') | ConvertFrom-Json
        $catalog | Add-Member -NotePropertyName profiles -NotePropertyValue @()
        $catalog.PSObject.Properties.Name | Should -Contain 'profiles'
        Write-FixtureCatalog -Root $fixture -Value $catalog
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw '*invalid property set*'
    }

    It 'rejects duplicate JSON properties before object materialization' {
        $fixture = New-KnowledgeContentFixture
        $path = Join-Path $fixture 'catalog/source.json'
        $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false, $true))
        $mutated = $text.Replace('"sourceId": "knowledge-content",', '"sourceId": "knowledge-content", "sourceId": "other",')
        $mutated | Should -Not -BeExactly $text
        ([regex]::Matches($mutated, '"sourceId"')).Count | Should -Be 2
        [IO.File]::WriteAllText($path, $mutated, [Text.UTF8Encoding]::new($false))
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw '*duplicate JSON property*'
    }

    It 'rejects a two-Skill inventory outside ordinal order' {
        $fixture = New-KnowledgeContentFixture
        $originalId = 'capture-private-course-knowledge'
        $syntheticId = 'synthetic-sort-probe'
        $originalRoot = Join-Path $fixture ('skills/' + $originalId)
        $syntheticRoot = Join-Path $fixture ('skills/' + $syntheticId)
        Copy-Item -LiteralPath $originalRoot -Destination $syntheticRoot -Recurse
        $skillPath = Join-Path $syntheticRoot 'SKILL.md'
        $skillText = [IO.File]::ReadAllText($skillPath, [Text.UTF8Encoding]::new($false, $true))
        $skillMutation = $skillText.Replace('name: capture-private-course-knowledge', 'name: ' + $syntheticId)
        $skillMutation | Should -Not -BeExactly $skillText
        [IO.File]::WriteAllText($skillPath, $skillMutation, [Text.UTF8Encoding]::new($false))
        $metadataPath = Join-Path $syntheticRoot 'agents/openai.yaml'
        $metadata = [IO.File]::ReadAllText($metadataPath, [Text.UTF8Encoding]::new($false, $true))
        $metadataMutation = $metadata.Replace('display_name: "Capture Private Course Knowledge"', 'display_name: "Synthetic Sort Probe"').Replace('$capture-private-course-knowledge', '$synthetic-sort-probe')
        $metadataMutation | Should -Not -BeExactly $metadata
        [IO.File]::WriteAllText($metadataPath, $metadataMutation, [Text.UTF8Encoding]::new($false))
        $catalog = Get-Content -Raw -LiteralPath (Join-Path $fixture 'catalog/source.json') | ConvertFrom-Json
        $catalog.skills = @($syntheticId, $originalId)
        (@($catalog.skills) -join "`n") | Should -BeExactly ($syntheticId + "`n" + $originalId)
        Write-FixtureCatalog -Root $fixture -Value $catalog
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw '*ordinal ascending order*'
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

    It 'rejects a quoted mapping key in OpenAI metadata' {
        $fixture = New-KnowledgeContentFixture
        $path = Join-Path $fixture 'skills/capture-private-course-knowledge/agents/openai.yaml'
        $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false, $true))
        $mutated = [regex]::Replace($text, '(?m)^([ \t]*)display_name(?=[ \t]*:)', '$1"display_name"', 1)
        $mutated | Should -Not -BeExactly $text
        [IO.File]::WriteAllText($path, $mutated, [Text.UTF8Encoding]::new($false))
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw '*quoted mapping key*'
    }

    It 'rejects a non-SPDX comment in OpenAI metadata' {
        $fixture = New-KnowledgeContentFixture
        $path = Join-Path $fixture 'skills/capture-private-course-knowledge/agents/openai.yaml'
        $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false, $true))
        $mutated = $text.TrimEnd([char]13, [char]10) + "`n# unsupported comment`n"
        $mutated | Should -Not -BeExactly $text
        [IO.File]::WriteAllText($path, $mutated, [Text.UTF8Encoding]::new($false))
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw '*unsupported or malformed syntax*'
    }

    It 'accepts the allowed optional license frontmatter field' {
        $fixture = New-KnowledgeContentFixture
        $path = Join-Path $fixture 'skills/capture-private-course-knowledge/SKILL.md'
        $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false, $true))
        $replacement = '$1' + "`nlicense: Apache-2.0"
        $mutated = [regex]::Replace($text, '(?m)^(description:.*)$', $replacement, 1)
        $mutated | Should -Not -BeExactly $text
        $mutated | Should -Match '(?m)^license: Apache-2\.0$'
        [IO.File]::WriteAllText($path, $mutated, [Text.UTF8Encoding]::new($false))
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Not -Throw
    }
}
