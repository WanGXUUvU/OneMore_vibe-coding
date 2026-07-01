#!/usr/bin/env bash
# generate.sh — 初始化项目工作流文件并安装 minipower 技能（一键式安装器）

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/minipower"
VERSION="$(date +%Y-%m-%d)"

# ─────────────────────────────────────────────
# 颜色 & 样式
# ─────────────────────────────────────────────
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"

ok()   { echo -e "  ${GREEN}✓${RESET}  $*"; }
info() { echo -e "  ${CYAN}ℹ${RESET}  $*"; }
warn() { echo -e "  ${YELLOW}⚠${RESET}  $*"; }
step() { echo -e "\n${BOLD}${BLUE}  $*${RESET}"; }
separator() { echo -e "\n${DIM}  ────────────────────────────────────${RESET}"; }

ask() {
  local var="$1"
  local prompt="$2"
  echo -e ""
  printf "  ${BOLD}❯${RESET} ${prompt} "
  if [ -t 0 ]; then
    read -r "$var" < /dev/tty
  else
    read -r "$var"
  fi
}

print_header() {
  if [[ -t 1 && -n "${TERM:-}" ]]; then clear; fi
  echo ""
  echo -e "  ${BOLD}${CYAN}╔══════════════════════════════════════════╗${RESET}"
  echo -e "  ${BOLD}${CYAN}║${RESET}  ${BOLD}🛠  minipower 一键安装与初始化器${RESET}  ${DIM}v${VERSION}${RESET}  ${BOLD}${CYAN}║${RESET}"
  echo -e "  ${BOLD}${CYAN}╚══════════════════════════════════════════╝${RESET}"
  echo ""
}

print_header

# ─────────────────────────────────────────────
# 内置模板定义 (Heredocs)
# ─────────────────────────────────────────────

# 1. 极简工作流默认约束
read -r -d '' WORKFLOW_RULES_TEMPLATE << 'EOF' || true

## Workflow Defaults (Minipower)

### 1. 启动与会话恢复 (Startup & Continuation)
- 每次新对话启动或切换 Agent 时，首要读取本文件、`STATUS.md`、当前任务卡（如有）以及 `BUILD_PLAN.md`（如有）。
- 如果 `STATUS.md` 中有活跃的 Goal，必须自动整理进度向用户发送状态报告，并询问如何继续，以实现无缝恢复续跑。

### 2. 核心工作流流转 (Workflow Execution)
AI 必须根据当前任务是否使用任务卡，进入对应的闭环流转流程：
- **建卡开发流 (With Task Card)**:
  `建卡 (根据 specs/TASK-card.md 创建) -> 编码实现 -> 运行测试验证 -> [若测试失败] 修复代码并重新测试 -> [测试通过] 记录 STATUS.md Change Log 并重置状态 -> 询问用户下一个任务是否需要建立任务卡`
- **直接执行流 (Without Task Card)**:
  `直接修改代码 -> 运行测试验证 -> [若测试失败] 修复代码并重新测试 -> [测试通过] 记录 STATUS.md Change Log 并重置状态 -> 询问用户下一个任务是否需要建立任务卡`

### 3. 状态与归档规则 (Status & Archiving Rules)
- **卡片管理**：默认不建立任务卡。只有收到明确建卡授权（如 `create-task`）时才在 `specs/` 目录下建卡。
- **状态行为边界**：严格遵守 `STATUS.md` 中的 Status 指引：
  - `planning`：仅限需求与规划，禁止改码。
  - `coding`：允许修改代码与执行本地验证。
  - `waiting-review`：暂停修改代码，等待用户反馈。
  - `None`：无活跃任务。
- **归档闭环**：代码通过验证后，在 `STATUS.md` 的 `Change Log` 中追加修改记录（日期、目标、修改文件、备注）。若根目录下存在 `BUILD_PLAN.md`，同步更新其里程碑进度。更新 `STATUS.md` 将 Goal 设为 `None`，Status 设为 `None`，并在完成归档后，必须主动询问用户下一个任务是否需要建立任务卡。

### 4. 状态报告格式 (Status Reporting)
- 当用户提问“现在到哪了”或会话启动时，必须清晰报告以下 4 项：
  1. **Goal** — 当前目标任务卡
  2. **Status** — 当前状态
  3. **Next Action** — 下一步行动
  4. **Latest Change Log** — 最近修改记录
EOF

# 2. STATUS.md 模板
read -r -d '' STATUS_TEMPLATE << 'EOF' || true
# STATUS

## Current Status
- **Goal**: specs/TASK-000.md
- **Status**: planning  # [planning | coding | waiting-review | None]
- **Next Action**: 开启头脑风暴，对齐需求

## Change Log (修改历史记录)
| Date | Goal / Task | Files Modified | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| — | — | — | — | — |
EOF

# 3. TASK-000.md 模板
read -r -d '' TASK_000_TEMPLATE << 'EOF' || true
# TASK-000: 头脑风暴与需求对齐

## 1. 项目名称 + 目标
- 

## 2. User Roles & Use Cases (用户角色与使用场景)
- 

## 3. Core Pages / Flows (核心页面与主流程)
- 

## 4. In Scope (首版范围)
- 

## 5. Out of Scope (明确不做)
- 

## 6. Technical Direction & Key Dependencies (技术方向与关键依赖)
- 

## 7. Risks / Open Questions (风险与待确认问题)
- 

## 8. Done when (最终验收标准)
- [ ] 
EOF

# 4. TASK-card.md 模板
read -r -d '' TASK_CARD_TEMPLATE << 'EOF' || true
# TASK-xxx: [任务简短标题]

## 1. 任务背景与目标
- [简述本张任务卡要解决什么问题]

## 2. 需求与边界
- **In Scope (要做)**:
  - [ ] 
- **Out of Scope (不做)**:
  - [ ] 

## 3. 实现计划 (Todo List)
- [ ] 

## 4. 验证与评审 (Done when)
- **Verify Plan**: [如何进行本地验证，例：运行 npm run test]
- **Review Report**: [开发完成后，AI 在此填写实际修改点和自审结果]
EOF


# ─────────────────────────────────────────────
# 步骤 1 — 初始化当前项目文件
# ─────────────────────────────────────────────
separator
step "步骤 1 / 2  —  📁  初始化项目治理文件 (根目录)"
echo ""
echo -e "  选择为当前项目初始化的专属配置文件类型："
echo -e "    ${BOLD}1)${RESET}  🔶  Claude Code  ${DIM}(CLAUDE.md)${RESET}"
echo -e "    ${BOLD}2)${RESET}  🐙  GitHub Copilot  ${DIM}(.github/copilot-instructions.md)${RESET}"
echo -e "    ${BOLD}3)${RESET}  ✦   Codex  ${DIM}(AGENTS.md)${RESET}"
echo -e "    ${BOLD}4)${RESET}  💻  CodeBuddy  ${DIM}(CODEBUDDY.md)${RESET}"
echo -e "    ${BOLD}0)${RESET}  暂不初始化项目文件  ${DIM}(仅进行全局 Skill 安装)${RESET}"

ask init_choice "请输入编号 [0-4]："

CFG_FILE=""
CFG_HEADER=""

case "$init_choice" in
  1) CFG_FILE="CLAUDE.md"; CFG_HEADER="# CLAUDE.md" ;;
  2) CFG_FILE=".github/copilot-instructions.md"; CFG_HEADER="# Copilot Instructions" ;;
  3) CFG_FILE="AGENTS.md"; CFG_HEADER="# AGENTS.md" ;;
  4) CFG_FILE="CODEBUDDY.md"; CFG_HEADER="# CODEBUDDY.md" ;;
  0|*) CFG_FILE="" ;;
esac

project_base="${CALLER_DIR:-$PWD}"

if [[ -n "$CFG_FILE" ]]; then
  # 1. 写入/追加配置文件
  target_cfg_path="$project_base/$CFG_FILE"
  mkdir -p "$(dirname "$target_cfg_path")"
  
  if [[ -f "$target_cfg_path" ]]; then
    echo -e "\n  ${YELLOW}⚠${RESET}  检测到当前项目下已存在 ${BOLD}$CFG_FILE${RESET}"
    echo -e "    ${BOLD}1)${RESET}  追加工作流约束到文件末尾 (Append)"
    echo -e "    ${BOLD}2)${RESET}  覆盖替换整个文件 (Overwrite)"
    echo -e "    ${BOLD}0)${RESET}  跳过此文件"
    ask cfg_action "请输入编号 [0-2]："
    
    case "$cfg_action" in
      1)
        if grep -q "Workflow Defaults (Minipower)" "$target_cfg_path"; then
          warn "文件中已包含 Minipower 规则，跳过追加。"
        else
          echo -e "\n$WORKFLOW_RULES_TEMPLATE" >> "$target_cfg_path"
          ok "已成功追加约束到 $CFG_FILE 末尾"
        fi
        ;;
      2)
        echo -e "$CFG_HEADER\n$WORKFLOW_RULES_TEMPLATE" > "$target_cfg_path"
        ok "已成功覆盖并重新创建 $CFG_FILE"
        ;;
      *)
        info "跳过修改 $CFG_FILE"
        ;;
    esac
  else
    echo -e "$CFG_HEADER\n$WORKFLOW_RULES_TEMPLATE" > "$target_cfg_path"
    ok "已成功创建 $CFG_FILE 并写入约束"
  fi

  # 2. 写入 STATUS.md
  target_status_path="$project_base/STATUS.md"
  write_status=true
  if [[ -f "$target_status_path" ]]; then
    echo -e "\n  ${YELLOW}⚠${RESET}  检测到已存在 ${BOLD}STATUS.md${RESET}"
    echo -e "    ${BOLD}1)${RESET}  覆盖重置 STATUS.md (Overwrite)"
    echo -e "    ${BOLD}0)${RESET}  保留现有 STATUS.md"
    ask status_action "请输入编号 [0-1]："
    [[ "$status_action" != "1" ]] && write_status=false
  fi
  
  if $write_status; then
    echo "$STATUS_TEMPLATE" > "$target_status_path"
    ok "已初始化 STATUS.md"
  else
    info "保留原有 STATUS.md"
  fi

  # 3. 创建 specs 模板
  mkdir -p "$project_base/specs"
  
  if [[ ! -f "$project_base/specs/TASK-000.md" ]]; then
    echo "$TASK_000_TEMPLATE" > "$project_base/specs/TASK-000.md"
    ok "已创建 specs/TASK-000.md 模板"
  else
    info "specs/TASK-000.md 已存在，跳过"
  fi

  if [[ ! -f "$project_base/specs/TASK-card.md" ]]; then
    echo "$TASK_CARD_TEMPLATE" > "$project_base/specs/TASK-card.md"
    ok "已创建 specs/TASK-card.md 模板"
  else
    info "specs/TASK-card.md 已存在，跳过"
  fi
fi

# ─────────────────────────────────────────────
# 步骤 2 — 全局 Skill 安装
# ─────────────────────────────────────────────
print_header
separator
step "步骤 2 / 2  —  📦  安装全局 Skill 目录"
echo ""
echo -e "  是否需要将 minipower 技能复制到平台全局技能目录？"
echo -e "    ${BOLD}1)${RESET}  🔶  安装到 Claude Code 全局目录  ${DIM}(~/.claude/skills/)${RESET}"
echo -e "    ${BOLD}2)${RESET}  🐙  安装到 GitHub Copilot 全局目录  ${DIM}(~/.copilot/skills/)${RESET}"
echo -e "    ${BOLD}3)${RESET}  ✦   安装到 Codex 全局目录  ${DIM}(~/.codex/skills/)${RESET}"
echo -e "    ${BOLD}4)${RESET}  💻  安装到 CodeBuddy 全局目录  ${DIM}(~/.codebuddy/skills/)${RESET}"
echo -e "    ${BOLD}5)${RESET}  🌐  安装到全部平台"
echo -e "    ${BOLD}0)${RESET}  暂不安装全局技能"

ask skill_choice "请输入编号 [0-5]："

FILTER=""
case "$skill_choice" in
  1) FILTER="claude" ;;
  2) FILTER="copilot" ;;
  3) FILTER="codex" ;;
  4) FILTER="codebuddy" ;;
  5) FILTER="all" ;;
  0|*) FILTER="" ;;
esac

install_to_platform() {
  local id="$1"
  local target_dir="$2"
  local help_msg="$3"

  echo -e "  ${BOLD}${MAGENTA}→${RESET} 安装 ${BOLD}minipower${RESET} 到 ${BOLD}${id}${RESET}..."

  if [[ ! -d "$SKILL_SRC" ]]; then
    warn "源目录 $SKILL_SRC 不存在！"
    return 1
  fi

  mkdir -p "$target_dir"
  rm -rf "$target_dir/minipower"
  cp -r "$SKILL_SRC" "$target_dir/"

  ok "已成功安装至 $target_dir/minipower/"
  if [[ -n "$help_msg" ]]; then
    info "$help_msg"
  fi
  echo ""
}

if [[ -n "$FILTER" ]]; then
  copilot_dest="$HOME/.copilot/skills"
  claude_dest="$HOME/.claude/skills"
  codex_dest="$HOME/.codex/skills"
  codebuddy_dest="$HOME/.codebuddy/skills"

  if [[ "$FILTER" == "all" || "$FILTER" == "copilot" ]]; then
    install_to_platform "copilot" "$copilot_dest" "请在 VS Code 中执行 Developer: Reload Window 使 Copilot skill 生效"
  fi

  if [[ "$FILTER" == "all" || "$FILTER" == "claude" ]]; then
    install_to_platform "claude" "$claude_dest" "请重启 Claude Code（或执行 /reload）使 skill 生效"
  fi

  if [[ "$FILTER" == "all" || "$FILTER" == "codex" ]]; then
    install_to_platform "codex" "$codex_dest" "请重新打开终端或重启 Codex 使 skill 生效"
  fi

  if [[ "$FILTER" == "all" || "$FILTER" == "codebuddy" ]]; then
    install_to_platform "codebuddy" "$codebuddy_dest" "请重启 CodeBuddy 插件使 skill 生效"
  fi
fi

# ─────────────────────────────────────────────
# 清理本地临时下载文件（用户级安装且通过 curl 触发时）
# ─────────────────────────────────────────────
if [[ -n "$CALLER_DIR" && "$CALLER_DIR" != "$SCRIPT_DIR" ]]; then
  # 如果是从临时目录被 install.sh 调用运行，不要提示清理，由 install.sh 自动处理。
  true
fi

separator
echo -e "\n  ${GREEN}${BOLD}🎉  恭喜，安装与配置处理完成！${RESET}\n"
