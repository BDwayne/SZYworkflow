<!-- SZY-WORKFLOW:BEGIN -->
## 工作流（SZY workflow）

只有两个角色，状态都在 `workflow/`，换新对话也能继续：

- **主控**：说「主控」或 `$szy-lead`。读 `PLAN.md`、`PROGRESS.md` 和 `active/Txxx-*.md`，判断里程碑并派下一个任务；不改业务代码。
- **任务**：说「执行 T001」或 `$szy-task T001`。只读任务说明列出的文件，完成一个任务并把结果写回任务文件。

每次只读当前需要的文件，不扫描整个项目；任务会话不改别的任务、PLAN 或 PROGRESS。任务编号全局递增。
<!-- SZY-WORKFLOW:END -->
