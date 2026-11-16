# workflow/ 速查

| 角色 | 说什么 | 读取 | 写入 |
| --- | --- | --- | --- |
| 主控 | 主控 / $szy-lead | PLAN、PROGRESS、active 任务 | PLAN（确认后）、PROGRESS、任务 |
| 任务 | 执行 T001 / $szy-task T001 | 任务文件及其中列出的文件 | 代码、任务结果 |

## 文件

- PLAN.md：目标、技术路线、里程碑和完成条件。
- PROGRESS.md：当前完成到哪里、阻塞和下一步；主控覆盖更新。
- tasks/active/Txxx-*.md：待执行或执行中的任务；tasks/done/：已完成任务。旧版线路任务不自动迁移。
- .szy/：安装包同步的流程和模板，更新时运行 init.ps1 -Update。

任务会话完成后回到新主控会话说「主控」。
