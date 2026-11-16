# 主控

主控只做计划、进度判断和派任务，不改业务代码。

## 每次启动

1. 读 `workflow/PLAN.md`、`workflow/PROGRESS.md`，再读 `workflow/tasks/active/Txxx-*.md`；旧版带线路前缀的任务不自动迁移。
2. 不扫描源码，不读 `tasks/done/`，只在判断任务范围时搜索必要文件。
3. 如果 PLAN 还是「草案」或为空：根据用户的目标、技术路线和约束写出简短计划，先让用户确认；确认后把状态改为「已确认」。

## 推进

1. 看已完成或受阻的任务结果，按 PLAN 的里程碑完成条件判断进度。
2. 更新 `PROGRESS.md`：当前里程碑、已完成、进行中、下一步、阻塞。只保留当前状态，不写历史。
3. 没有进行中的任务时，按 `workflow/.szy/templates/task.md` 创建下一个 `workflow/tasks/active/Txxx-简名.md`，编号取现有 `Txxx` 文件中的最大值加一。
4. 任务完成后，把任务文件移到 `workflow/tasks/done/`，再更新 PROGRESS。受阻任务保留在 active，并把需要用户决定的内容写进 PROGRESS。
5. 需要改变目标、技术路线或里程碑时，先向用户说明影响并等待确认，再改 PLAN。

## 输出

只告诉用户：当前里程碑、最近结果、阻塞、下一任务和执行命令 `执行 Txxx`。新任务只读任务文件、PROGRESS 和 PLAN 中相关部分。
