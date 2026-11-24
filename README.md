<!--
SPDX-FileCopyrightText: 2026 SyuanTsai
SPDX-License-Identifier: Apache-2.0
-->
# Skill-Knowledge-Content

## Overview

**What it is:** An Agent Skills repository for the Knowledge & Content domain.

**Problem it solves:** It brings scattered course and lecture materials together as evidence-linked notes, with exports for NotebookLM or articles.

**Key Skills**

| Skill | What it does |
| --- | --- |
| [`capture-private-course-knowledge`](skills/capture-private-course-knowledge/SKILL.md) | Analyzes and archives authorized course materials with links to evidence. It can transcribe videos that require sign-in, connect PDFs, slides, code, and attachments, and export notes, NotebookLM sources, or articles. |

**Platform:** Local work runs on your current Windows, Linux, or macOS host.

**Quick start:**

1. Install the Skill through [SyuanTsai-AI-Instructions](https://github.com/SyuanTsai/SyuanTsai-AI-Instructions).
2. Invoke `capture-private-course-knowledge` by name or ask your agent to capture an authorized course as evidence-linked notes.

**Content rights:** Use only materials you are authorized to access and respect the provider’s access controls.

**License:** [Apache-2.0](LICENSE) covers repository-authored content. See [provenance and licensing scope](PROVENANCE.md) for input and output rights.

## 概覽

**這是什麼：** 這是 Knowledge & Content 領域的 Agent Skills 儲存庫。

**解決的問題：** 將分散的課程與講座素材整理成附有佐證連結的筆記，並可匯出為 NotebookLM 來源或文章。

**主要 Skills**

| Skill | 功能 |
| --- | --- |
| [`capture-private-course-knowledge`](skills/capture-private-course-knowledge/SKILL.md) | 分析並保存已獲授權的課程素材，附上佐證連結。可轉錄須登入才能觀看的影片，串聯 PDF、投影片、程式碼與附件，並匯出筆記、NotebookLM 來源或文章。 |

**平台：** 本機作業在你目前使用的 Windows、Linux 或 macOS 主機上執行。

**快速開始：**

1. 透過 [SyuanTsai-AI-Instructions](https://github.com/SyuanTsai/SyuanTsai-AI-Instructions) 安裝此 Skill。
2. 指定 `capture-private-course-knowledge`，或請你的代理程式將已獲授權的課程整理成附有佐證連結的筆記。

**內容權利：** 僅使用你有權存取的素材，並遵守內容提供者的存取限制。

**授權：** [Apache-2.0](LICENSE) 適用於儲存庫原創內容。輸入與輸出的權利請參閱[來源與授權範圍](PROVENANCE.md)。

---

Independent Agent Skills repository for the **Knowledge & Content** domain.

For source maintenance and review, follow the [central Skill maintenance guidelines](https://github.com/SyuanTsai/SyuanTsai-AI-Instructions/blob/main/docs/skill-maintenance-guidelines.md) when deciding scope, supporting resources, dependencies, and replacement cleanup.

## Repository contract

- Stable source ID: `knowledge-content`
- Repository: `SyuanTsai/Skill-Knowledge-Content`
- Skill layout: `skills/<skill-id>/**`
- Source inventory: `catalog/source.json`
- Repository check: `scripts/Test-KnowledgeContentRepository.ps1`
- Contract tests: the repository regression suite
- Release and rollback rules: `RELEASING.md`

## Supported platform

The Skill instructions are host-neutral: local Agent work runs on the user's current Windows, Linux, or macOS host. When a required local tool is unavailable, the Skill reports the gap and marks the affected work partial or draft instead of switching to another host, VM, WSL, or container. Authorized SaaS, browser, and API services remain in scope when the user permits them; cross-platform course code and commands remain source evidence.

The pinned authority consumer gate validates the repository on `windows-latest`, `ubuntu-latest`, and `macos-latest`. Each platform runs the repository-specific snapshot check and the complete `tests/` suite; these checks are not end-to-end course-capture acceptance runs.

`catalog/source.json` records only the stable source inventory. Its exact schema has no description or platform field.

## License and content boundary

The Apache-2.0 license in [LICENSE](LICENSE) applies to the repository-authored Skill instructions, agent metadata, procedural references, source metadata, documentation, validation scripts, tests, and workflow configuration. It does not grant rights to course providers, publishers, NotebookLM, GitHub, or other external services.

Course and lecture videos or audio, PDFs, slides,教材, code, attachments, archives, retrieved text, transcripts, OCR, notes, exports, articles, and other user-provided or third-party material are inputs or outputs rather than Apache-2.0 repository content. Processing them with this tool does not automatically relicense them; users must confirm the rights for each input and output.

The repository does not vendor course materials or third-party source code. See [PROVENANCE.md](PROVENANCE.md) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). Contributors must have the right to submit their contribution; unless a separate written agreement says otherwise, an intentional contribution to the repository-authored scope is submitted under Apache-2.0 and must preserve existing notices.

## Skills

### `capture-private-course-knowledge`

Captures and integrates authorized course and lecture material across video/audio, PDFs, slides, code, attachments, durable notes, NotebookLM exports, and article generation.

Path:

```text
skills/capture-private-course-knowledge/
├─ SKILL.md
├─ agents/
│  └─ openai.yaml
└─ references/
   ├─ course-notes-format.md
   ├─ notebooklm-export.md
   ├─ pdf-material-capture.md
   ├─ syuantsai-github-article.md
   └─ video-capture.md
```

#### Local tool availability

This Skill does not require a specific tool. The table lists common local tools for transcription, OCR, PDF extraction, media inspection, article-site builds, and browser access, recording how official documentation makes them available on Windows x64, Linux x64, and macOS arm64 as of 2026-11-14. This repository's CI neither installs nor runs these tools, so the table does not report tested results. Items not stated in the official documentation are marked `Unverified` without inference. When a tool is unavailable, follow the Skill's host boundary: report the gap and do not switch hosts.

| Purpose | Tool | Windows x64 | Linux x64 | macOS arm64 | Sources |
|---|---|---|---|---|---|
| Media inspection | FFmpeg / ffprobe | Third-party builds linked from the official page | Distribution packages or third-party static builds | `Unverified`: the official page links only to third-party "64-bit" builds without naming the architecture | 1, 2 |
| Transcription | whisper.cpp | Build from source with CMake and MSVC or MinGW | Build from source | Build from source; README explicitly lists Arm | 3 |
| Transcription | OpenAI Whisper | pip; README provides Windows FFmpeg installation commands but does not explicitly list supported operating systems | pip with FFmpeg installed through apt | pip with FFmpeg installed through Homebrew; `Unverified`: arm64 is not explicit | 4 |
| OCR | Tesseract | Third-party installer from UB Mannheim | Distribution packages | Homebrew or MacPorts; `Unverified`: arm64 is not explicit | 5 |
| PDF extraction | Poppler (`pdftotext`, `pdftoppm`) | Official source only; build from source or use a third-party package | Same as Windows | Same as Windows | 6 |
| PDF extraction | MuPDF (`mutool`) | Build from source with Visual Studio | Build from source with make | `Unverified`: official guidance only says it should be buildable | 7 |
| Article site | Git | Official x64 installer | Distribution packages | Third-party or Apple-provided options (Homebrew, MacPorts, Xcode CLT); `Unverified`: arm64 is not explicit | 8, 9, 10 |
| Article site | Ruby | RubyInstaller, listed as a third-party installer on the official page | Distribution packages | System Ruby or Homebrew; `Unverified`: arm64 is not explicit | 11 |
| Article site | Bundler | Included with Ruby | Included with Ruby | Included with Ruby | 12 |
| Article site | Jekyll | Not officially supported; usable with documented adjustments | Available through the Ubuntu guide | Follows Homebrew's macOS support; `Unverified`: arm64 is not explicit | 13, 14, 15 |
| Browser | Google Chrome | Windows 10 or later | x86-64 `.deb` or `.rpm` | macOS 13 or later; `Unverified`: the page does not distinguish chips | 16, 17 |
| Browser | Microsoft Edge | Available | 64-bit on listed distributions | Native Apple Silicon support starting with Edge 88 | 18 |
| Browser | Mozilla Firefox | Windows 10 or later | glibc 2.17 or later; `Unverified`: the page does not state x86_64 | Apple silicon explicitly listed | 19 |

1. <https://ffmpeg.org/download.html>
2. <https://ffmpeg.org/ffprobe.html>
3. <https://github.com/ggml-org/whisper.cpp>
4. <https://github.com/openai/whisper>
5. <https://tesseract-ocr.github.io/tessdoc/Installation.html>
6. <https://poppler.freedesktop.org/>
7. <https://mupdf.readthedocs.io/en/latest/guide/install.html>
8. <https://git-scm.com/install/windows>
9. <https://git-scm.com/install/linux>
10. <https://git-scm.com/install/mac>
11. <https://www.ruby-lang.org/en/documentation/installation/>
12. <https://bundler.io/>
13. <https://jekyllrb.com/docs/installation/>
14. <https://jekyllrb.com/docs/installation/windows/>
15. <https://jekyllrb.com/docs/installation/macos/>
16. <https://support.google.com/chrome/a/answer/7100626>
17. <https://support.google.com/chrome/answer/95346>
18. <https://learn.microsoft.com/en-us/deployedge/microsoft-edge-supported-operating-systems>
19. <https://www.firefox.com/en-US/firefox/system-requirements/>

## Validation

The authority-published consumer gate is the canonical CI entry. Its protected workflow runs on Windows, Linux, and macOS from the immutable commit in `config/authority-pin.json`. Repository-owned behavior is limited to:

- `scripts/Test-KnowledgeContentRepository.ps1`, which validates `catalog/source.json`, Skill package structure, frontmatter, `agents/openai.yaml`, licensing boundaries, and deterministic content inventory from a read-only snapshot;
- the complete `tests/` tree, discovered and executed by the pinned authority runtime.

The repository check accepts `-RepositoryRoot` and `-ReadOnlySnapshot`, does not require repository metadata, does not write into the candidate, and writes its JSON result to stdout.

The transition workflow exists only for the initial conversion. After conversion cleanup, routine authority upgrades change only the full commit in `config/authority-pin.json`; the copied bootstrap and primary workflow remain authority-published bytes.

## Versioning and rollback

Consumers should pin this Skill source to a full commit SHA or an immutable release tag. Skill content hashes are deterministic and can be recorded in external catalog locks.

Do not repurpose stable Skill IDs or move a Skill away from `skills/<skill-id>` without coordinating the consuming Catalog lifecycle contract. Rollback uses a normal reviewed pull request that restores a previously validated source commit or authority pin; release history and immutable tags must not be rewritten.

See [RELEASING.md](RELEASING.md) for release, update, rename, removal, and rollback rules.
