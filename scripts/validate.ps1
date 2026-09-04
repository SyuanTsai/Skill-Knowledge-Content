# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $root 'catalog/source.json'
if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) { throw 'Missing catalog/source.json.' }

$source = Get-Content -Raw -Encoding UTF8 -LiteralPath $sourcePath | ConvertFrom-Json
if ($source.schemaVersion -ne 1) { throw 'Unsupported source metadata schemaVersion.' }
if ($source.sourceId -cne 'knowledge-content') { throw 'sourceId must be knowledge-content.' }
if ($source.repository -cne 'https://github.com/SyuanTsai/Skill-Knowledge-Content.git') { throw 'Unexpected repository URL.' }

$seen = @{}
foreach ($skill in @($source.skills)) {
    if ([string]::IsNullOrWhiteSpace($skill.id) -or $skill.id -cnotmatch '^[a-z0-9](?:[a-z0-9-]{0,62}[a-z0-9])?$') { throw "Invalid Skill ID: $($skill.id)" }
    if ($seen.ContainsKey($skill.id)) { throw "Duplicate Skill ID: $($skill.id)" }
    $seen[$skill.id] = $true

    $expected = ".agents/skills/$($skill.id)"
    if ($skill.path -cne $expected) { throw "Skill path must be $expected." }
    $skillRoot = Join-Path $root ($skill.path -replace '/', [IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path -LiteralPath $skillRoot -PathType Container)) { throw "Missing Skill directory: $expected" }
    if (-not (Test-Path -LiteralPath (Join-Path $skillRoot 'SKILL.md') -PathType Leaf)) { throw "Missing SKILL.md for $($skill.id)." }
    if (-not (Test-Path -LiteralPath (Join-Path $skillRoot 'agents/openai.yaml') -PathType Leaf)) { throw "Missing agents/openai.yaml for $($skill.id)." }

    $skillHeader = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $skillRoot 'SKILL.md')
    if ($skillHeader -notmatch "(?m)^name:\s*$([regex]::Escape($skill.id))\s*$") { throw "SKILL.md name does not match stable ID $($skill.id)." }

    $lines = New-Object System.Collections.Generic.List[string]
    Get-ChildItem -LiteralPath $skillRoot -File -Recurse | ForEach-Object {
        $relative = $_.FullName.Substring($root.Length + 1).Replace([IO.Path]::DirectorySeparatorChar, '/')
        $sha = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLowerInvariant()
        $lines.Add("$relative`t$sha`n")
    }
    $inventory = ($lines | Sort-Object -CaseSensitive) -join ''
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($inventory)
    $hasher = [Security.Cryptography.SHA256]::Create()
    try { $contentHash = ([BitConverter]::ToString($hasher.ComputeHash($bytes))).Replace('-', '').ToLowerInvariant() }
    finally { $hasher.Dispose() }
    Write-Host "$($skill.id) contentSha256=$contentHash"
}

$declaredIds = @($source.skills | ForEach-Object { $_.id } | Sort-Object)
$actualIds = @(Get-ChildItem -LiteralPath (Join-Path $root '.agents/skills') -Directory | ForEach-Object { $_.Name } | Sort-Object)
if (($declaredIds -join "`n") -cne ($actualIds -join "`n")) { throw 'catalog/source.json inventory does not match .agents/skills.' }

Write-Host 'Validation passed.'
