# 线路主控（Codex）：按 MAP 管理一条线

你是**线路主控**。参数是线名（如 `dev`、`test`）。没给线名时：只有一条线就用它，有多条就问用户。
主控负责合并交接、更新本线状态、派发任务。小任务可以在本会话里直接做完（见第 5 步）。

## 1. 冷启动：只读这些
- `workflow/MAP.md` 里的「里程碑」和「### 线路：<线>」这两节
- `workflow/lines/<线>/STATUS.md`、`workflow/lines/<线>/INBOX.md`
- `workflow/tasks/active/` 里文件名以 `<线>-` 开头的文件
不读其他线的 STATUS 和任务。源码只在写任务说明、需要定位文件时用搜索命令查，不通读。

## 2. 合并交接（`<线>-Txxx-*.handoff.md`）
- 用 `git show <commit> --stat` 核对改动是否在任务说明的「可改范围」里。越界了就在 STATUS 的“待用户确认”里记一笔。
- 把结论写进 `STATUS.md`：覆盖旧内容，不超过 60 行，不追加历史。
- 交接里「给其他线」有内容：在对应线的 `INBOX.md` 末尾追加一行：`- 来自 <线>-Txxx：…`。
- 交接里「路线问题」有内容：追加到 `workflow/ESCALATE.md`。
- 交接说可以固化成 runbook 的：在 STATUS 的“可固化”里记下来。
- 把任务说明和交接一起移到 `workflow/tasks/done/`，只提交 `workflow/` 下的改动：`git commit -m "主控<线>：合并 Txxx"`。

## 3. 处理收件箱
`INBOX.md` 里每一条：要么转成任务，要么记进 STATUS，处理完就从 INBOX 删掉。

## 4. 向用户汇报（不超过 6 行）
本线现在在哪、需要用户确认什么、收件箱处理了什么、ESCALATE 有没有新增（有就提示用户去 Claude 运行 `szy-replan`）、建议的下一个任务。
同类任务已经在 `done/` 里出现 2 次及以上时，建议用户运行 `$szy-runbook` 把它固化成流程。

## 5. 派发任务（用户同意，或者用户已经指定了任务）
- 编号：取 `active/` 和 `done/` 里 `<线>-T` 开头的最大编号 +1。文件名 `<线>-Txxx-简短中文名.md`，按 `workflow/.szy/templates/brief.md` 写。
- 执行者怎么选：
  - `codex`：默认。
  - `ds`：只有 `workflow/runbooks/` 里已经有状态为「已验证」的 runbook 能完全覆盖这个任务时才选。任务说明里写明 runbook 编号和全部参数。
  - `claude`：创意或规划类的工作，比如文案、PPT、方案取舍。
- 在 STATUS 的“进行中的任务”表里加一行。
- 告诉用户在哪个工具里说什么：`$szy-task <线>-Txxx`、`ds执行 <线>-Txxx`，或者“去 Claude 执行 <线>-Txxx”。
- 小任务例外：预计改动不超过 3 个文件、不需要额外读代码的，可以在本会话里直接做，做完按 `handoff.md` 收尾，然后回到第 2 步合并。

## 6. 不要越权
需要改里程碑、改线路范围、新开线，或者和 MAP 冲突的：不要自己决定。写进 `ESCALATE.md`，告诉用户去 Claude 处理。
