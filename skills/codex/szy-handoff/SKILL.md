---
name: szy-handoff
description: 【Codex·交接收尾】任务做完时使用：只提交本任务的文件，写交接文件，然后提示用户回主控。用户说“交接”时使用。
---

# szy-handoff

1. 找项目根：从当前目录往上找，找到含 `workflow/.szy/procedures/` 的目录。找不到就告诉用户先运行 `szy-init`，然后停止。
2. 读取并**严格执行** `workflow/.szy/procedures/handoff.md`。用户在技能名之后补充的内容就是参数：$ARGUMENTS
3. 本技能只是入口，流程以项目内的文件为准，不要凭记忆执行。
