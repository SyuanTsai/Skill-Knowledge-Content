# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
$ErrorActionPreference = 'Stop'

$hostNeutralPolicyCases = @(
    @{
        Path = 'skills/capture-private-course-knowledge/references/course-notes-format.md'
        Required = '(?is)current\s+host.*source\s+platform\s+as\s+evidence.*do\s+not\s+run\s+them\s+by\s+switching\s+to\s+another\s+host,\s+VM,\s+WSL,\s+or\s+container'
        Positive = 'current host; source platform as evidence; do not run them by switching to another host, VM, WSL, or container'
        Negative = 'current host; source platform as evidence; run them by switching to another host, VM, WSL, or container'
    },
    @{
        Path = 'skills/capture-private-course-knowledge/references/notebooklm-export.md'
        Required = '(?is)current\s+host.*do\s+not\s+use\s+another\s+host,\s+VM,\s+WSL,\s+or\s+container.*source\s+evidence'
        Positive = 'current host; do not use another host, VM, WSL, or container; source evidence'
        Negative = 'current host; use another host, VM, WSL, or container; source evidence'
    },
    @{
        Path = 'skills/capture-private-course-knowledge/references/pdf-material-capture.md'
        Required = '(?is)current\s+host.*partial\s+or\s+draft.*do\s+not\s+switch\s+to\s+another\s+host,\s+VM,\s+WSL,\s+or\s+container.*source\s+evidence'
        Positive = 'current host; partial or draft; do not switch to another host, VM, WSL, or container; source evidence'
        Negative = 'current host; partial or draft; switch to another host, VM, WSL, or container; source evidence'
    },
    @{
        Path = 'skills/capture-private-course-knowledge/references/syuantsai-github-article.md'
        Required = '(?is)current\s+host.*cross-platform\s+course\s+code\s+and\s+commands\s+as\s+source\s+evidence.*instead\s+of\s+switching\s+to\s+another\s+host,\s+VM,\s+WSL,\s+or\s+container'
        Positive = 'current host; cross-platform course code and commands as source evidence; instead of switching to another host, VM, WSL, or container'
        Negative = 'current host; cross-platform course code and commands as source evidence; switching to another host, VM, WSL, or container'
    },
    @{
        Path = 'skills/capture-private-course-knowledge/references/video-capture.md'
        Required = '(?is)current\s+host.*instead\s+of\s+switching\s+to\s+another\s+host,\s+VM,\s+WSL,\s+or\s+container.*source\s+evidence'
        Positive = 'current host; instead of switching to another host, VM, WSL, or container; source evidence'
        Negative = 'current host; switching to another host, VM, WSL, or container; source evidence'
    },
    @{
        Path = 'README.md'
        Required = '(?is)current\s+Windows,\s+Linux,\s+or\s+macOS\s+host.*partial\s+or\s+draft.*instead\s+of\s+switching\s+to\s+another\s+host,\s+VM,\s+WSL,\s+or\s+container.*source\s+evidence'
        Positive = 'current Windows, Linux, or macOS host; partial or draft; instead of switching to another host, VM, WSL, or container; source evidence'
        Negative = 'current Windows, Linux, or macOS host; partial or draft; switching to another host, VM, WSL, or container; source evidence'
    }
)

$hostNeutralFiles = @(
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Required = '(?is)current\s+Windows,\s+Linux,\s+or\s+macOS\s+host' }
) + $hostNeutralPolicyCases + @(
    @{ Path = 'skills/capture-private-course-knowledge/agents/openai.yaml'; Required = '(?s)\$capture-private-course-knowledge' },
    @{ Path = 'RELEASING.md'; Required = '(?is)Windows,\s+Linux,\s+or\s+macOS\s+hosts.*windows-latest.*ubuntu-latest.*macos-latest' }
)

BeforeAll {
    $script:repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

    function Read-TestReuseAnnotations {
        param([Parameter(Mandatory)][string] $LiteralPath)

        $annotations = [Collections.Generic.List[object]]::new()
        $current = $null
        $lineNumber = 0
        foreach ($rawLine in Get-Content -LiteralPath $LiteralPath -Encoding utf8) {
            $lineNumber++
            $line = $rawLine.Trim()
            if ($line.Length -eq 0 -or $line.StartsWith('#', [StringComparison]::Ordinal)) { continue }
            if ($line -ceq '[[annotations]]') {
                $current = [ordered]@{}
                $annotations.Add($current)
                continue
            }
            if ($null -eq $current) { continue }
            if ($line -notmatch '^(?<key>[A-Za-z0-9-]+)\s*=\s*(?<value>.+)$') {
                throw "Unsupported REUSE annotation syntax at line $lineNumber."
            }

            $key = [string]$Matches.key
            $value = ConvertFrom-TestTomlValue -Text ([string]$Matches.value) -LineNumber $lineNumber
            if ($value -is [array]) {
                if ($key -cne 'path') {
                    throw "Unsupported TOML array for REUSE annotation '$key' at line $lineNumber."
                }
                $current[$key] = @($value | ForEach-Object { [string]$_ })
            }
            elseif ($key -ceq 'path') {
                $current[$key] = @([string]$value)
            }
            else { $current[$key] = [string]$value }
        }
        return @($annotations)
    }

    function ConvertFrom-TestTomlValue {
        param(
            [Parameter(Mandatory)][string] $Text,
            [Parameter(Mandatory)][int] $LineNumber
        )

        $state = [pscustomobject]@{ Index = 0 }
        function Skip-Whitespace { while ($state.Index -lt $Text.Length -and [char]::IsWhiteSpace($Text[$state.Index])) { $state.Index++ } }
        function Read-TomlString {
            Skip-Whitespace
            if ($state.Index -ge $Text.Length -or ($Text[$state.Index] -ne '"' -and $Text[$state.Index] -ne "'")) {
                throw "Expected a TOML string at line $LineNumber."
            }
            $quote = $Text[$state.Index]
            $state.Index++
            $builder = [Text.StringBuilder]::new()
            while ($state.Index -lt $Text.Length) {
                $character = $Text[$state.Index]
                $state.Index++
                if ($character -eq $quote) { return $builder.ToString() }
                if ($quote -eq "'" -or $character -ne '\') {
                    [void]$builder.Append($character)
                    continue
                }
                if ($state.Index -ge $Text.Length) { throw "Unterminated TOML escape at line $LineNumber." }
                $escape = $Text[$state.Index]
                $state.Index++
                switch -CaseSensitive ($escape) {
                    '"' { [void]$builder.Append('"') }
                    '\' { [void]$builder.Append('\') }
                    'b' { [void]$builder.Append([char]8) }
                    't' { [void]$builder.Append("`t") }
                    'n' { [void]$builder.Append("`n") }
                    'f' { [void]$builder.Append([char]12) }
                    'r' { [void]$builder.Append("`r") }
                    default { throw "Unsupported TOML escape '\$escape' at line $LineNumber." }
                }
            }
            throw "Unterminated TOML string at line $LineNumber."
        }
        function Assert-TomlRemainder {
            Skip-Whitespace
            if ($state.Index -lt $Text.Length -and $Text[$state.Index] -ne '#') {
                throw "Unsupported TOML syntax at line $LineNumber."
            }
        }

        Skip-Whitespace
        if ($state.Index -lt $Text.Length -and $Text[$state.Index] -eq '[') {
            $state.Index++
            $values = [Collections.Generic.List[string]]::new()
            Skip-Whitespace
            if ($state.Index -lt $Text.Length -and $Text[$state.Index] -eq ']') {
                $state.Index++
                Assert-TomlRemainder
                return ,$values.ToArray()
            }
            while ($true) {
                $values.Add((Read-TomlString))
                Skip-Whitespace
                if ($state.Index -ge $Text.Length) { throw "Unterminated TOML array at line $LineNumber." }
                if ($Text[$state.Index] -eq ']') {
                    $state.Index++
                    Assert-TomlRemainder
                    return ,$values.ToArray()
                }
                if ($Text[$state.Index] -ne ',') { throw "Expected ',' or ']' in TOML array at line $LineNumber." }
                $state.Index++
                Skip-Whitespace
                if ($state.Index -lt $Text.Length -and $Text[$state.Index] -eq ']') {
                    $state.Index++
                    Assert-TomlRemainder
                    return ,$values.ToArray()
                }
            }
        }

        $scalar = Read-TomlString
        Assert-TomlRemainder
        return $scalar
    }

    function Read-TestOpenAiInterface {
        param([Parameter(Mandatory)][string] $LiteralPath)

        $fields = [ordered]@{}
        $inInterface = $false
        $lineNumber = 0
        foreach ($rawLine in Get-Content -LiteralPath $LiteralPath -Encoding utf8) {
            $lineNumber++
            if ($rawLine -match '^interface:\s*(?:#.*)?$') { $inInterface = $true; continue }
            if (-not $inInterface -or $rawLine -match '^\s*(?:#.*)?$') { continue }
            if ($rawLine -notmatch '^\s{2}(?<key>display_name|short_description|default_prompt):\s*(?<value>.+?)\s*$') {
                if ($rawLine -notmatch '^\s') { break }
                throw "Unsupported OpenAI interface metadata at line $lineNumber."
            }
            try { $fields[[string]$Matches.key] = [string](ConvertFrom-Json -InputObject ([string]$Matches.value) -ErrorAction Stop) }
            catch { throw "OpenAI interface metadata at line $lineNumber must use a quoted scalar." }
        }
        foreach ($requiredField in @('display_name', 'short_description', 'default_prompt')) {
            if (-not $fields.Contains($requiredField)) { throw "OpenAI interface metadata is missing '$requiredField'." }
        }
        return $fields
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

    It 'parses supported REUSE TOML string forms in <Name>' -ForEach @(
        @{ Name = 'trailing comment'; Value = '"skills/**/SKILL.md" # cover manifests'; Expected = @('skills/**/SKILL.md') },
        @{ Name = 'path array'; Value = '["skills/**/SKILL.md", ''docs/*.md'']'; Expected = @('skills/**/SKILL.md', 'docs/*.md') },
        @{ Name = 'literal string'; Value = "'skills/**/SKILL.md'"; Expected = @('skills/**/SKILL.md') },
        @{ Name = 'escaped basic string'; Value = '"skills/quoted\\name/SKILL.md"'; Expected = @('skills/quoted\name/SKILL.md') }
    ) {
        $fixturePath = Join-Path $TestDrive ("reuse-{0}.toml" -f ($Name -replace '[^a-z]', '-'))
        @("[[annotations]]", "path = $Value") | Set-Content -LiteralPath $fixturePath -Encoding utf8
        $parsed = @(Read-TestReuseAnnotations -LiteralPath $fixturePath)
        @($parsed[0].path) | Should -Be $Expected
    }

    It 'rejects malformed REUSE TOML with the source line number' {
        $fixturePath = Join-Path $TestDrive 'reuse-malformed.toml'
        @('[[annotations]]', 'path = ["skills/**/SKILL.md"') | Set-Content -LiteralPath $fixturePath -Encoding utf8
        { Read-TestReuseAnnotations -LiteralPath $fixturePath } | Should -Throw '*line 2*'
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

    It 'requires an explicit negative host-switching relationship for <Path>' -ForEach $hostNeutralPolicyCases {
        $Positive | Should -Match $Required
        $Negative | Should -Not -Match $Required
    }

    It 'preserves the complete local-host fallback and evidence boundary in SKILL.md' {
        $content = Get-Content -LiteralPath (Join-Path $script:repoRoot 'skills/capture-private-course-knowledge/SKILL.md') -Raw -Encoding utf8
        $content | Should -Match '(?is)required\s+local\s+tool\s+is\s+unavailable.*mark\s+the\s+affected\s+work\s+partial\s+or\s+draft'
        $content | Should -Match '(?is)do\s+not\s+switch\s+to\s+another\s+host,\s+VM,\s+WSL,\s+or\s+container\s+as\s+a\s+fallback'
        $content | Should -Match '(?is)Preserve\s+cross-platform\s+code\s+and\s+commands\s+found\s+in\s+course\s+materials\s+as\s+source\s+evidence'
    }

    It 'keeps each parsed OpenAI metadata field host-neutral and retains the Skill invocation token' {
        $metadata = Read-TestOpenAiInterface -LiteralPath (Join-Path $script:repoRoot 'skills/capture-private-course-knowledge/agents/openai.yaml')
        $legacyMetadataRestriction = '(?i)(?:\(\s*Windows\s*\)|\bWindows[- ]only\b|\bon\s+Windows\b|\bWindows\s+host\b)'
        $metadata.display_name | Should -Not -Match $legacyMetadataRestriction
        $metadata.short_description | Should -Not -Match $legacyMetadataRestriction
        $metadata.default_prompt | Should -Not -Match $legacyMetadataRestriction
        $metadata.default_prompt | Should -Match '\$capture-private-course-knowledge'
    }

    It 'detects legacy Windows restrictions in OpenAI <Field>' -ForEach @(
        @{ Field = 'display_name'; Value = 'Capture Private Course Knowledge (Windows)' },
        @{ Field = 'short_description'; Value = 'Windows-only private course capture' },
        @{ Field = 'default_prompt'; Value = 'Use $capture-private-course-knowledge on Windows' },
        @{ Field = 'default_prompt'; Value = 'Run this Skill on a Windows host' }
    ) {
        $Value | Should -Match '(?i)(?:\(\s*Windows\s*\)|\bWindows[- ]only\b|\bon\s+Windows\b|\bWindows\s+host\b)'
    }
}
