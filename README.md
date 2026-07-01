# Agent Workflow Skill Generator (Agent 工作流技能安装器)

<p align="center">
  <img src="./docs/assets/workflow-skills-overview.svg" alt="Agent Workflow Skills overview" width="100%" />
</p>

一个一键式交互安装器，为 AI coding agent 快速初始化 **MiniPower** 极简项目自适应工作流。

只需运行一个脚本，即可交互式地为当前项目根目录初始化轻量级项目治理文件，并可选择将通用的 `MiniPower` 技能安装到平台全局目录中。

## 为什么选择 MiniPower？

- **默认零开销**：对于日常微调或单行改动，默认无需建卡。直接编写代码、执行验证、归档修改并交付，把行政开销降到最低。
- **按需自主建卡**：当面临复杂任务时，Agent 会自动读取本地模板（`specs/TASK-card.md`）并在工作区自主写入新开发卡（`specs/TASK-xxx.md`），免除外部脚本依赖。
- **无缝恢复续跑**：规定 Agent 每次启动新会话或切换产品时，首要检查并读取 `STATUS.md` 以自动恢复活跃任务上下文并进行状态汇报，规避大模型“失忆”问题。
- **测试-失败-修复环路**：在配置文件中显式规定了闭环的开发者测试循环（编写代码 -> 测试验证 -> 失败则修复重测 -> 通过则归档），确保主干分支始终处于健康状态。

## 项目初始化文件 (项目目录)

在项目根目录下运行安装器时，会创建以下文件：
- **专属配置文件**（根据具体宿主，生成 `CLAUDE.md`、`AGENTS.md`、`.github/copilot-instructions.md` 或 `CODEBUDDY.md`）：持久化保存结构化的工作流指令。支持追加（不破坏原有内容）或覆盖。
- `STATUS.md`：唯一的流程状态指挥塔，记录当前任务、状态、下一步行动以及修改历史记录（Change Log）。
- `specs/TASK-000.md`：用于头脑风暴和需求对齐的卡片模板。
- `specs/TASK-card.md`：用于日常开发的任务卡模板。

## 支持宿主 (全局技能目录)

你可以选择将通用的 `MiniPower` 技能文件夹直接复制并注册到以下平台的全局技能路径中，方便在对话里随时调用：
- **Claude Code** (`~/.claude/skills/`)
- **GitHub Copilot** (`~/.copilot/skills/`)
- **Codex** (`~/.codex/skills/`)
- **CodeBuddy** (`~/.codebuddy/skills/`)

## 快速开始

在需要初始化的目标项目目录下，执行以下一键安装命令：

```bash
curl -fsSL https://raw.githubusercontent.com/WanGXUUvU/OneMore_vibe-coding/main/install.sh | bash
```

或者手动克隆运行：

```bash
git clone --depth 1 https://github.com/WanGXUUvU/OneMore_vibe-coding.git && cd OneMore_vibe-coding && ./generate.sh
```
