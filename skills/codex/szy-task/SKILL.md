---
name: szy-task
description: 【Codex·执行任务】在新会话里执行一份任务说明（如 dev-T003），严格按任务的阅读清单、可改范围和完成标准做，做完自动交接。用户说“执行 dev-T003”时使用。
---

# szy-task

1. 找项目根：从当前目录往上找，找到含 `workflow/.szy/procedures/` 的目录。找不到就告诉用户先运行 `szy-init`，然后停止。
2. 读取并**严格执行** `workflow/.szy/procedures/task.md`。用户在技能名之后补充的内容就是参数：$ARGUMENTS
3. 本技能只是入口，流程以项目内的文件为准，不要凭记忆执行。
