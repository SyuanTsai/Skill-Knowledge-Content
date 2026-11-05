<!--
SPDX-FileCopyrightText: 2026 SyuanTsai
SPDX-License-Identifier: Apache-2.0
-->
# 三平台 canonical CI 範本

## 目的

此範本把 Skill repository 的 canonical validation 同時綁定 Windows、Linux 與 macOS。三個 leg 都必須完成並通過；aggregate 會驗證完整平台集合、同一事件與 candidate/base/authority 身分，以及每個 leg 的凍結證據。`repository-contract`、`skill-validator`、`skill-tools` 名稱不變，只反映 matrix 與 aggregate 的共同結果。

## Job 拓撲

```text
canonical-validation
├─ windows-latest / windows / x64
├─ ubuntu-latest  / linux   / x64
└─ macos-latest   / macos   / arm64
              │ 三份 leg receipt
              ▼
canonical-aggregate (ubuntu-latest)
              │
      ┌───────┼────────┐
      ▼       ▼        ▼
repository-  skill-   skill-
contract     validator tools
```

## 每個 job 做什麼

### Matrix leg

1. 在 checkout 前設定 `core.autocrlf=false`，再分別 checkout exact candidate、authority pin 與 event-base `driver/`；每個 checkout 都使用 `persist-credentials: false`。
2. 驗證 candidate/base/authority SHA、乾淨 worktree、受保護 helper 的 Git blob 與實際 bytes。
3. 從官方 latest stable release metadata 選擇平台資產：Windows x64 ZIP、Linux x64 tar.gz、macOS arm64 tar.gz。官方 `hashes.sha256` 與 API asset digest 都必須吻合；Windows另驗 Authenticode。後續每個 protected step 都確認目前 shell process 是同一 verified executable。
4. 準備 locked Pester 6.2.0、source tool receipts，然後由 event-base driver 依序呼叫 `scripts/Validate.ps1 -PrepareSourceTools` 與 `-SourceValidation`。
5. 重新驗證完整 source evidence，寫入含平台、runner、run identity、PowerShell identity、各 protected step outcome、source report SHA-256 與分段耗時的 leg receipt，並分開上傳 evidence 與 receipt artifact。

Artifacts root 在 Windows 使用磁碟根目錄下的短路徑；Linux/macOS 則使用 `RUNNER_TEMP` 下的 run-owned 目錄，避免嘗試建立不可寫入的 `/a-*`。

### Aggregate

`canonical-aggregate` 即使 matrix 失敗也會執行。它下載所有 leg receipts，逐項輸出 `::error::`，並在下列任一情況 fail closed：matrix 不是 success、receipt 遺失或重複、平台集合不是精確的 `{windows, linux, macos}`、run/event/candidate/base/authority 不一致、protected step 不是 success，或 source report hash 缺失。無論成功或失敗，都把各平台 timing table 寫入 `$GITHUB_STEP_SUMMARY`。

### Required context mirrors

三個 mirror 都在 `ubuntu-latest`，只讀取 `needs` 結果，不 checkout、不下載 artifact，也不重跑驗證。只有 `canonical-validation` 與 `canonical-aggregate` 都是 `success` 才回傳成功。

## 移植到另一個 Skill repository

- [ ] 同一 change 更新 `config/standard-v1.json`、protected pin table、workflow pin 與 fixtures；inventory 必須是 runner 實際會讀取的完整 authority bytes。
- [ ] 保留 event-base `driver/`，禁止改由 candidate 執行受保護 driver。
- [ ] 建立精確三平台 matrix、`fail-fast: false`、aggregate 與原名 required contexts。
- [ ] 將 `pwsh.exe`／`pwsh`、`node.exe`／`node`、`npm.cmd`／`npm`、`git.exe`／`git` 改成平台中立解析或明確平台分支。
- [ ] Windows 路徑比較用 `OrdinalIgnoreCase`；Linux/macOS 用 `Ordinal`。可信 root 先解析 physical path。
- [ ] Windows 使用短 artifacts root；Unix 使用 `RUNNER_TEMP` 下的 owned root。
- [ ] 需要 path safety、owned process、lock、PowerShell acquisition 或 authority Pester 時，載入 authority 的 `platform-runtime.psd1`／`.psm1` 與完整 `scripts/platform/` inventory，不複製 repo-side 相容層。
- [ ] 若 repository 自有 Pester closure lock 與 authority 的 Pester payload 不同，可保留 repo preparer，但必須支援三平台並完整 hash 驗證。此 repository 的 `Initialize-PlatformPester` 是 authority 自身核准 payload／Pester 4.10.1 流程，不能取代本 repo 的 Pester 6.2.0 closure。
- [ ] 平台限定測試必須明確登錄。此範本沒有新增 `-Skip`；Windows-only Authenticode 是 workflow 的條件式驗證，不是測試豁免。
- [ ] 更新 workflow text tests：精確 matrix、context 名稱與雙重 `needs`、Ubuntu mirrors、所有 action SHA pin、checkout credential isolation、cache re-verification。

## Protected-driver bootstrap 注意事項

引入新 workflow 的第一個 PR 仍由舊 base commit 的 `driver/` 驗證。舊 driver 不理解新 matrix／Core v2 contract 時，該 PR 的 required checks 無法變綠；這是 protected-base 模型的預期結果，不應改成執行 candidate driver。

合併含新 driver 的 commit 後，可建立一個較晚的 candidate commit，透過 `workflow_dispatch` 提供預合併三平台證據：

1. `base_commit` 指向已包含新 driver 的 commit。
2. dispatch 的 candidate 指向其後的 distinct descendant commit。
3. 保存三個 leg artifacts、三份 receipt 與 aggregate summary，並核對 candidate/base/authority 身分。

## Python runtime pin

三個 matrix leg 都必須在 source tool preparation 前透過 pinned `actions/setup-python` 選用 Python 3.12，並保存 interpreter 版本與 executable SHA-256。Authority resolver 以目前 interpreter 執行 wheel-only SkillSpector dependency closure；SkillSpector 2.13.4 所需的 `yara-python` 4.5.4 尚未發布 CPython 3.14 (`cp314`) wheel，因此 Ubuntu/macOS runner 的 Python 3.14 預設值會讓解析器反覆 backtrack，最後超過 acquisition round limit。Windows runner 原本的預設 Python 3.12 可成功解析，固定三個平台為 3.12 也可避免 leg 間漂移。

當 `yara-python` 發布 `cp314` wheels 後，必須重新檢視此 pin；升級前應以三平台 wheel-only resolution、runtime evidence 與 aggregate receipt 一致性驗證新版本，不可只移除 pin。

## Cache key 與安全性

| 內容 | Key | 安全條件 |
|---|---|---|
| PowerShell release bytes | `pwsh-<runner.os>-<runner.arch>-<version>-<official-sha256>` | 只 cache archive 與官方 hashes manifest；每次 restore 後重驗 API digest、manifest entry 與 bytes。失配即丟棄並重新下載，runtime 永不 cache。 |
| Pester package bytes | `pester-<runner.os>-<closure-lock-hash>` | 只 cache `.nupkg`；既有 closure verification 對 package inventory 與每個 payload SHA-256 完整重驗。失配即重新下載。 |
| SkillSpector wheelhouse | 未啟用 | authority resolver 使用 `--no-cache-dir` 與自己的 frozen、hash-verified wheel pool，沒有可安全注入的外部 cache directory；因此不宣稱或新增 pip cache。 |

Cache 只加速下載，不能產生信任。任何 cache mismatch 都不得 fail open。

## Concurrency

Group 使用 `${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}`。只有 pull request 啟用 `cancel-in-progress`；push 與 manual dispatch 不互相取消。被取消的任一 leg 會使 matrix／aggregate／mirrors 失敗。

## 已知陷阱

- macOS arm64 runner 若因容量在 0 steps 時取消，或顯示「not acquired by Runner」，屬 runner capacity 問題，不是程式通過；aggregate 仍必須 fail closed。
- macOS 的 `/var`、`/tmp` 會解析到 `/private/...`。先解析 trusted root 的 physical path，再作 ordinal boundary 比較，不能只因系統祖先是 symlink 就拒絕。
- Ubuntu runner 可能提供 uutils coreutils；不要依賴 GNU-only output 文案或參數行為。
- Pester `Should -Throw '<substring>'` 不把 `*` 當 wildcard；需要訊息模式時，先捕捉例外再以 `Should -BeLike` 驗證。
- Unix filesystem 大小寫敏感；archive inventory、relative path 與 hash table 不可用 Windows 路徑語意。
- 較新的 Git 在 `commit` 後可能以 `setsid` 背景執行 `maintenance run --auto`。Linux owned-process subreaper 會收養這個孫程序，並以 `unattributed-adopted-child` fail closed。測試用 repository 與 authority snapshot clone 必須設定 `maintenance.auto=false`、`maintenance.autoDetach=false`、`gc.auto=0`、`gc.autoDetach=false`。
- Unix 上 npm `.bin` entry 是 symlink shim。凍結檔案集合只能放 `node` 與 `entryPoint`（hash 驗證），shim 必須精確解析到 payload，不可列為 frozen file。這需要 authority 至少包含 SyuanTsai-AI-Instructions PR #125 的修正（`6cee5b8`）。
- Runner 只轉送 `^STANDARD_VALIDATION_[A-Za-z0-9_]+$` 環境變數給 child。Source tool setup 需要 GitHub API token 時（macOS 共用 IP 容易撞到未驗證 rate limit），只能放在 `STANDARD_VALIDATION_GITHUB_API_TOKEN`，且只傳給 resolver process。Resolver 讀入後立即刪除 token，Authorization 只送往 `api.github.com`。
- GitHub Actions 的 job-level `env` 不能使用 `runner` context。`run:` 內的 `${{ }}` 會讓整段 script 進入 expression 求值，超過 21000 字元會解析失敗。所有 expression 一律放在 step `env:`。
- 在 PowerShell 中把 `$null` 傳給 .NET string 參數會變成空字串，所以 `[Environment]::SetEnvironmentVariable($name, $null)` 不會刪除變數。請改用 `[NullString]::Value` 或 `Remove-Item Env:<name>`。

## 各平台實測耗時

| 平台 | Setup 秒 | Source validation 秒 | Total 秒 | Job wall time |
|---|---:|---:|---:|---:|
| Windows x64 | 238 | 174 | 434 | 8m11s |
| Linux x64 | 141 | 157 | 317 | 5m58s |
| macOS arm64 | 203 | 300 | 533 | 9m45s |

來源：最終 `workflow_dispatch` run 42043960537（authority `6cee5b8`，PowerShell 7.6.9，Python 3.12），三個 leg、aggregate 與三個 context 全綠。

- Workflow 從建立到完成共 10m22s，約等於最慢平台（macOS 9m45s）加上 aggregate 與 mirrors 約 30 秒，符合「總時間 ≈ 最慢平台」。
- 前一輪 run 41995856474（authority `4a25015`）的耗時：Windows 374s / 7m14s、macOS 358s / 6m40s、Linux 302s / 5m47s，總計 7m36s。
- macOS 的 source validation 波動最大（204s→300s），主要受共用 runner 負載影響。
- Setup 秒數包含 cache restore 與 restore 後的完整重驗。

## 已知偏差與限制

- 本 repo 的 Pester 6.2.0 preparer保留在 repository，因 authority 的 Pester helper 服務不同的 authority-owned payload；它仍使用完整 closure lock 與跨平台 cache re-verification。
- workflow 沒有 SkillSpector pip cache，原因是 resolver 強制 `--no-cache-dir`，未提供可保持 mandatory hash verification 的 consumer cache 介面。
- PowerShell metadata/cache key 必須在 GitHub cache action 前求得；本 repo 的 protected helper完成同等官方 digest、manifest 與 runtime identity 驗證，沒有直接呼叫需要 authority policy／lease context 的 `Resolve-PlatformPowerShell`。
- SkillSpector 在原生不可用的平台只接受 authority runner 的 native probe 所產生 `platform-unavailable`；repository 不提供 waiver 或假 pass。
- `docs/standards/core-test-skip-inventory.json` 不在此 consumer inventory，因目前 runner、resolver、semantic bridge 與 platform manifest 的 canonical path 都不讀取它。
