# 交接收尾（所有执行者通用）

1. 用 `git status` 和 `git diff --stat` 确认改动都在任务说明的「可改范围」里。
2. **只提交本任务的文件**：用 `git add <路径...>`，不要用 `git add -A`（并行的其他线可能也有未提交的改动）。然后 `git commit -m "<线>-Txxx: 简述"`，记下 commit hash。
3. 按 `workflow/.szy/templates/handoff.md` 写 `workflow/tasks/active/<线>-Txxx-*.handoff.md`（不超过 30 行，填上 commit hash）。三个字段不要漏：
   - 「给其他线」：比如新功能需要测试线补测。
   - 「路线问题」：发现 MAP 本身有问题时写。
   - 「可固化」：这个活以后会重复做、而且步骤是固定的，就写“是”。
4. 只提交这份交接文件。
5. **不要改** `STATUS.md`、`MAP.md`、`INBOX.md`（这些由主控合并）。
6. 告诉用户：交接已写好，可以关闭本会话，回主控说 `$szy-lead <线>`。
