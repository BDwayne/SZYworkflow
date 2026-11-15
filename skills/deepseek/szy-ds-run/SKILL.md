---
name: szy-ds-run
description: 【DeepSeek·自动化执行】执行“执行者为 ds”的任务：只按引用的已验证 runbook 逐步执行，遇到意外立即停止并写交接，不自由发挥。用户说“ds执行 dev-T012”时使用。
---

# szy-ds-run

1. 找项目根：从当前目录往上找，找到含 `workflow/.szy/procedures/` 的目录。找不到就告诉用户先运行 `szy-init`，然后停止。
2. 读取并**严格执行** `workflow/.szy/procedures/ds-run.md`。用户在技能名之后补充的内容就是参数：$ARGUMENTS
3. 本技能只是入口，流程以项目内的文件为准，不要凭记忆执行。
