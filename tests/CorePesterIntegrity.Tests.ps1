# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0

Describe 'Complete repository test suite integrity' {
    BeforeAll {
        $script:RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
        $script:TestFiles = @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot 'tests') -Filter '*.Tests.ps1' -File | Sort-Object Name)
    }

    It 'contains only parseable PowerShell test files' {
        foreach ($file in $script:TestFiles) {
            $tokens = $null
            $errors = $null
            [void][Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)
            @($errors) | Should -HaveCount 0
        }
    }

    It 'contains at least one test case in every test file' {
        foreach ($file in $script:TestFiles) {
            $tokens = $null
            $errors = $null
            $ast = [Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)
            $cases = @($ast.FindAll({
                        param($node)
                        $node -is [Management.Automation.Language.CommandAst] -and $node.GetCommandName() -ceq 'It'
                    }, $true))
            $cases.Count | Should -BeGreaterThan 0
        }
    }

    It 'does not register skipped or inconclusive cases' {
        foreach ($file in $script:TestFiles) {
            $tokens = $null
            $errors = $null
            $ast = [Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)
            $forbiddenCommands = @($ast.FindAll({
                        param($node)
                        $node -is [Management.Automation.Language.CommandAst] -and $node.GetCommandName() -ceq 'Set-ItResult'
                    }, $true))
            $skipParameters = @($ast.FindAll({
                        param($node)
                        $node -is [Management.Automation.Language.CommandParameterAst] -and $node.ParameterName -ceq 'Skip'
                    }, $true))
            $forbiddenCommands | Should -HaveCount 0
            $skipParameters | Should -HaveCount 0
        }
    }

    It 'keeps the repository check free of host-specific executable names' {
        $path = Join-Path $script:RepositoryRoot 'scripts/Test-KnowledgeContentRepository.ps1'
        $text = Get-Content -Raw -LiteralPath $path
        $text | Should -Not -Match '(?i)pwsh\.exe'
        $text | Should -Not -Match '(?i)icacls'
        $text | Should -Not -Match 'Microsoft\.Win32'
    }
}
