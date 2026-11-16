# SZYworkflow

一个省 token 的两角色开发工作流：

- **主控**：维护整体计划，判断当前里程碑，拆分并派发下一个任务。
- **执行**：在新对话里只完成一个任务，修改代码并写回结果。

状态写在项目的 `workflow/` 文件里，所以主控和执行都可以随时开新对话继续，不依赖聊天记录，也不需要扫描整个项目。

## 安装和更新

每台电脑安装一次；工具包 `git pull` 后再次运行同一命令即可更新本机流程和技能：

```powershell
git clone <本仓库地址> C:\Tools\SZYworkflow
cd C:\Tools\SZYworkflow
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

新项目初始化：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  "$env:USERPROFILE\.szy-workflow\scripts\init.ps1" -Path "C:\path\to\project"
```

初始化只创建缺少的项目状态文件；更新工具包后用 `-Update` 刷新 `workflow/.szy/` 和工作流说明，不覆盖计划、进度或任务。

## 日常使用

主控新对话中说：

```text
主控
```

或使用 `$szy-lead`。主控读取 `workflow/PLAN.md`、`workflow/PROGRESS.md` 和当前任务结果，然后更新进度、确认里程碑并创建下一个 `workflow/tasks/active/Txxx-*.md`。

任务新对话中说：

```text
执行 T001
```

或使用 `$szy-task T001`。执行只读取计划中相关部分、当前进度、指定任务文件和任务列出的源码，完成后把状态、改动、验证和遗留问题写回任务文件。

典型闭环：

```text
主控 → PLAN/PROGRESS → 创建 T001
执行 T001 → 改代码、验证、回写 T001
主控 → 读取 T001 → 更新 PROGRESS → 创建 T002
```

## 项目里的最小状态

```text
workflow/
├── PLAN.md                 # 稳定的整体路线、里程碑、技术路线
├── PROGRESS.md             # 当前完成到哪里、下一步、阻塞
├── tasks/
│   ├── active/Txxx-*.md    # 一个任务一份说明和结果
│   └── done/               # 主控已收录的任务归档
└── .szy/                   # 工具包维护的两份流程和模板
```

文件保持短小：`PLAN.md` 写整体路线，`PROGRESS.md` 只写当前状态，任务文件只写执行所需信息。主控发现技术路线或成功标准需要变化时，先向用户说明并确认，再改 `PLAN.md`。

## 技能

工具包只保留三个通用入口：`szy-init`、`szy-lead`、`szy-task`。入口可以安装到 Claude、Codex 等支持技能目录的客户端；实际流程统一由项目里的 `workflow/.szy/procedures/` 执行，不再区分模型、线路或客户端。
