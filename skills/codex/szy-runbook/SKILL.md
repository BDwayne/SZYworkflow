---
name: szy-runbook
description: 【Codex·固化流程】某类任务已经验证过、会重复做时使用：把它写成脚本和 runbook，亲自走通一遍后标为已验证，供 DeepSeek 照做。用户说“固化流程 dev-T004”时使用。
---

# szy-runbook

1. 找项目根：从当前目录往上找，找到含 `workflow/.szy/procedures/` 的目录。找不到就告诉用户先运行 `szy-init`，然后停止。
2. 读取并**严格执行** `workflow/.szy/procedures/runbook.md`。用户在技能名之后补充的内容就是参数：$ARGUMENTS
3. 本技能只是入口，流程以项目内的文件为准，不要凭记忆执行。
