# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0

Describe 'Knowledge Content repository report' {
    BeforeAll {
        $script:RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
        $script:CheckPath = Join-Path $script:RepositoryRoot 'scripts/Test-KnowledgeContentRepository.ps1'
        $script:Report = @(& $script:CheckPath -RepositoryRoot $script:RepositoryRoot -ReadOnlySnapshot) -join "`n"
        $script:Result = $script:Report | ConvertFrom-Json
    }

    It 'returns a passed machine-readable report' {
        $script:Result.schemaVersion | Should -Be 1
        $script:Result.sourceId | Should -BeExactly 'knowledge-content'
        $script:Result.result | Should -BeExactly 'passed'
        $script:Result.activeSkillCount | Should -Be @($script:Result.skills).Count
    }

    It 'reports every package file in ordinal order' {
        foreach ($package in @($script:Result.skills)) {
            $skillRoot = Join-Path $script:RepositoryRoot ('skills/' + [string]$package.skillId)
            $actual = @(Get-ChildItem -LiteralPath $skillRoot -Recurse -File -Force | ForEach-Object {
                    [IO.Path]::GetRelativePath($skillRoot, $_.FullName).Replace('\', '/')
                } | Sort-Object -CaseSensitive)
            (@($package.files.path) -join "`n") | Should -BeExactly ($actual -join "`n")
        }
    }

    It 'uses raw file SHA-256 values in the package inventory' {
        foreach ($package in @($script:Result.skills)) {
            $skillRoot = Join-Path $script:RepositoryRoot ('skills/' + [string]$package.skillId)
            foreach ($entry in @($package.files)) {
                $expected = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $skillRoot $entry.path)).Hash.ToLowerInvariant()
                $entry.sha256 | Should -BeExactly $expected
            }
        }
    }

    It 'computes the deterministic package content digest' {
        foreach ($package in @($script:Result.skills)) {
            $canonical = @($package.files | ForEach-Object { [string]$_.path + "`t" + [string]$_.sha256 + "`n" }) -join ''
            $bytes = [Text.UTF8Encoding]::new($false).GetBytes($canonical)
            $expected = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes)).ToLowerInvariant()
            $package.contentSha256 | Should -BeExactly $expected
        }
    }
}
