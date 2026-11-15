# SZYworkflow

一套省 token 的多模型分层开发工作流：**Claude 定蓝图 → Codex 主控派任务并开发 → DeepSeek 照验证过的流程做自动化**。
所有状态都存在项目的 `workflow/` 文件里。任何一层都可以随时在新对话里启动，不依赖长聊天记录。

> 这个仓库是**工具包**，不是开发项目。每台电脑 clone 一次、安装一次，然后在你自己的各个项目文件夹里初始化。不要在这个仓库里开发业务。

## 安装（每台电脑一次；以后 `git pull` 了就再运行一次）

```powershell
git clone <本仓库地址> C:\Tools\SZYworkflow
cd C:\Tools\SZYworkflow
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
# DeepSeek 客户端如果支持技能目录：加 -DsSkillDir <它的 skills 目录>
```

安装后的位置：
- `~/.szy-workflow/`：流程文件、模板、初始化脚本
- `~/.claude/skills/`：`szy-init`、`szy-blueprint`、`szy-replan`
- `~/.codex/skills/`：`szy-init`、`szy-lead`、`szy-task`、`szy-handoff`、`szy-runbook`

## 在一个项目里开始

1. 打开（或新建）项目文件夹，在 Claude 里运行 `/szy-init`。它会生成 `workflow/`、`AGENTS.md`（含工作流段落）和 `CLAUDE.md`。
2. 在 Claude 里运行 `/szy-blueprint`：把项目定位、目标、约束、风险聊清楚，定下开发地图 `workflow/MAP.md`。
3. 之后日常都在 Codex 里：`$szy-lead dev` 看进度、派任务 → 开新会话 `$szy-task dev-T001` → `$szy-handoff` → 回到 `$szy-lead dev` 合并。

## 技能一览（什么时候用哪个）

| 技能 | 用哪个工具 | 什么时候用 | 读上一层的什么 | 留下什么给下一层 |
| --- | --- | --- | --- | --- |
| `szy-init` | Claude / Codex | 新项目第一次用；新增线路（`-AddLine`）；工具包升级后更新流程（`-Update`） | — | `workflow/` 骨架 |
| `szy-blueprint` | **Claude** | 新项目开局：定位、目标、风险、开发地图、线路划分 | 已有的 README（如果有） | `MAP.md`、各线 `STATUS.md` |
| `szy-replan` | **Claude** | 路线要变；Codex 主控上报了路线问题 | `MAP.md`、`ESCALATE.md`、各线 STATUS 的开头 | 新版 `MAP.md`、受影响线的计划 |
| `szy-lead <线>` | **Codex**（日常主入口） | 看进度、合并交接、处理收件箱、派下一个任务 | MAP 里本线的小节、本线 STATUS/INBOX、本线交接 | 任务说明、STATUS、INBOX、ESCALATE |
| `szy-task <编号>` | **Codex**（新会话） | 执行一个任务 | 任务说明 | 代码、交接 |
| `szy-handoff` | **Codex**（同一会话） | 任务做完收尾 | 任务说明 | 交接文件、commit |
| `szy-runbook <编号...>` | **Codex**（新会话） | 某类活已经验证过、会反复做 | done 里的说明和交接 | `runbooks/Rxx`、脚本 |
| `szy-ds-run <编号>` / 说「ds执行 <编号>」 | **DeepSeek** | 执行者为 ds 的任务 | 任务说明、runbook | 产出、交接 |

## 交接链（每一层只读上一层留下的文件）

```
Claude  ──写──> MAP.md ──读──> Codex 主控 ──写──> tasks/active/<线>-Txxx.md
                  ▲                │                          │
                  │                ▼                          ▼
           ESCALATE.md <──写── 合并交接 <──读── <线>-Txxx.handoff.md <── 执行会话（Codex / DS）
                                   │
                                   └──写──> 其他线的 INBOX.md（比如“需要补测”“Bxxx 需要修复”）
```

## 设计要点

- **线路**：默认 `dev` + `test` 两条。分线是为了让每条线不用知道其他线的细节，从而省 token；两条线之间只通过 `INBOX.md` 传一句话。
- **任务编号按线分开**（`dev-T001`、`test-T001`），并行时不会撞号。提交时只 `git add` 本任务的可改范围，不用 `git add -A`。
- **交给 DeepSeek 的门槛**：只有 Codex 亲自走通一遍、标为「已验证」的 runbook 覆盖的任务才派给 ds。ds 遇到意外立即停止，交回 Codex。
- **字数上限**：STATUS 不超过 60 行，交接不超过 30 行。冷启动时只读固定清单。
- **流程只有一份**：技能都是薄入口，真正的步骤在项目里的 `workflow/.szy/procedures/`。工具包升级后，在项目里运行 `init.ps1 -Update` 同步。

## DeepSeek 端

任何能读取项目 `AGENTS.md` 的客户端都可以，比如用 DeepSeek 作为后端的 Codex profile、Claude Code 或其他代理工具。用户说「ds执行 dev-T012」时，客户端会按 `AGENTS.md` 里的指令表去读 `workflow/.szy/procedures/ds-run.md`。客户端支持技能目录的话，安装时加上 `-DsSkillDir`。

## 目录

```
install.ps1            安装到本机
kit/procedures/        各技能的完整流程（初始化时复制进项目 workflow/.szy/）
kit/templates/         MAP、STATUS、任务说明、交接、runbook、AGENTS 段落等模板
kit/scripts/init.ps1   项目初始化、新增线路、更新流程
skills/{claude,codex,deepseek}/  各工具的薄入口
```
