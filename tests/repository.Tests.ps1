# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
$ErrorActionPreference = 'Stop'

$hostNeutralFiles = @(
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Required = '(?is)current\s+Windows,\s+Linux,\s+or\s+macOS\s+host' },
    @{ Path = 'skills/capture-private-course-knowledge/references/course-notes-format.md'; Required = '(?is)current\s+host.*source\s+platform\s+as\s+evidence.*another\s+host,\s+VM,\s+WSL,\s+or\s+container' },
    @{ Path = 'skills/capture-private-course-knowledge/references/notebooklm-export.md'; Required = '(?is)current\s+host.*another\s+host,\s+VM,\s+WSL,\s+or\s+container.*source\s+evidence' },
    @{ Path = 'skills/capture-private-course-knowledge/references/pdf-material-capture.md'; Required = '(?is)current\s+host.*partial\s+or\s+draft.*another\s+host,\s+VM,\s+WSL,\s+or\s+container.*source\s+evidence' },
    @{ Path = 'skills/capture-private-course-knowledge/references/syuantsai-github-article.md'; Required = '(?is)current\s+host.*cross-platform\s+course\s+code\s+and\s+commands\s+as\s+source\s+evidence.*another\s+host,\s+VM,\s+WSL,\s+or\s+container' },
    @{ Path = 'skills/capture-private-course-knowledge/references/video-capture.md'; Required = '(?is)current\s+host.*another\s+host,\s+VM,\s+WSL,\s+or\s+container.*source\s+evidence' },
    @{ Path = 'skills/capture-private-course-knowledge/agents/openai.yaml'; Required = '(?s)\$capture-private-course-knowledge' },
    @{ Path = 'README.md'; Required = '(?is)current\s+Windows,\s+Linux,\s+or\s+macOS\s+host.*partial\s+or\s+draft.*another\s+host,\s+VM,\s+WSL,\s+or\s+container.*source\s+evidence' },
    @{ Path = 'RELEASING.md'; Required = '(?is)Windows,\s+Linux,\s+or\s+macOS\s+hosts.*windows-latest.*ubuntu-latest.*macos-latest' }
)

BeforeAll {
    $script:repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

    function Read-TestReuseAnnotations {
        param([Parameter(Mandatory)][string] $LiteralPath)

        $annotations = [Collections.Generic.List[object]]::new()
        $current = $null
        foreach ($rawLine in Get-Content -LiteralPath $LiteralPath -Encoding utf8) {
            $line = $rawLine.Trim()
            if ($line.Length -eq 0 -or $line.StartsWith('#', [StringComparison]::Ordinal)) { continue }
            if ($line -ceq '[[annotations]]') {
                $current = [ordered]@{}
                $annotations.Add($current)
                continue
            }
            if ($null -eq $current) { continue }
            if ($line -notmatch '^(?<key>[A-Za-z0-9-]+)\s*=\s*(?<value>.+)$') {
                throw "Unsupported REUSE annotation syntax: $rawLine"
            }

            $key = [string]$Matches.key
            $encodedValue = [string]$Matches.value
            try {
                $value = ConvertFrom-Json -InputObject $encodedValue -ErrorAction Stop
            }
            catch {
                throw "REUSE annotation '$key' is not a supported TOML string or string array."
            }
            if ($key -ceq 'path') { $current[$key] = @($value | ForEach-Object { [string]$_ }) }
            else { $current[$key] = [string]$value }
        }
        return @($annotations)
    }

    function Test-ReusePathPattern {
        param([Parameter(Mandatory)][string] $Pattern, [Parameter(Mandatory)][string] $RelativePath)

        $normalizedPattern = $Pattern.Replace('\', '/')
        $normalizedPath = $RelativePath.Replace('\', '/')
        $regex = '^' + [regex]::Escape($normalizedPattern).Replace('\*\*', '.*').Replace('\*', '[^/]*') + '$'
        return [regex]::IsMatch($normalizedPath, $regex, [Text.RegularExpressions.RegexOptions]::CultureInvariant)
    }
}

Describe 'Knowledge & Content repository contract' {
    It 'validates the repository' {
        { & (Join-Path $script:repoRoot 'scripts/Test-Repository.ps1') -ReadOnlySnapshot } | Should -Not -Throw
    }

    It 'contains only declared top-level Skill directories' {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $script:repoRoot 'catalog/source.json') | ConvertFrom-Json
        $declared = @($source.skills | Sort-Object)
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:repoRoot 'skills') -Directory | ForEach-Object Name | Sort-Object)
        ($actual -join "`n") | Should -BeExactly ($declared -join "`n")
    }

    It 'keeps the stable source ID' {
        $source = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $script:repoRoot 'catalog/source.json') | ConvertFrom-Json
        $source.sourceId | Should -BeExactly 'knowledge-content'
    }

    It 'keeps every Skill manifest free of inline SPDX comments and covered by a parsed REUSE annotation' {
        $skillManifests = @(Get-ChildItem -LiteralPath (Join-Path $script:repoRoot 'skills') -Filter 'SKILL.md' -File -Recurse)
        $skillManifests.Count | Should -BeGreaterThan 0
        $annotations = @(Read-TestReuseAnnotations -LiteralPath (Join-Path $script:repoRoot 'REUSE.toml'))
        $annotations.Count | Should -BeGreaterThan 0

        foreach ($manifest in $skillManifests) {
            $content = Get-Content -LiteralPath $manifest.FullName -Raw -Encoding utf8
            $content | Should -Not -Match 'SPDX-(?:FileCopyrightText|License-Identifier)'
            $relativePath = [IO.Path]::GetRelativePath($script:repoRoot, $manifest.FullName).Replace('\', '/')
            $coveringAnnotations = @($annotations | Where-Object {
                    $_.Contains('path') -and
                    $_.Contains('SPDX-FileCopyrightText') -and -not [string]::IsNullOrWhiteSpace([string]$_['SPDX-FileCopyrightText']) -and
                    $_.Contains('SPDX-License-Identifier') -and -not [string]::IsNullOrWhiteSpace([string]$_['SPDX-License-Identifier']) -and
                    @($_.path | Where-Object { Test-ReusePathPattern -Pattern $_ -RelativePath $relativePath }).Count -gt 0
                })
            $coveringAnnotations.Count | Should -BeGreaterThan 0 -Because "$relativePath must have copyright and license coverage in REUSE.toml"
        }
    }
}

Describe 'Capture Private Course Knowledge host-neutral contract' {
    BeforeAll {
        $script:obsoleteHostRestriction = '(?im)(?:\bWindows[- ]only\b|\bWindows[- ]hosted\b|\bonly\s+(?:on|using)\s+(?:a\s+)?Windows\s+host\b|\buse\s+Windows\s+as\s+the\s+only\s+host\b|\bWindows\s+(?:is|remains)\s+the\s+only\s+host\b|\bmust\s+(?:only\s+)?(?:run|execute|operate)\s+(?:only\s+)?on\s+Windows\b|\bdo\s+not\s+use\s+Linux,\s*macOS(?:,\s*WSL)?\b|只(?:能|在|用)[^\r\n]{0,40}Windows[^\r\n]{0,20}主機)'
    }

    It 'keeps <Path> host-neutral with its required policy semantics' -ForEach $hostNeutralFiles {
        $content = Get-Content -LiteralPath (Join-Path $script:repoRoot $Path) -Raw -Encoding utf8
        $content | Should -Not -Match $script:obsoleteHostRestriction
        $content | Should -Match $Required
    }

    It 'preserves the complete local-host fallback and evidence boundary in SKILL.md' {
        $content = Get-Content -LiteralPath (Join-Path $script:repoRoot 'skills/capture-private-course-knowledge/SKILL.md') -Raw -Encoding utf8
        $content | Should -Match '(?is)required\s+local\s+tool\s+is\s+unavailable.*mark\s+the\s+affected\s+work\s+partial\s+or\s+draft'
        $content | Should -Match '(?is)do\s+not\s+switch\s+to\s+another\s+host,\s+VM,\s+WSL,\s+or\s+container\s+as\s+a\s+fallback'
        $content | Should -Match '(?is)Preserve\s+cross-platform\s+code\s+and\s+commands\s+found\s+in\s+course\s+materials\s+as\s+source\s+evidence'
    }

    It 'keeps OpenAI metadata host-neutral and retains the Skill invocation token' {
        $content = Get-Content -LiteralPath (Join-Path $script:repoRoot 'skills/capture-private-course-knowledge/agents/openai.yaml') -Raw -Encoding utf8
        $content | Should -Not -Match $script:obsoleteHostRestriction
        $content | Should -Match '(?s)\$capture-private-course-knowledge'
    }
}
