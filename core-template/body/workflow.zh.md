# {{PLATFORM_NAME}} Native Project Workflow（{{PLATFORM_NAME}} 原生项目工作流）

## Overview（技能用途）

本技能用于在仓库中 bootstrap 一个可持续运行的项目治理与开发工作流。它主要负责项目初始化或重新对齐需求，不应该是每次后续会话都必须显式重调的依赖。完成初始化后，后续对话应优先从仓库内部文件继续，而不是再次显式调用本技能。

## When to Use（触发规则）

1. 新项目启动，或需求/边界依然模糊、需要进行头脑风暴时。
2. 项目规范文档丢失、漂移或需要重新对齐流程时。
3. 关键词匹配：启动流程、标准化流程、工作流、TASK-000、TASK-001、PATCH-TASK。

## Repo Files（仓库文件）

根据项目规模与复杂性，在仓库根目录维护以下文件：

### 核心必备文件
- `STATUS.md`：唯一的流程状态指挥塔，记录 Phase、Task、Gate、Allowed Now 和 Next action。
- `specs/TASK-xxx.md`（如 `TASK-001.md`）：用于正常开发任务的可执行任务卡。
- `specs/PATCH-TASK.md`：**微小修补记录本**。用于记录和追加所有样式微调、拼写修正、单行配置等微小修改。

### 自适应可选文件（视项目复杂度由头脑风暴决定是否创建）
- `SPEC.md`：当项目需求复杂、有明确的 In Scope/Out of Scope 且后续会话需要长期上下文时生成。
- `DECISIONS.md`：当项目涉及架构选型、技术取舍，且需要记录取舍原因时生成。
- `BUILD_PLAN.md`：当项目需要跨越多个里程碑（Milestone）进行长期规划时生成。

## Persistent Project Instructions（持久化项目约束）

在仓库内第一次有意义地调用本技能时，如果 `{{CONFIG_FILE}}` 不存在，就应主动创建它，让后续会话能自动从这些文件持续运行。

如果 `{{CONFIG_FILE}}` 不存在，按下面精简区块创建：

```md
{{CONFIG_HEADER}}

## Workflow Defaults

- 后续会话启动时，先读 `{{CONFIG_FILE}}`、`STATUS.md` 和当前任务卡。
- 只有当规划、范围或里程碑判断依赖它们时，才读 `SPEC.md`、`DECISIONS.md` 和 `BUILD_PLAN.md`（如果存在）。
- 对于微小修补（如样式微调、拼写错误、单行配置等），无需创建新任务卡，可直接在 `specs/PATCH-TASK.md` 中追加记录并进行修改，直接交付。
- 在必需的 Gate 停下：`Brainstorm Review`、`Implementation Approval`、`Sync Review`。
- 以 `Verify` 和 `Review` 结束实现。
- 每次更新或通过 Gate 后，必须立即更新 `STATUS.md`。在 `STATUS.md` 反映新状态之前，不得宣告 Gate 已通过。
```

如果 `{{CONFIG_FILE}}` 已存在，只更新或追加 `## Workflow Defaults` 这一段，不要整体替换。

## Continuation Contract（后续续跑约定）

后续新对话默认按以下顺序启动，以实现“脱离 Skill 续跑”：
1. 读取 `{{CONFIG_FILE}}` 确定工作流默认规则。
2. 读取 `STATUS.md` 确定当前所处阶段和允许动作。
3. 读取当前任务卡（普通任务为 `specs/TASK-xxx.md`，微小修补为 `specs/PATCH-TASK.md`）。
4. 在采取动作前，严格遵守 `STATUS.md` 里的当前 Gate。

---

## Execution Flow（执行流程）

### 1. 识别任务类型（分流）
* **微小修补 (Patch Task)**：如果任务属于样式微调、拼写修正、简单文字或单行配置等低风险改动，**直接进入微小修补流程**。
* **普通开发任务**：如果涉及多步骤、跨文件或新功能开发，**进入标准开发流程**。

### 2. 微小修补流程 (Patch Flow)
1. **记录**：在 `specs/PATCH-TASK.md` 中以无序列表形式追加一条记录（如 `- [ ] 修复前端按钮字体未居中的样式问题`）。
2. **执行**：直接修改代码并进行本地验证。
3. **交付**：在 `specs/PATCH-TASK.md` 中标记为已完成。该过程无需创建独立的 TASK 卡，无需通过 Gate 审批。

### 3. 标准开发流程 (Standard Flow)
1. **需求不清晰时 (头脑风暴)**：
   - 创建 `specs/TASK-000.md`，采用以下 8 项固定结构梳理需求：
     1. 项目名称 + 目标
     2. 用户角色与使用场景
     3. 核心页面 / 核心流程
     4. 首版范围（In Scope）
     5. 明确不做（Out of Scope）
     6. 技术方向与关键依赖
     7. 风险 / 待确认问题
     8. Done when
   - 针对缺失字段进行精准追问（每轮追问限制在 1-5 个具体问题），将收集到的信息补充进 `specs/TASK-000.md`。
   - 梳理完毕后，将成果沉淀进 `SPEC.md`（如适用），并停在 `Brainstorm Review`。
2. **生成任务卡**：
   - 收到用户明确的建卡授权（如输入 `create-task`）后，创建下一张任务卡 `specs/TASK-xxx.md`。
   - 任务卡包含：`Brainstorm Summary`、`Detailed Tasks` 和 `Verify Plan`。
   - 设置 `STATUS.md` 并停在 `Implementation Approval`。
3. **编码与实现**：
   - 收到用户明确的开发授权（如输入 `start-implementation`）后，开始编写代码。
   - 严格按照任务卡的范围执行，禁止自行扩大范围。
4. **验证与评审 (Verify & Review)**：
   - 开发完成后，必须进行本地验证（如运行单测、启动服务检查）。
   - 提供评审报告：说明改动的文件、验证方式和结果。
   - 更新 `STATUS.md` 并停在 `Sync Review`。
5. **里程碑同步**：
   - 收到用户明确的同步确认后，更新 `BUILD_PLAN.md`（如适用），标志着当前任务卡正式闭环。

---

## Gates（硬关卡）

- `Brainstorm Review`：头脑风暴完成、明确可选文档与边界后停止，等待建卡授权。
- `Implementation Approval`：任务卡和执行计划就绪、编写代码前停止，等待开发授权。
- `Sync Review`：代码实现及本地验证完成后停止，等待最终同步与结卡授权。

> [!WARNING]
> - 澄清性输入或用户补充说明**不等于** Gate 批准。
> - `create-task` 仅批准建卡；`start-implementation` 仅批准开发；明确的评审通过才可通过 `Sync Review`。
> - `proceed` 为模糊词。如收到 `proceed`，Agent 必须追问用户是要 `create-task` 还是 `start-implementation`。

---

## Hard Rules（硬约束）

- **普通开发没有任务卡绝不编码**。
- **没有 Verify 和 Review 绝不交付**。
- **微小修补除外**：微小修补可免除建卡和 Gate 流程，直接修改并在 `specs/PATCH-TASK.md` 记录。
- **自适应文档**：只在有里程碑规划需要时维护 `BUILD_PLAN.md`；只在技术选型复杂时维护 `DECISIONS.md`。

---

## Status Output（状态报告格式）

当用户提问“现在到哪一步了”时，必须报告以下 6 项：
1. **Current Phase** — 当前阶段
2. **Current Task** — 当前任务（文件路径）
3. **Current Gate** — 当前关卡
4. **Allowed Now** — 当前允许动作
5. **Blocking Issue** — 阻塞问题（或 None）
6. **Next Action** — 下一步行动
