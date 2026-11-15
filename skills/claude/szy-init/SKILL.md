---
name: szy-init
description: 【通用·项目初始化】在一个项目文件夹里生成 SZY 工作流（workflow/ 目录、AGENTS.md 的工作流段落、CLAUDE.md）。新项目第一次使用、新增一条线路、或工具包升级后更新流程文件时使用。
---

# szy-init

1. 确定项目根：默认是当前工作目录；用户给了路径就用用户给的。先跟用户确认这个目录，并且确认它**不是** SZYworkflow 工具包仓库本身。
2. 运行用户主目录下的初始化脚本 `.szy-workflow/scripts/init.ps1`：
   - PowerShell：`powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.szy-workflow\scripts\init.ps1" -Path "<项目根>"`
   - bash：`powershell -NoProfile -ExecutionPolicy Bypass -File "$HOME/.szy-workflow/scripts/init.ps1" -Path "<项目根>"`
   - 可选参数：`-Lines dev,test,art`（首次初始化建哪些线，默认 dev,test）；`-AddLine <线名>`（新增一条线）；`-Update`（只更新 `workflow/.szy/` 里的流程和模板）。
   - 脚本不存在：告诉用户先在 SZYworkflow 仓库里运行 `install.ps1`，然后停止。
3. 把脚本输出的“新建 / 跳过 / 更新”清单转述给用户。已经存在的 MAP、STATUS 不会被覆盖。
4. 项目还不是 git 仓库：问用户要不要运行 `git init`。
5. 告诉用户下一步：新项目去 Claude 运行 `/szy-blueprint`；已有蓝图的项目直接去 Codex 运行 `$szy-lead dev`。
