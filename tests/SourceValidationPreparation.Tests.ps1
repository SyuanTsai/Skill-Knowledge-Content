# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0

Describe 'Consumer configuration preparation' {
    BeforeAll {
        $script:RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
        $script:PinPath = Join-Path $script:RepositoryRoot 'config/authority-pin.json'
        $script:GatePath = Join-Path $script:RepositoryRoot 'config/consumer-gate.json'
        $script:Pin = Get-Content -Raw -LiteralPath $script:PinPath | ConvertFrom-Json
        $script:Gate = Get-Content -Raw -LiteralPath $script:GatePath | ConvertFrom-Json
        $script:Source = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'catalog/source.json') | ConvertFrom-Json
    }

    It 'stores consumer JSON as UTF-8 without BOM and with a final LF' {
        foreach ($path in @($script:PinPath, $script:GatePath)) {
            $bytes = [IO.File]::ReadAllBytes($path)
            ($bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191) | Should -BeFalse
            $bytes[-1] | Should -Be 10
            [Text.UTF8Encoding]::new($false, $true).GetString($bytes) | Should -Not -Match "`r"
        }
    }

    It 'uses the exact authority pin property set' {
        (@($script:Pin.PSObject.Properties.Name) -join "`n") | Should -BeExactly (@('schemaVersion', 'repository', 'commit') -join "`n")
        $script:Pin.schemaVersion | Should -Be 1
        $script:Pin.commit | Should -Match '^[0-9a-f]{40}$'
    }

    It 'uses the exact consumer gate property set' {
        (@($script:Gate.PSObject.Properties.Name) -join "`n") | Should -BeExactly (@('schemaVersion', 'repositoryId', 'sourceRepository', 'activeSkills', 'repositoryChecks') -join "`n")
        $script:Gate.schemaVersion | Should -Be 1
        $script:Gate.repositoryId | Should -BeExactly 'skill-knowledge-content'
        $script:Gate.sourceRepository | Should -BeExactly $script:Source.repository
    }

    It 'binds active Skills exactly to the source inventory' {
        (@($script:Gate.activeSkills) -join "`n") | Should -BeExactly (@($script:Source.skills) -join "`n")
        @($script:Gate.activeSkills | Sort-Object -Unique) | Should -HaveCount @($script:Gate.activeSkills).Count
    }

    It 'points every declared check at an existing candidate path' {
        foreach ($check in @($script:Gate.repositoryChecks)) {
            (@($check.PSObject.Properties.Name) -join "`n") | Should -BeExactly (@('id', 'kind', 'path') -join "`n")
            Test-Path -LiteralPath (Join-Path $script:RepositoryRoot ([string]$check.path)) | Should -BeTrue
        }
    }
}
