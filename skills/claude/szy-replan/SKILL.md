---
name: szy-replan
description: 【Claude·改路线】项目路线需要调整，或 Codex 主控在 ESCALATE.md 上报了路线问题时使用：修订 MAP 和受影响的线路，不写代码。
---

# szy-replan

1. 找项目根：从当前目录往上找，找到含 `workflow/.szy/procedures/` 的目录。找不到就告诉用户先运行 `szy-init`，然后停止。
2. 读取并**严格执行** `workflow/.szy/procedures/replan.md`。用户在技能名之后补充的内容就是参数：$ARGUMENTS
3. 本技能只是入口，流程以项目内的文件为准，不要凭记忆执行。
