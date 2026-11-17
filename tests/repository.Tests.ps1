# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
$ErrorActionPreference = 'Stop'

# Policy text is intentionally literal. Update these cases with any deliberate policy rewrite.
$requiredPolicyText = @(
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Text = 'Work only with content the user provides or can access through an authorized session.' },
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Text = 'Never request, inspect, extract, or store passwords, cookies, tokens, browser storage, or session data.' },
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Text = 'Do not bypass authentication, paywalls, DRM, playback restrictions, document protections, download controls, or provider safeguards.' },
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Text = 'Obtain approval before sending private material to an external transcription, OCR, vision, storage, or knowledge service, especially when it may incur cost.' },
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Text = "Run local development, installation, execution, testing, and acceptance on the user's current Windows, Linux, or macOS host. If a required local tool is unavailable there, report the tooling gap and mark the affected work partial or draft; do not switch to another host, VM, WSL, or container as a fallback. Authorized SaaS, browser, and API services remain available for course capture when the user permits them. Preserve cross-platform code and commands found in course materials as source evidence; do not execute them as host setup, and their presence does not change the local host. Each reference applies this boundary to its own local tools." },
    @{ Path = 'skills/capture-private-course-knowledge/references/course-notes-format.md'; Text = "Create and process local note files on the user's current host under the host boundary in ``SKILL.md``. Preserve course-supplied commands with their source platform as evidence; do not run them by switching to another host, VM, WSL, or container. Authorized SaaS, browser, and API services remain available when the user permits them." },
    @{ Path = 'skills/capture-private-course-knowledge/references/notebooklm-export.md'; Text = "Generate local export files and run local preparation tools on the user's current host. Use authorized Google Drive, NotebookLM, browser, or API services as SaaS destinations; do not use another host, VM, WSL, or container as a local fallback. Retain platform-specific course commands in the export as source evidence rather than executing them as host setup." },
    @{ Path = 'skills/capture-private-course-knowledge/references/pdf-material-capture.md'; Text = "Run local extraction, rendering, and OCR with tools available on the user's current host. If a needed tool is unavailable, report the tooling gap and mark the work partial or draft; do not switch to another host, VM, WSL, or container. Authorized SaaS/browser/API services remain in scope when the user permits their use, and cross-platform commands printed in the PDF remain source evidence." },
    @{ Path = 'skills/capture-private-course-knowledge/references/syuantsai-github-article.md'; Text = "Keep local research, editing, validation, and site builds on the user's current host. Use the site's authorized SaaS/browser/API services as needed, and preserve cross-platform course code and commands as source evidence. Use the site's documented toolchain for that host; if it is unavailable, report the gap and keep the article draft instead of switching to another host, VM, WSL, or container." },
    @{ Path = 'skills/capture-private-course-knowledge/references/video-capture.md'; Text = "Run local media inspection, transcription, and note preparation with tools available on the user's current host. Authorized course SaaS, browser playback, and API routes remain available; if a required local tool is unavailable, report the limitation or use an authorized service instead of switching to another host, VM, WSL, or container. Keep platform-specific code and commands shown in the course as source evidence." },
    @{ Path = 'skills/capture-private-course-knowledge/agents/openai.yaml'; Text = 'display_name: "Capture Private Course Knowledge"' },
    @{ Path = 'skills/capture-private-course-knowledge/agents/openai.yaml'; Text = 'short_description: "Unify course videos, PDFs, code, recall, and exports"' },
    @{ Path = 'skills/capture-private-course-knowledge/agents/openai.yaml'; Text = 'default_prompt: "Use $capture-private-course-knowledge to capture this authorized course across videos, PDFs, slides, code, and attachments as evidence-linked notes, then create the requested NotebookLM sources or website article. Preserve cross-platform course commands as source evidence."' },
    @{ Path = 'README.md'; Text = "The Skill instructions are host-neutral: local Agent work runs on the user's current Windows, Linux, or macOS host. When a required local tool is unavailable, the Skill reports the gap and marks the affected work partial or draft instead of switching to another host, VM, WSL, or container. Authorized SaaS, browser, and API services remain in scope when the user permits them; cross-platform course code and commands remain source evidence." },
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Text = 'If no safe, approved destination is available, stop before persistence and explain the blocker.' },
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Text = 'When a no-caption video, including one that requires unavailable audio, a scanned PDF, or a protected document cannot be processed with available authorized tools, mark the affected range inaccessible and preserve partial coverage accurately.' },
    @{ Path = 'skills/capture-private-course-knowledge/SKILL.md'; Text = 'If a public output cannot exclude private or unlicensed material, stop before persistence or publication and explain the blocker.' }
)

$forbiddenPolicyCases = @(
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md'); Text = 'Use Windows as the only host for local development, installation, execution, testing, acceptance, and CI. Do not use Linux, macOS, WSL, or Linux containers as host fallbacks. Authorized SaaS, browser, and API services remain available for course capture. Preserve cross-platform code and commands found in course materials as source evidence; their presence does not change the local host requirement.' },
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md'); Text = 'If authentication, MFA, or CAPTCHA blocks access, stop and request only the minimum user action needed to restore the authorized session.' },
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md'); Text = 'If every authorized route to a required material fails, stop and report the exact material and access gap instead of substituting public or inferred content.' },
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md'); Text = 'If the only remaining route would bypass protections, stop and explain the blocker.' },
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md'); Text = 'If private material would leave the current environment through transcription, OCR, vision, storage, or another external service, obtain explicit approval before sending it.' },
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md'); Text = 'Expected workflow:' },
    @{ Paths = @('skills/capture-private-course-knowledge/references/course-notes-format.md'); Text = 'Create and process local note files on Windows. Preserve course-supplied commands with their source platform as evidence; do not run them by switching the local host to Linux, macOS, WSL, or a Linux container. Authorized SaaS, browser, and API services remain available when the user permits them.' },
    @{ Paths = @('skills/capture-private-course-knowledge/references/notebooklm-export.md'); Text = 'Generate local export files and run local preparation tools on Windows only. Use authorized Google Drive, NotebookLM, browser, or API services as SaaS destinations; do not use Linux, macOS, WSL, or Linux containers as local-host fallbacks. Retain platform-specific course commands in the export as source evidence rather than executing them as host setup.' },
    @{ Paths = @('skills/capture-private-course-knowledge/references/pdf-material-capture.md'); Text = 'Run local extraction, rendering, and OCR with Windows-native tools. If a needed tool is unavailable, report the tooling gap and mark the work partial or draft; do not switch to Linux, macOS, WSL, or Linux containers. Authorized SaaS/browser/API services remain in scope when the user permits their use, and cross-platform commands printed in the PDF remain source evidence.' },
    @{ Paths = @('skills/capture-private-course-knowledge/references/syuantsai-github-article.md'); Text = "Keep local research, editing, validation, and site builds on Windows. Use the site's authorized SaaS/browser/API services as needed, and preserve cross-platform course code and commands as source evidence. Use the site's documented native Windows toolchain; if it is unavailable, report the gap and keep the article draft instead of switching to Linux, macOS, WSL, or Linux containers." },
    @{ Paths = @('skills/capture-private-course-knowledge/references/video-capture.md'); Text = 'Run local media inspection, transcription, and note preparation on Windows with Windows-native tools. Authorized course SaaS, browser playback, and API routes remain available; if a required local tool is unavailable, report the limitation or use an authorized service instead of switching to Linux, macOS, WSL, or Linux containers. Keep platform-specific code and commands shown in the course as source evidence.' },
    @{ Paths = @('skills/capture-private-course-knowledge/agents/openai.yaml'); Text = 'display_name: "Capture Private Course Knowledge (Windows)"' },
    @{ Paths = @('skills/capture-private-course-knowledge/agents/openai.yaml'); Text = 'short_description: "Windows-only: unify videos, PDFs, code, recall, and exports"' },
    @{ Paths = @('skills/capture-private-course-knowledge/agents/openai.yaml'); Text = 'default_prompt: "Use $capture-private-course-knowledge on Windows to capture this authorized course across videos, PDFs, slides, code, and attachments as evidence-linked notes, then create the requested NotebookLM sources or website article. Preserve cross-platform course commands as source evidence."' },
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md', 'skills/capture-private-course-knowledge/agents/openai.yaml'); Text = 'Windows-only' },
    @{ Paths = @('skills/capture-private-course-knowledge/agents/openai.yaml'); Text = '(Windows)' },
    @{ Paths = @('skills/capture-private-course-knowledge/agents/openai.yaml'); Text = 'on Windows' },
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md'); Text = 'If a no-caption video, scanned PDF, or protected document cannot be processed with available authorized tools, including when a no-caption video requires unavailable audio, mark the affected range inaccessible and preserve partial coverage accurately.' },
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md'); Text = 'If durable recall has no safe, approved destination, stop before persistence and explain the blocker.' },
    @{ Paths = @('skills/capture-private-course-knowledge/SKILL.md'); Text = 'If public output cannot avoid private or unlicensed material, stop before persistence or publication and explain the blocker.' }
)

for ($index = 0; $index -lt $requiredPolicyText.Count; $index++) { $requiredPolicyText[$index].CaseId = $index + 1 }
for ($index = 0; $index -lt $forbiddenPolicyCases.Count; $index++) { $forbiddenPolicyCases[$index].CaseId = $index + 1 }
$forbiddenCoverageCases = @(@{ ComparedCount = $forbiddenPolicyCases.Count; ExpectedCount = 20; CaseId = 1 })
$requiredCaseSensitivityCases = @(@{ RequiredText = $requiredPolicyText[0].Text; CaseId = 1 })
$forbiddenCaseSensitivityCases = @(@{ ForbiddenText = $forbiddenPolicyCases[14].Text; CaseId = 1 })

BeforeAll {
    $script:RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
    $script:CheckPath = Join-Path $script:RepositoryRoot 'scripts/Test-KnowledgeContentRepository.ps1'

    function Normalize-TestPolicyText {
        param([Parameter(Mandatory)][AllowEmptyString()][string] $Text)
        return [regex]::Replace($Text, '\s+', ' ').Trim()
    }

    function Test-RequiredPolicyText {
        param([Parameter(Mandatory)][AllowEmptyString()][string] $Content, [Parameter(Mandatory)][string] $RequiredText)
        return (Normalize-TestPolicyText -Text $Content).Contains((Normalize-TestPolicyText -Text $RequiredText), [StringComparison]::Ordinal)
    }

    function Test-ForbiddenPolicyText {
        param([Parameter(Mandatory)][AllowEmptyString()][string] $Content, [Parameter(Mandatory)][string] $ForbiddenText)
        $contentText = Normalize-TestPolicyText -Text $Content
        $forbidden = Normalize-TestPolicyText -Text $ForbiddenText
        return $contentText.Contains($forbidden, [StringComparison]::Ordinal) -or $contentText.Contains($forbidden, [StringComparison]::OrdinalIgnoreCase)
    }

    function New-PolicyFixture {
        $root = Join-Path $TestDrive ([Guid]::NewGuid().ToString('N'))
        [void](New-Item -ItemType Directory -Path (Join-Path $root 'catalog') -Force)
        [void](New-Item -ItemType Directory -Path (Join-Path $root 'skills') -Force)
        Copy-Item -LiteralPath (Join-Path $script:RepositoryRoot 'catalog/source.json') -Destination (Join-Path $root 'catalog/source.json')
        Copy-Item -LiteralPath (Join-Path $script:RepositoryRoot 'skills/capture-private-course-knowledge') -Destination (Join-Path $root 'skills') -Recurse
        return $root
    }

    function Complete-ReuseAnnotation {
        param([Collections.IDictionary] $Current, [Collections.Generic.List[object]] $Annotations)
        $actual = @($Current.Keys | Sort-Object -CaseSensitive)
        $expected = @('SPDX-FileCopyrightText', 'SPDX-License-Identifier', 'path', 'precedence') | Sort-Object -CaseSensitive
        if (($actual -join "`n") -cne ($expected -join "`n")) { throw 'REUSE annotation does not contain exactly the four required keys.' }
        $Annotations.Add([pscustomobject]$Current)
    }

    function Read-TestReuseAnnotations {
        param([Parameter(Mandatory)][string] $LiteralPath)
        $annotations = [Collections.Generic.List[object]]::new()
        $current = $null
        $versionSeen = $false
        $lineNumber = 0
        foreach ($rawLine in Get-Content -LiteralPath $LiteralPath -Encoding utf8) {
            $lineNumber++
            $line = $rawLine.Trim()
            if ($line.Length -eq 0 -or $line.StartsWith('#', [StringComparison]::Ordinal)) { continue }
            if ($line -eq 'version = 1') {
                if ($versionSeen -or $null -ne $current -or $annotations.Count -gt 0) { throw ('Invalid REUSE version declaration at line {0}.' -f $lineNumber) }
                $versionSeen = $true
                continue
            }
            if ($line -eq '[[annotations]]') {
                if ($null -ne $current) { Complete-ReuseAnnotation -Current $current -Annotations $annotations }
                $current = [ordered]@{}
                continue
            }
            if ($null -eq $current -or $line -notmatch '^(?<Key>path|precedence|SPDX-FileCopyrightText|SPDX-License-Identifier)\s*=\s*(?<Value>"(?:[^"\\]|\\.)*")$') {
                throw ('Unsupported REUSE syntax at line {0}.' -f $lineNumber)
            }
            $key = [string]$Matches.Key
            if ($current.Contains($key)) { throw ('Duplicate REUSE key at line {0}.' -f $lineNumber) }
            try { $current[$key] = [string](ConvertFrom-Json -InputObject ([string]$Matches.Value) -ErrorAction Stop) }
            catch { throw ('Invalid REUSE string value at line {0}.' -f $lineNumber) }
        }
        if (-not $versionSeen) { throw 'REUSE version declaration is missing.' }
        if ($null -ne $current) { Complete-ReuseAnnotation -Current $current -Annotations $annotations }
        if ($annotations.Count -eq 0) { throw 'REUSE annotations are missing.' }
        return @($annotations)
    }
}

Describe 'Consumer repository layout' {
    It 'contains only the repository check and authority bootstrap under scripts' {
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot 'scripts') -File | ForEach-Object Name | Sort-Object -CaseSensitive)
        $expected = @('Invoke-PinnedAuthority.ps1', 'Test-KnowledgeContentRepository.ps1')
        ($actual -join "`n") | Should -BeExactly ($expected -join "`n")
    }

    It 'contains exactly the consumer workflow pair' {
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot '.github/workflows') -File | ForEach-Object Name | Sort-Object -CaseSensitive)
        $expected = @('consumer-gate-transition.yml', 'consumer-gate.yml')
        ($actual -join "`n") | Should -BeExactly ($expected -join "`n")
    }

    It 'contains only consumer configuration files' {
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot 'config') -File | ForEach-Object Name | Sort-Object -CaseSensitive)
        $expected = @('authority-pin.json', 'consumer-gate.json')
        ($actual -join "`n") | Should -BeExactly ($expected -join "`n")
    }

    It 'keeps the gate identity consistent with source metadata' {
        $source = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'catalog/source.json') | ConvertFrom-Json
        $gate = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'config/consumer-gate.json') | ConvertFrom-Json
        $gate.sourceRepository | Should -BeExactly $source.repository
        (@($gate.activeSkills) -join "`n") | Should -BeExactly (@($source.skills) -join "`n")
    }
}

Describe 'REUSE annotation contract' {
    It 'keeps every Skill manifest free of inline SPDX comments' {
        $manifests = @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot 'skills') -Filter 'SKILL.md' -File -Recurse)
        $manifests.Count | Should -BeGreaterThan 0
        foreach ($manifest in $manifests) {
            $content = Get-Content -Raw -LiteralPath $manifest.FullName
            $content.Contains('SPDX-FileCopyrightText', [StringComparison]::Ordinal) | Should -BeFalse
            $content.Contains('SPDX-License-Identifier', [StringComparison]::Ordinal) | Should -BeFalse
        }
    }

    It 'provides one exact annotation for every protected file without an inline header' {
        $annotations = @(Read-TestReuseAnnotations -LiteralPath (Join-Path $script:RepositoryRoot 'REUSE.toml'))
        $allFiles = @(Get-ChildItem -LiteralPath $script:RepositoryRoot -Recurse -File | ForEach-Object {
                [IO.Path]::GetRelativePath($script:RepositoryRoot, $_.FullName).Replace([IO.Path]::DirectorySeparatorChar, '/')
            })
        foreach ($annotation in $annotations) {
            $pattern = [Management.Automation.WildcardPattern]::new($annotation.path, [Management.Automation.WildcardOptions]::CultureInvariant)
            @($allFiles | Where-Object { $pattern.IsMatch($_) }).Count | Should -BeGreaterThan 0
        }
        $protected = @('catalog/source.json', 'config/authority-pin.json', 'config/consumer-gate.json', '.github/workflows/consumer-gate.yml', '.github/workflows/consumer-gate-transition.yml')
        $protected += @(Get-ChildItem -LiteralPath (Join-Path $script:RepositoryRoot 'skills') -Filter 'SKILL.md' -File -Recurse | ForEach-Object {
                [IO.Path]::GetRelativePath($script:RepositoryRoot, $_.FullName).Replace([IO.Path]::DirectorySeparatorChar, '/')
            })
        foreach ($path in $protected) {
            $content = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot $path)
            $hasCopyright = $content.Contains('SPDX-FileCopyrightText', [StringComparison]::Ordinal)
            $hasLicense = $content.Contains('SPDX-License-Identifier', [StringComparison]::Ordinal)
            if ($hasCopyright -or $hasLicense) {
                $hasCopyright | Should -BeTrue
                $hasLicense | Should -BeTrue
                continue
            }
            $matches = @($annotations | Where-Object {
                    [Management.Automation.WildcardPattern]::new($_.path, [Management.Automation.WildcardOptions]::CultureInvariant).IsMatch($path)
                })
            $matches | Should -HaveCount 1
            $matches[0].precedence | Should -BeExactly 'aggregate'
            $matches[0].'SPDX-FileCopyrightText' | Should -BeExactly '2026 SyuanTsai'
            $matches[0].'SPDX-License-Identifier' | Should -BeExactly 'Apache-2.0'
        }
    }

    It 'requires both fields in every inline SPDX header' {
        foreach ($file in Get-ChildItem -LiteralPath $script:RepositoryRoot -Recurse -File) {
            $content = Get-Content -Raw -LiteralPath $file.FullName
            $hasCopyright = $content.Contains('SPDX-FileCopyrightText', [StringComparison]::Ordinal)
            $hasLicense = $content.Contains('SPDX-License-Identifier', [StringComparison]::Ordinal)
            if ($hasCopyright -or $hasLicense) {
                $hasCopyright | Should -BeTrue
                $hasLicense | Should -BeTrue
            }
        }
    }

    It 'rejects an annotation missing one required line' {
        $fixturePath = Join-Path $TestDrive 'REUSE.toml'
        $text = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot 'REUSE.toml')
        $mutated = [regex]::Replace($text, '(?m)^SPDX-License-Identifier = "Apache-2\.0"\r?\n', '', 1)
        $mutated | Should -Not -BeExactly $text
        [IO.File]::WriteAllText($fixturePath, $mutated, [Text.UTF8Encoding]::new($false))
        { Read-TestReuseAnnotations -LiteralPath $fixturePath } | Should -Throw '*does not contain exactly the four required keys*'
    }
}

Describe 'Capture Private Course Knowledge literal policy contract' {
    It 'preserves required literal policy text in <Path> #<CaseId>' -ForEach $requiredPolicyText {
        $content = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot $Path)
        (Test-RequiredPolicyText -Content $content -RequiredText $Text) | Should -BeTrue
    }

    It 'keeps forbidden policy text case <CaseId> out of its policy files' -ForEach $forbiddenPolicyCases {
        $Paths.Count | Should -BeGreaterThan 0
        foreach ($path in $Paths) {
            $content = Get-Content -Raw -LiteralPath (Join-Path $script:RepositoryRoot $path)
            (Test-ForbiddenPolicyText -Content $content -ForbiddenText $Text) | Should -BeFalse
        }
    }

    It 'compares exactly every forbidden policy entry #<CaseId>' -ForEach $forbiddenCoverageCases {
        $ComparedCount | Should -BeGreaterThan 0
        $ComparedCount | Should -Be $ExpectedCount
    }

    It 'treats a one-letter case change as missing required text #<CaseId>' -ForEach $requiredCaseSensitivityCases {
        $changedCase = 'w' + $RequiredText.Substring(1)
        (Test-RequiredPolicyText -Content $changedCase -RequiredText $RequiredText) | Should -BeFalse
    }

    It 'detects a lowercase forbidden text insertion #<CaseId>' -ForEach $forbiddenCaseSensitivityCases {
        $insertion = 'prefix ' + $ForbiddenText.ToLowerInvariant() + ' suffix'
        (Test-ForbiddenPolicyText -Content $insertion -ForbiddenText $ForbiddenText) | Should -BeTrue
    }
}

Describe 'OpenAI metadata field contract through the repository check' {
    It 'accepts all supported optional OpenAI interface fields' {
        $fixture = New-PolicyFixture
        $path = Join-Path $fixture 'skills/capture-private-course-knowledge/agents/openai.yaml'
        $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false, $true))
        $needle = '  default_prompt: "Use $capture-private-course-knowledge to capture this authorized course across videos, PDFs, slides, code, and attachments as evidence-linked notes, then create the requested NotebookLM sources or website article. Preserve cross-platform course commands as source evidence."'
        $replacement = $needle + "`n" + '  icon_small: "./assets/icon-small.svg"' + "`n" + '  icon_large: "./assets/icon-large.svg"' + "`n" + '  brand_color: "#123456"'
        $mutated = $text.Replace($needle, $replacement)
        $mutated | Should -Not -BeExactly $text
        [IO.File]::WriteAllText($path, $mutated, [Text.UTF8Encoding]::new($false))
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Not -Throw
    }

    It 'rejects an unknown OpenAI interface field' {
        $fixture = New-PolicyFixture
        $path = Join-Path $fixture 'skills/capture-private-course-knowledge/agents/openai.yaml'
        $text = [IO.File]::ReadAllText($path, [Text.UTF8Encoding]::new($false, $true))
        $needle = '  default_prompt: "Use $capture-private-course-knowledge to capture this authorized course across videos, PDFs, slides, code, and attachments as evidence-linked notes, then create the requested NotebookLM sources or website article. Preserve cross-platform course commands as source evidence."'
        $mutated = $text.Replace($needle, $needle + "`n" + '  unknown_field: "must be rejected"')
        $mutated | Should -Not -BeExactly $text
        [IO.File]::WriteAllText($path, $mutated, [Text.UTF8Encoding]::new($false))
        { & $script:CheckPath -RepositoryRoot $fixture -ReadOnlySnapshot } | Should -Throw '*unsupported or duplicate interface key*'
    }
}
