---
name: minipower
description: 极简项目管理工作流引导工具 (Bootstrap Tool)。用于初始化仓库配置，写入极简运行约束，并开启头脑风暴。
---
# Minipower Native Project Workflow (Bootstrap Tool)

## Overview（技能用途）

本技能是一个 **Bootstrap（脚手架引导）工具**，用于在仓库中初始化极简自适应项目工作流。它只负责项目的初始化配置和首轮需求对齐（TASK-000），**不是长期运行时依赖**。

完成初始化后，后续所有对话和会话应当直接读取并遵守仓库根目录下的配置文件（`CLAUDE.md` / `AGENTS.md` / `.github/copilot-instructions.md` / `CODEBUDDY.md`）和 `STATUS.md`，实现“脱离 Skill 运行”。

## Repo Files（仓库文件）

在仓库根目录维护以下文件：

### 核心必备文件
- `STATUS.md`：唯一的流程状态指挥塔，记录 Phase、Task、Gate、Allowed Now 和 Next action。
- `specs/` 目录：存放任务卡（如有）。

### 可选文件（根据项目规模动态维护）
- `BUILD_PLAN.md`：动态路线图。记录顶层里程碑（Milestone）目标与状态，它是一个活文档，可以随着项目推进、需求变更而随时修改。

## Persistent Project Instructions（持久化项目约束）

在仓库内第一次有意义地调用本技能时，如果项目配置文件不存在，则必须主动创建它，并将以下**完备的极简运行约束**写入其中：

```md
## Workflow Defaults (Minipower)

- **启动契约**：每次对话开始时，先读取本文件、`STATUS.md` 和当前任务卡（如有）。
- **核心流程流转轨**：
  - **普通开发**：`TASK-000 (头脑风暴) -> create-task (授权建卡) -> TASK-xxx (规划) -> start-implementation (授权开发) -> coding (编码与验证) -> Change Log 归档 -> 询问是否为下一步建卡`
  - **微小修补**：`直接修改代码 -> 本地验证 -> STATUS.md Change Log 归档 -> 交付`
- **状态指挥塔**：严格遵守 `STATUS.md` 中的状态与行动权限指引：
  - `Status`：`planning` (计划中) | `coding` (编码中) | `waiting-review` (等待确认) | `None` (空闲)
  - `Allowed Action`：`plan only` (禁止写代码) | `code and verify` (可写代码测试) | `wait only` (等待指令)
- **修改历史登记**：每次修改通过后，必须在 `STATUS.md` 的 `Change Log` 中追加一条修改记录（包含日期、目标、修改文件、备注）。更新 `STATUS.md` 前，不得宣告任务完成。
- **状态报告格式**：当用户提问“现在到哪了”时，必须报告：1. Goal 2. Status 3. Allowed Action 4. Blocked 5. Next Action 6. Latest Change Log.
- **硬约束**：标准开发无任务卡绝不写代码；没有验证与自审绝不交付；每次任务完成后，必须询问用户是否为接下来的开发建卡。
- **动态路线图**：`BUILD_PLAN.md`（如有）是动态里程碑，可随时修改和调整。
```

*如果配置文件已存在，只更新或追加 `## Workflow Defaults (Minipower)` 这一段，不要整体替换。*

---

## Execution Flow（脚手架引导步骤）

本技能只负责首次运行时的初始化引导与保护分流：

1. **幂等性校验与保护 (Re-bootstrap Protection)**：
   - AI 首先检测仓库根目录下是否已存在 `STATUS.md`，且项目配置文件中是否已包含 `Workflow Defaults (Minipower)` 规则。
   - 若判定已初始化，**AI 必须拒绝重新执行引导，禁止覆盖任何现有文件或历史**，并向用户提示：“`minipower` 工作流已激活。正在直接从现有的 STATUS.md 中恢复会话...”。随后立即将控制权移交，按照本地配置文件的规则继续。
2. **检测与配置写入**：检测并创建项目配置文件，写入 `Workflow Defaults (Minipower)` 规则。
3. **场景分流初始化**：
   - **场景 A：全新项目（空目录或需求极度模糊）**：
     - 从 `references/STATUS.md` 复制创建 `STATUS.md`，将 Goal 设为 `specs/TASK-000.md`，Status 设为 `planning`，Allowed Action 设为 `plan only`。
     - 使用 `references/TASK-000.md` 作为模板初始化 `specs/TASK-000.md` 并开启需求对齐追问。
     - 需求对齐后，将 `STATUS.md` 设为 `waiting-review` / `wait only`，并**停下等待用户确认**。
   - **场景 B：已有项目（包含现有代码，或用户已有明确开发任务）**：
     - 从 `references/STATUS.md` 复制创建 `STATUS.md`，将 Goal 直接设为**当前用户指派的具体开发任务**（若无则设为 `None`），Status 设为 `None`，Allowed Action 设为 `code and verify`。
     - **跳过 `specs/TASK-000.md` 头脑风暴**，允许 AI 直接基于现有代码库动工。
4. **交接与移交**：初始化并设置好 `STATUS.md` 后，本引导技能即告闭环。后续开发完全移交给仓库内的配置文件和状态指示器进行。
