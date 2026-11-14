# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
$ErrorActionPreference = 'Stop'

# 改寫任何政策句時，必須同步更新本清單；本測試刻意逐字比對。
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
    @{ Path = 'README.md'; Text = 'Canonical repository validation runs on GitHub Actions as three parallel matrix legs, `windows-latest` (x64), `ubuntu-latest` (x64), and `macos-latest` (arm64), then aggregates all three receipts on Ubuntu and runs the required status mirrors on Ubuntu. These legs validate the repository contract and regression suite on each platform; they are not end-to-end course-capture acceptance runs.' },
    @{ Path = 'RELEASING.md'; Text = 'Local Agent development may run on Windows, Linux, or macOS hosts. Canonical CI runs parallel `windows-latest` (x64), `ubuntu-latest` (x64), and `macos-latest` (arm64) validation legs, aggregates all three receipts on Ubuntu, and hosts the three required status mirrors on Ubuntu. A release requires all three legs and the aggregate to pass.' }
)

$forbiddenText = @(
    'Use Windows as the only host for local development, installation, execution, testing, acceptance, and CI. Do not use Linux, macOS, WSL, or Linux containers as host fallbacks. Authorized SaaS, browser, and API services remain available for course capture. Preserve cross-platform code and commands found in course materials as source evidence; their presence does not change the local host requirement.',
    'If authentication, MFA, or CAPTCHA blocks access, stop and request only the minimum user action needed to restore the authorized session.',
    'If every authorized route to a required material fails, stop and report the exact material and access gap instead of substituting public or inferred content.',
    'If the only remaining route would bypass protections, stop and explain the blocker.',
    'If private material would leave the current environment through transcription, OCR, vision, storage, or another external service, obtain explicit approval before sending it.',
    'Expected workflow:',
    'Create and process local note files on Windows. Preserve course-supplied commands with their source platform as evidence; do not run them by switching the local host to Linux, macOS, WSL, or a Linux container. Authorized SaaS, browser, and API services remain available when the user permits them.',
    'Generate local export files and run local preparation tools on Windows only. Use authorized Google Drive, NotebookLM, browser, or API services as SaaS destinations; do not use Linux, macOS, WSL, or Linux containers as local-host fallbacks. Retain platform-specific course commands in the export as source evidence rather than executing them as host setup.',
    'Run local extraction, rendering, and OCR with Windows-native tools. If a needed tool is unavailable, report the tooling gap and mark the work partial or draft; do not switch to Linux, macOS, WSL, or Linux containers. Authorized SaaS/browser/API services remain in scope when the user permits their use, and cross-platform commands printed in the PDF remain source evidence.',
    'Keep local research, editing, validation, and site builds on Windows. Use the site''s authorized SaaS/browser/API services as needed, and preserve cross-platform course code and commands as source evidence. Use the site''s documented native Windows toolchain; if it is unavailable, report the gap and keep the article draft instead of switching to Linux, macOS, WSL, or Linux containers.',
    'Run local media inspection, transcription, and note preparation on Windows with Windows-native tools. Authorized course SaaS, browser playback, and API routes remain available; if a required local tool is unavailable, report the limitation or use an authorized service instead of switching to Linux, macOS, WSL, or Linux containers. Keep platform-specific code and commands shown in the course as source evidence.',
    'Local Agent development, installation, execution, testing, and acceptance remain Windows-hosted. Canonical repository validation is the required exception: GitHub Actions runs Windows, Linux, and macOS matrix legs, aggregates them on Ubuntu, and runs the required status mirrors on Ubuntu. Authorized SaaS, browser, and API services remain in scope; cross-platform course code and commands remain source evidence.',
    'Local Agent development remains Windows-hosted. Canonical CI is the required exception: it runs parallel `windows-latest`, `ubuntu-latest`, and `macos-latest` validation legs, aggregates all three receipts on Ubuntu, and hosts the three required status mirrors on Ubuntu.',
    'display_name: "Capture Private Course Knowledge (Windows)"',
    'short_description: "Windows-only: unify videos, PDFs, code, recall, and exports"',
    'default_prompt: "Use $capture-private-course-knowledge on Windows to capture this authorized course across videos, PDFs, slides, code, and attachments as evidence-linked notes, then create the requested NotebookLM sources or website article. Preserve cross-platform course commands as source evidence."',
    'Windows-only',
    'Windows-hosted',
    '(Windows)',
    'on Windows'
)

$forbiddenTextPaths = @{
    $forbiddenText[0] = @('skills/capture-private-course-knowledge/SKILL.md')
    $forbiddenText[1] = @('skills/capture-private-course-knowledge/SKILL.md')
    $forbiddenText[2] = @('skills/capture-private-course-knowledge/SKILL.md')
    $forbiddenText[3] = @('skills/capture-private-course-knowledge/SKILL.md')
    $forbiddenText[4] = @('skills/capture-private-course-knowledge/SKILL.md')
    $forbiddenText[5] = @('skills/capture-private-course-knowledge/SKILL.md')
    $forbiddenText[6] = @('skills/capture-private-course-knowledge/references/course-notes-format.md')
    $forbiddenText[7] = @('skills/capture-private-course-knowledge/references/notebooklm-export.md')
    $forbiddenText[8] = @('skills/capture-private-course-knowledge/references/pdf-material-capture.md')
    $forbiddenText[9] = @('skills/capture-private-course-knowledge/references/syuantsai-github-article.md')
    $forbiddenText[10] = @('skills/capture-private-course-knowledge/references/video-capture.md')
    $forbiddenText[11] = @('README.md')
    $forbiddenText[12] = @('RELEASING.md')
    $forbiddenText[13] = @('skills/capture-private-course-knowledge/agents/openai.yaml')
    $forbiddenText[14] = @('skills/capture-private-course-knowledge/agents/openai.yaml')
    $forbiddenText[15] = @('skills/capture-private-course-knowledge/agents/openai.yaml')
    $forbiddenText[16] = @('skills/capture-private-course-knowledge/SKILL.md', 'skills/capture-private-course-knowledge/agents/openai.yaml')
    $forbiddenText[17] = @('README.md', 'RELEASING.md')
    $forbiddenText[18] = @('skills/capture-private-course-knowledge/agents/openai.yaml')
    $forbiddenText[19] = @('skills/capture-private-course-knowledge/agents/openai.yaml')
}
$reuseSkillAnnotationText = @'
[[annotations]]
path = "skills/**/SKILL.md"
precedence = "aggregate"
SPDX-FileCopyrightText = "2026 SyuanTsai"
SPDX-License-Identifier = "Apache-2.0"
'@

BeforeAll {
    $script:repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

    function Normalize-TestPolicyText {
        param([Parameter(Mandatory)][AllowEmptyString()][string] $Text)
        return [regex]::Replace($Text, '\s+', ' ').Trim()
    }

    function Test-RequiredPolicyText {
        param([Parameter(Mandatory)][AllowEmptyString()][string] $Content, [Parameter(Mandatory)][string] $RequiredText)
        $normalizedContent = Normalize-TestPolicyText -Text $Content
        $normalizedRequired = Normalize-TestPolicyText -Text $RequiredText
        return $normalizedContent.Contains($normalizedRequired, [StringComparison]::Ordinal)
    }

    function Test-ForbiddenPolicyText {
        param([Parameter(Mandatory)][AllowEmptyString()][string] $Content, [Parameter(Mandatory)][string] $ForbiddenText)
        $normalizedContent = Normalize-TestPolicyText -Text $Content
        $normalizedForbidden = Normalize-TestPolicyText -Text $ForbiddenText
        $hasExactText = $normalizedContent.Contains($normalizedForbidden, [StringComparison]::Ordinal)
        $hasCaseInsensitiveText = $normalizedContent.ToLowerInvariant().Contains($normalizedForbidden.ToLowerInvariant(), [StringComparison]::Ordinal)
        return $hasExactText -or $hasCaseInsensitiveText
    }

    function Read-TestOpenAiInterface {
        param([Parameter(Mandatory)][string] $LiteralPath)
        $allowedFields = @('display_name', 'short_description', 'default_prompt', 'icon_small', 'icon_large', 'brand_color')
        $fields = [ordered]@{}
        $inInterface = $false
        $lineNumber = 0
        foreach ($rawLine in Get-Content -LiteralPath $LiteralPath -Encoding utf8) {
            $lineNumber++
            if ($rawLine -match '^interface:\s*(?:#.*)?$') { $inInterface = $true; continue }
            if (-not $inInterface -or $rawLine -match '^\s*(?:#.*)?$') { continue }
            if ($rawLine -notmatch '^\s{2}(?<key>[a-z_]+):\s*(?<value>.+?)\s*$') {
                if ($rawLine -notmatch '^\s') { break }
                throw "Unsupported OpenAI interface metadata at line $lineNumber."
            }
            if ([string]$Matches.key -cnotin $allowedFields -or $fields.Contains([string]$Matches.key)) {
                throw "Unsupported or duplicate OpenAI interface metadata at line $lineNumber."
            }
            try { $fields[[string]$Matches.key] = [string](ConvertFrom-Json -InputObject ([string]$Matches.value) -ErrorAction Stop) }
            catch { throw "OpenAI interface metadata at line $lineNumber must use a quoted scalar." }
        }
        foreach ($requiredField in @('display_name', 'short_description', 'default_prompt')) {
            if (-not $fields.Contains($requiredField)) { throw "OpenAI interface metadata is missing '$requiredField'." }
        }
        return $fields
    }
}

Describe 'Knowledge & Content repository contract' {
    It 'validates the repository' {
        { & (Join-Path $script:repoRoot 'scripts/Test-Repository.ps1') -ReadOnlySnapshot } | Should -Not -Throw
    }

    It 'contains only declared top-level Skill directories' {
        $source = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $script:repoRoot 'catalog/source.json') | ConvertFrom-Json
        $declared = @($source.skills | Sort-Object)
        $actual = @(Get-ChildItem -LiteralPath (Join-Path $script:repoRoot 'skills') -Directory | ForEach-Object Name | Sort-Object)
        ($actual -join "`n") | Should -BeExactly ($declared -join "`n")
    }

    It 'keeps the stable source ID' {
        $source = Get-Content -Raw -Encoding utf8 -LiteralPath (Join-Path $script:repoRoot 'catalog/source.json') | ConvertFrom-Json
        $source.sourceId | Should -BeExactly 'knowledge-content'
    }

    It 'keeps every Skill manifest free of inline SPDX comments and covered by the exact REUSE annotation' {
        $skillManifests = @(Get-ChildItem -LiteralPath (Join-Path $script:repoRoot 'skills') -Filter 'SKILL.md' -File -Recurse)
        $skillManifests.Count | Should -BeGreaterThan 0
        foreach ($manifest in $skillManifests) {
            $content = Get-Content -LiteralPath $manifest.FullName -Raw -Encoding utf8
            $content.Contains('SPDX-FileCopyrightText', [StringComparison]::Ordinal) | Should -BeFalse
            $content.Contains('SPDX-License-Identifier', [StringComparison]::Ordinal) | Should -BeFalse
        }
        $reuseContent = Get-Content -LiteralPath (Join-Path $script:repoRoot 'REUSE.toml') -Raw -Encoding utf8
        (Test-RequiredPolicyText -Content $reuseContent -RequiredText $reuseSkillAnnotationText) | Should -BeTrue
    }
}

Describe 'Capture Private Course Knowledge literal policy contract' {
    It 'preserves the required literal policy text in <Path>' -ForEach $requiredPolicyText {
        $content = Get-Content -LiteralPath (Join-Path $script:repoRoot $Path) -Raw -Encoding utf8
        (Test-RequiredPolicyText -Content $content -RequiredText $Text) | Should -BeTrue
    }

    It 'keeps legacy and fixed forbidden text out of their policy files' {
        foreach ($forbidden in $forbiddenText) {
            foreach ($path in $forbiddenTextPaths[$forbidden]) {
                $content = Get-Content -LiteralPath (Join-Path $script:repoRoot $path) -Raw -Encoding utf8
                $normalizedContent = Normalize-TestPolicyText -Text $content
                $normalizedForbidden = Normalize-TestPolicyText -Text $forbidden
                $normalizedContent.Contains($normalizedForbidden, [StringComparison]::Ordinal) | Should -BeFalse
                $normalizedContent.ToLowerInvariant().Contains($normalizedForbidden.ToLowerInvariant(), [StringComparison]::Ordinal) | Should -BeFalse
            }
        }
    }

    It 'treats a one-letter case change as missing required text' {
        $required = $requiredPolicyText[0].Text
        $changedCase = 'w' + $required.Substring(1)
        (Test-RequiredPolicyText -Content $changedCase -RequiredText $required) | Should -BeFalse
    }

    It 'detects a lowercase forbidden-text insertion' {
        (Test-ForbiddenPolicyText -Content 'prefix windows-only suffix' -ForbiddenText 'Windows-only') | Should -BeTrue
    }

    It 'treats a REUSE annotation with one missing line as missing' {
        $missingLine = $reuseSkillAnnotationText.Replace("`nprecedence = `"aggregate`"", '')
        (Test-RequiredPolicyText -Content $missingLine -RequiredText $reuseSkillAnnotationText) | Should -BeFalse
    }
}

Describe 'OpenAI metadata field contract' {
    It 'accepts all supported optional OpenAI interface fields' {
        $fixturePath = Join-Path $TestDrive 'openai-interface-optionals.yaml'
        @(
            'interface:',
            '  display_name: "Fixture Skill"',
            '  short_description: "Fixture metadata with optional fields"',
            '  default_prompt: "Use $fixture-skill"',
            '  icon_small: "./assets/icon-small.svg"',
            '  icon_large: "./assets/icon-large.svg"',
            '  brand_color: "#123456"'
        ) | Set-Content -LiteralPath $fixturePath -Encoding utf8
        $metadata = Read-TestOpenAiInterface -LiteralPath $fixturePath
        $metadata.icon_small | Should -BeExactly './assets/icon-small.svg'
        $metadata.icon_large | Should -BeExactly './assets/icon-large.svg'
        $metadata.brand_color | Should -BeExactly '#123456'
    }

    It 'rejects unknown OpenAI interface fields' {
        $fixturePath = Join-Path $TestDrive 'openai-interface-unknown-field.yaml'
        @(
            'interface:',
            '  display_name: "Fixture Skill"',
            '  short_description: "Fixture metadata with unknown field"',
            '  default_prompt: "Use $fixture-skill"',
            '  unknown_field: "must be rejected"'
        ) | Set-Content -LiteralPath $fixturePath -Encoding utf8
        { Read-TestOpenAiInterface -LiteralPath $fixturePath } | Should -Throw '*Unsupported or duplicate OpenAI interface metadata*'
    }
}
