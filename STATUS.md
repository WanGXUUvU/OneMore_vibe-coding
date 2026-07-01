# STATUS

## Current Status
- **Goal**: 简化并解耦 Agent 引导工作流，设计并实现符合标准自定义技能格式的 `minipower` 极简自适应项目工作流。
- **Status**: Completed
- **Allowed Action**: push to remote
- **Blocked**: None
- **Next Action**: 执行 git add, commit, and push 提交至远程。

## Change Log (修改历史记录)
| Date | Goal / Task | Files Modified | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| 2026-07-01 | 重构并实现 `minipower` 极简自适应工作流 | `minipower/SKILL.md`, `minipower/references/*`, `core-template/body/*`, `core-template/references/*` | Completed | 砍掉 full/lite 模式，清除所有 lane，支持直改 patch；实现引导与运行时解耦；加入防误触覆盖的幂等性检验。 |
