---
name: szy-lead
description: 【Codex·线路主控·日常入口】按 Claude 定好的 MAP 管理一条线（如 dev/test）：合并任务交接、更新线路状态、处理收件箱、派发下一个任务。用户说“主控 dev”或“$szy-lead dev”时使用。
---

# szy-lead

1. 找项目根：从当前目录往上找，找到含 `workflow/.szy/procedures/` 的目录。找不到就告诉用户先运行 `szy-init`，然后停止。
2. 读取并**严格执行** `workflow/.szy/procedures/lead.md`。用户在技能名之后补充的内容就是参数：$ARGUMENTS
3. 本技能只是入口，流程以项目内的文件为准，不要凭记忆执行。
