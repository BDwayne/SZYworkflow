# workflow/ 速查

| 什么时候 | 去哪个工具 | 说什么 | 它会读 | 它会写 |
| --- | --- | --- | --- | --- |
| 新项目，理清定位和开发地图 | Claude | `/szy-blueprint` | MAP | MAP、各线 STATUS |
| 路线要变，或 ESCALATE 里有问题 | Claude | `/szy-replan` | MAP、ESCALATE、各线 STATUS 的开头 | MAP、受影响线的 STATUS |
| 日常：看进度、合并交接、派任务 | Codex | `$szy-lead dev` | MAP 本线小节、本线 STATUS/INBOX、本线交接 | STATUS、INBOX、ESCALATE、任务说明 |
| 做一个任务 | Codex（新会话） | `$szy-task dev-T003` | 任务说明 | 代码、交接 |
| 任务做完收尾 | 同一会话 | `$szy-handoff` | — | 交接、commit |
| 某类活重复了，固化给 DS | Codex（新会话） | `$szy-runbook dev-T004 dev-T007` | done 里的说明和交接 | runbooks/Rxx、脚本 |
| 照流程批量自动化 | DeepSeek | `ds执行 dev-T012` | 任务说明、runbook | 产出、交接 |

## 文件
- `MAP.md` 项目地图（只有 Claude 改）
- `ESCALATE.md` 主控上报给 Claude 的路线问题
- `lines/<线>/STATUS.md` 本线状态（只有本线主控改）；`INBOX.md` 其他线写来的事项
- `tasks/active/` 进行中的任务说明和交接；`tasks/done/` 已合并的
- `runbooks/` 已验证、可交给 DS 的流程
- `.szy/` 工作流本身的流程和模板（由 `szy-init` 生成，更新时运行 `init.ps1 -Update`，不要手改）

## 交接链
Claude 写 MAP → Codex 主控读 MAP 写任务说明 → 执行会话写交接 → 主控合并到 STATUS / INBOX / ESCALATE → Claude 读 ESCALATE 修订 MAP
