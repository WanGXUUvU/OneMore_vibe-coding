---
name: minipower
description: 极简自适应项目工作流运行指南 (Runtime Guide)。用于指导 AI 在开发过程中遵守规范流程，管理任务状态与任务卡。
---
# Minipower Native Project Workflow (Runtime Guide)

本技能用于指导 AI 运行**极简自适应项目工作流**。项目初始化完成后，AI 应当在开发中严格遵守本项目工作流，通过 `STATUS.md` 和任务卡进行自我治理与状态闭环。

## 一、 仓库文件说明与填写示范 (Repo Files & Examples)

项目运行依赖以下在根目录已初始化好的文件进行开发治理：

### 1. 项目专属配置文件（如 `CLAUDE.md`）
- **说明**：持久化存储极简工作流默认约束。

### 2. `STATUS.md`
- **说明**：唯一的流程状态指挥塔，记录当前任务、状态、下一步行动以及修改历史记录（Change Log）。
- **填写示范**：
  ```markdown
  # STATUS
  
  ## Current Status
  - **Goal**: specs/TASK-002.md
  - **Status**: coding  # [planning | coding | waiting-review | None]
  - **Next Action**: 编写登录接口单元测试
  
  ## Change Log (修改历史记录)
  | Date | Goal / Task | Files Modified | Status | Notes |
  | :--- | :--- | :--- | :--- | :--- |
  | 2026-07-01 | specs/TASK-000.md | None | Completed | 完成图书笔记社区的需求对齐与头脑风暴 |
  | 2026-07-01 | specs/TASK-001.md | src/models/Note.js, src/routes/notes.js | Completed | 实现笔记发布接口并完成基本校验 |
  ```

### 3. `specs/TASK-000.md`（头脑风暴与需求对齐卡）
- **说明**：用于理清最初的需求、项目范围和验收标准。
- **填写示范**：
  ```markdown
  # TASK-000: 头脑风暴与需求对齐
  
  ## 1. 项目名称 + 目标
  - OneMore 图书分享平台：构建一个支持用户上传、阅读与对笔记评分的极简社区。
  
  ## 2. User Roles & Use Cases (用户角色与使用场景)
  - 读书爱好者：可以上传读书笔记，并能对其他用户的笔记进行 1-5 星评分。
  
  ## 3. Core Pages / Flows (核心页面与主流程)
  - 登录页 -> 主页（笔记展示瀑布流） -> 笔记详情页（评分与评论区） -> 发布笔记页。
  
  ## 4. In Scope (首版范围)
  - 基于 React 的极简前端页面及发布卡片。
  
  ## 5. Out of Scope (明确不做)
  - 第三方社交登录（仅使用简单账号密码）。
  - 笔记的全文检索（首版仅按时间排序）。
  
  ## 6. Technical Direction & Key Dependencies (技术方向与关键依赖)
  - React, TailwindCSS, Express, MongoDB。
  
  ## 7. Risks / Open Questions (风险与待确认问题)
  - 评分是否需要防刷限制？（首版暂不限制，留待 M2 处理）。
  
  ## 8. Done when (最终验收标准)
  - [x] 用户能正常发布图书笔记并在主页看到。
  - [x] 用户可以成功对笔记评分且分数实时更新。
  ```

### 4. `specs/TASK-xxx.md`（具体的开发任务卡）
- **说明**：由 Agent 动态生成的执行卡，包含 Todo 和开发完成后回写的自审报告。
- **填写示范**：
  ```markdown
  # TASK-002: 实现笔记评分接口
  
  ## 1. 任务背景与目标
  - 用户在详情页需要进行评分，本任务需要实现后端的 `/api/notes/:id/rate` 接口，并更新对应笔记的平均分。
  
  ## 2. 需求与边界
  - **In Scope (要做)**:
    - [ ] 实现 POST `/api/notes/:id/rate` 接口，接受 rating (1-5) 参数。
    - [ ] 更新数据库对应笔记的 averageRating 和 rateCount 字段。
  - **Out of Scope (不做)**:
    - 修改已评过的分值（首版仅允许首次评分）。
  
  ## 3. 实现计划 (Todo List)
  - [ ] 在 `src/models/Note.js` 中增加 `rateCount` 和 `ratingsSum` 字段。
  - [ ] 在 `src/routes/notes.js` 中编写 POST `/api/notes/:id/rate` 逻辑。
  - [ ] 在 `tests/notes.test.js` 中编写接口单元测试并跑通。
  
  ## 4. 验证与评审 (Done when)
  - **Verify Plan**: 运行 `npm run test tests/notes.test.js` 验证接口。
  - **Review Report**:
    - 改动文件：`src/models/Note.js`, `src/routes/notes.js`, `tests/notes.test.js`
    - 验证结果：单元测试全部通过（共 3 个 Test Suites，6 个 Tests 均 Passes）。
  ```

### 5. `BUILD_PLAN.md`（可选的动态路线图）
- **说明**：**安装时不默认创建**。当进行 `TASK-000` 头脑风暴后，若确认项目规模较大、需要划分多个里程碑（Milestone）进行长期规划，**由 AI 在项目根目录下动态创建该文件**以记录顶层里程碑的目标与状态。
- **填写示范**：
  ```markdown
  # BUILD_PLAN
  
  ## Goal
  OneMore 图书分享平台：构建一个支持用户上传、阅读与对笔记评分的极简社区。
  
  ## Milestones
  
  ### M1: 基础笔记发布与展示
  - Objective: 跑通核心的用户发布笔记与主页展示流程。
  - Scope: 账号登录，发布接口，前端瀑布流列表。
  - Deliverables: Note 数据库模型，发布路由，前端瀑布流组件。
  - Verify: 编写单元测试并跑通发布流程。
  - Exit: 用户能正常发布图书笔记并在主页看到。
  
  ### M2: 评分与社交互动
  - Objective: 实现用户互动评分和评论机制。
  - Scope: 评分路由，详情页评分与评论区前端组件。
  - Deliverables: 评分接口，平均分计算与数据库更新。
  - Verify: 跑通评分单测，验证前端评分点击后的分数变化。
  - Exit: 用户可以成功对笔记评分且分数实时更新。
  
  ## Current Milestone
  - Current milestone: M2
  - Why this one first: M1 已于 2026-07-01 交付，本阶段重点攻克评分核心交互与算分逻辑。
  
  ## Readiness
  - [x] M1: 基础笔记发布与展示
  - [/] M2: 评分与社交互动
  ```

---

## 二、 运行流程与状态规范 (Execution Flow)

### 1. 会话启动与上下文恢复 (Startup & Restore Context)
每次新对话启动，或者用户切换了 Agent 产品续跑开发时，AI **必须首先执行以下操作以恢复项目上下文**：
1. **读取状态文件**：优先读取根目录下的专属配置文件（如 `CLAUDE.md`、`AGENTS.md` 等）与 `STATUS.md`。
2. **分析与恢复上下文**：
   - **已有活跃任务**（`STATUS.md` 中 `Status` 为 `planning`、`coding` 或 `waiting-review`，且 `Goal` 指向某个任务卡文件）：
     - AI 必须立即读取该任务卡文件（如 `specs/TASK-xxx.md`）和 `BUILD_PLAN.md`（如有）。
     - 自动整理当前状态，并向用户发送状态报告（报告格式见下文），提示用户：“*已从 STATUS.md 恢复上下文。当前任务为 TASK-xxx，状态为 coding。我将继续执行该任务，或等待您的指示。*”
   - **项目处于空闲**（`STATUS.md` 中 `Status` 为 `None`，且 `Goal` 为 `None`）：
     - 向用户提示：“*当前项目无活跃任务。请问下一个开发任务需要为您建立任务卡（TASK Card）吗？*”
   - **全新项目首次启动**：
     - 若 `STATUS.md` 中 `Status` 为 `planning` 且 `Goal` 指向 `specs/TASK-000.md`，且 `specs/TASK-000.md` 尚未对齐，则自动进入 **需求对齐与头脑风暴流程**。

### 2. 任务分流识别 (Task Branching)
在日常开发中，对于用户指派的任何具体改动任务，AI 应首先识别其类型：
- **微小修补 (Patch Flow)**：样式微调、拼写错误、单行配置等低风险修改（限制在单次修改不超过 10 行、不超过 1 个文件，且不引入新接口）。
- **标准开发 (Standard Flow)**：新功能开发、跨文件修改或有逻辑风险的任务。

### 3. 微小修补流程 (Patch Flow)
- 无需新建任务卡，亦无 Gate 约束。
- 直接修改代码并进行本地验证。若测试失败，必须修复代码并重新测试，直至验证通过。
- 验证通过后，必须立即在 `STATUS.md` 的 `Change Log` 中追加一条修改记录，然后向用户宣告交付。

### 4. 标准开发流程 (Standard Flow)
标准开发遵循以下阶段，AI 在对应的 **Gate（硬关卡）** 必须主动停下等待授权：

1. **需求对齐阶段 (头脑风暴)**：
   - **核心交互原则 (禁止单次轰炸)**：AI **严禁**一次性将 8 个问题全部抛给用户，这会造成极高的交互门槛。必须采取**分步引导、增量沉淀**的交互式追问。
   - **交互式对齐三部曲**：
     * **第一步：主线对齐** — 首先询问项目名称、核心目标和核心使用场景。收到回复后，由 AI 整理并初步填入 `specs/TASK-000.md` 中的 `1. 项目名称 + 目标`、`2. 使用场景` 和 `3. 核心页面与主流程`。
     * **第二步：范围对齐** — 接着追问并对齐“首版要做什么 (In Scope)”与“明确不做声明 (Out of Scope)”。收到回复后，整理填入 `4. In Scope` 和 `5. Out of Scope`。
     * **第三步：技术与验收对齐** — 最后追问并对齐“技术路线、关键依赖、潜在风险以及最终验收标准 (Done when)”。收到回复后，整理填入 `6. 技术方向`、`7. 风险/待确认问题` 和 `8. Done when`。
   - **增量保存与反馈**：在每一轮交互中，AI 应当**立即将对齐好的内容写入 specs/TASK-000.md 中**，并在聊天中向用户简短同步当前已记录的成果，随后抛出下一组追问。
   - **追问数量硬约束**：每轮对话中，AI 的精准追问必须**限制在 1-3 个具体问题**内。
   - **里程碑规划（如适用）**：如果在需求对齐过程中，确认项目规模较大或涉及多阶段开发，**AI 必须在此阶段主动在根目录下创建 `BUILD_PLAN.md`**，列出 Milestone 规划，指明当前正在执行的里程碑。如果项目简单，则无需创建。
   - 需求完全对齐后，更新 `STATUS.md` 并停在 **`Brainstorm Review`** 关卡，等待用户确认并下达 `create-task` 指令。
2. **建卡阶段**：
   - 用户授权建卡（输入 `create-task`）后，AI 应当读取本地模板 `specs/TASK-card.md`，填充内容后在 `specs/` 目录下创建新任务卡 `specs/TASK-xxx.md`。
   - 更新 `STATUS.md`（Goal 设为该任务卡，Status 设为 `coding`）。
   - 停在 **`Implementation Approval`** 关卡，等待用户下达开发授权（如输入 `start-implementation` 或允许开发）。
3. **开发与编码阶段**：
   - 严格在任务卡规定的范围内编写代码与测试，严禁自行扩大范围。
4. **验证与评审阶段 (Verify & Review)**：
   - 编码完成后，运行本地验证（单元测试或服务检查）。若测试失败，必须修复代码并重新测试，直至验证通过。
   - 在任务卡 `specs/TASK-xxx.md` 的 `Review Report` 栏中追加自审结果（包含改动文件、验证方式和结果）。
   - 更新 `STATUS.md`（Status 设为 `waiting-review`）。
   - 停在 **`Sync Review`** 关卡，等待用户最终 sync 验收通过。
5. **结卡与状态归档**：
   - 验收通过后，在 `STATUS.md` 的 `Change Log` 表格中追加记录。
   - **更新里程碑（如适用）**：如果项目根目录下存在 `BUILD_PLAN.md`，在此步骤必须同步更新 `BUILD_PLAN.md` 中里程碑的完成情况（如勾选已完成项，修改当前活动里程碑）。
   - 重置 `STATUS.md` 状态（Goal 清空或设为 `None`，Status 设为 `None`）。
   - **硬约束**：完成归档后，必须主动询问用户：“*当前任务已完成并归档。请问下一个任务需要为您建立任务卡（TASK Card）吗？*”
