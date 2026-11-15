---
name: szy-blueprint
description: 【Claude·蓝图】新项目开局时使用：和用户聊清项目定位、目标、约束和风险，制定开发地图 MAP（里程碑、线路划分、每条线的规划），用户确认后定稿，交给 Codex 主控。
---

# szy-blueprint

1. 找项目根：从当前目录往上找，找到含 `workflow/.szy/procedures/` 的目录。找不到就告诉用户先运行 `szy-init`，然后停止。
2. 读取并**严格执行** `workflow/.szy/procedures/blueprint.md`。用户在技能名之后补充的内容就是参数：$ARGUMENTS
3. 本技能只是入口，流程以项目内的文件为准，不要凭记忆执行。
