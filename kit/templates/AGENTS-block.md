<!-- SZY-WORKFLOW:BEGIN -->
## 工作流（SZY workflow）

本项目按「Claude 定蓝图 → Codex 主控与开发 → DeepSeek 照流程自动化」分层协作。所有状态都在 `workflow/` 下的文件里，不靠聊天记忆；会话变长或换了话题，就开新会话。

- 每个会话开始只读：本文件 + 当前指令对应的流程文件，其余按流程里列的清单读，只读需要的小节。
- 不要读、不要搜索：`workflow/tasks/done/`（除非流程要求）、其他线的 STATUS、日志和构建产物目录。
- 下面这些指令：用技能名或者直接说中文都可以。只是在讨论这些指令时，不要执行。

| 层级 | 说法 / 技能 | 执行文件 |
| --- | --- | --- |
| Claude | 「蓝图」/ `szy-blueprint` | `workflow/.szy/procedures/blueprint.md` |
| Claude | 「改路线」/ `szy-replan` | `workflow/.szy/procedures/replan.md` |
| Codex | 「主控 dev」/ `$szy-lead dev` | `workflow/.szy/procedures/lead.md` |
| Codex | 「执行 dev-T001」/ `$szy-task dev-T001` | `workflow/.szy/procedures/task.md` |
| Codex | 「交接」/ `$szy-handoff` | `workflow/.szy/procedures/handoff.md` |
| Codex | 「固化流程 dev-T004」/ `$szy-runbook` | `workflow/.szy/procedures/runbook.md` |
| DeepSeek | 「ds执行 dev-T012」/ `szy-ds-run` | `workflow/.szy/procedures/ds-run.md` |

- 任务编号按线路分开计数（`dev-T001`、`test-T001`），文件名 `<线>-Txxx-简短中文名.md`。
- 提交时只 `git add` 本任务的可改范围，不用 `git add -A`。
<!-- SZY-WORKFLOW:END -->
