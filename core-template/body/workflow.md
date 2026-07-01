# {{PLATFORM_NAME}} Native Project Workflow

## Overview

Use this skill to bootstrap a durable project operating model in the repository. The skill is for initialization and requirement alignment, not for every later session. After initialization, future conversations should resume from the repository files rather than by explicitly re-calling this skill.

## When to Use

1. A new project/feature starts from a vague idea or incomplete scope and needs brainstorming.
2. Project workflow files are missing, drifted, or need to be re-aligned.
3. Keyword matching: start workflow, standardize workflow, TASK-000, TASK-001.

## Repo Files

Maintain these files at the repository root:

### Mandatory Files
- `STATUS.md`: The single source of workflow state tracking Phase, Task, Gate, Allowed Now, and Next action.
- `specs/TASK-xxx.md` (e.g., `TASK-001.md`): Executable task cards under the `specs/` directory to document detail goals and Todo lists.

### Optional Files (Maintained dynamically based on project scale)
- `BUILD_PLAN.md`: Dynamic roadmap. Records top-level milestone goals and status. It is a living document that can be updated or reorganized as the project progresses.

*(Note: SPEC.md, DECISIONS.md, and specs/PATCH-TASK.md are deleted to minimize file overhead. Trivial patches do not need log files).*

## Persistent Project Instructions

On the first meaningful invocation in a repository, create `{{CONFIG_FILE}}` if it does not already exist so the continuation rules persist for later sessions.

If `{{CONFIG_FILE}}` does not exist, create it with exactly this compact workflow section:

```md
{{CONFIG_HEADER}}

## Workflow Defaults

- In later sessions, read `{{CONFIG_FILE}}`, `STATUS.md`, and the current task card first.
- Read `BUILD_PLAN.md` (if it exists) only when milestone decisions depend on it.
- For minor fixes (e.g., style tweaks, typos, single-line configurations), do not create separate task cards. Modify the code directly and run local verifications, bypassing all documentation and gate approval processes.
- For standard development tasks, stop at required gates: `Brainstorm Review`, `Implementation Approval`, and `Sync Review`.
- End implementation with `Verify` and `Review`.
- Update `STATUS.md` immediately after any gate is updated or passed. Do not declare a gate passed before `STATUS.md` reflects the state.
```

If `{{CONFIG_FILE}}` already exists, update or append only the `## Workflow Defaults` section without replacing unrelated contents.

## Continuation Contract

Future conversations should resume by default in this order to run independently of the skill:
1. Read `{{CONFIG_FILE}}` for default workflow rules.
2. Read `STATUS.md` to identify the current phase and allowed actions.
3. Read the current task card (e.g., `specs/TASK-xxx.md` for standard tasks).
4. Respect the current gate in `STATUS.md` before taking any actions.

---

## Execution Flow

### 1. Identify Task Type (Branching)
* **Minor Fix (Patch Task)**: If the task belongs to style tweaks, spelling corrections, simple text fixes, or single-line config changes, **directly enter the Patch Flow**.
* **Standard Development**: If the task involves multi-step, cross-file edits, or new features, **enter the Standard Flow**.

### 2. Patch Flow
- **Direct Edit**: No documentation or task card creation required. Directly modify the code locally and test. Complete once tests pass.

### 3. Standard Flow
1. **Requirements Gathering (Brainstorming)**:
   - Create `specs/TASK-000.md` with these 8 fixed items:
     1. Project Name + Goal
     2. User Roles & Use Cases
     3. Core Pages / Flows
     4. In Scope
     5. Out of Scope
     6. Technical Direction & Key Dependencies
     7. Risks / Open Questions
     8. Done when
   - Ask targeted follow-up questions (limited to 1-5 per turn) to fill in the missing fields of `specs/TASK-000.md`.
   - Once completed, stop at `Brainstorm Review`.
2. **Create Task Card**:
   - Upon receiving explicit user authorization (e.g., `create-task`), create `specs/TASK-xxx.md`.
   - The card must contain: `Goals`, `Scope (In/Out of Scope)`, `Implementation Plan (Todo List)`, and `Verify & Review Plan`.
   - Update `STATUS.md` and stop at `Implementation Approval`.
3. **Implementation**:
   - Upon receiving explicit implementation approval (e.g., `start-implementation`), begin writing code.
   - Restrict actions to the task card's boundaries; do not expand scope.
4. **Verify & Review**:
   - After coding, run local verifications.
   - Document a review report at the bottom of the task card: listing files changed, verify method, and results.
   - Update `STATUS.md` and stop at `Sync Review`.
5. **Sync Milestone**:
   - Upon receiving explicit user sync approval, update `BUILD_PLAN.md` (if applicable) and close the task card.

---

## Gates

- `Brainstorm Review`: Stop after initial brainstorm is completed. Wait for task card creation approval.
- `Implementation Approval`: Stop after the task card is ready and before writing code. Wait for coding approval.
- `Sync Review`: Stop after implementation and local verification are done. Wait for final sync and task completion approval.

> [!WARNING]
> - User clarifications or supplementary info **do not** equal gate approval.
> - `create-task` only approves task card creation. `start-implementation` only approves code implementation. Final sync approval is required to pass `Sync Review`.
> - Treat `proceed` as ambiguous. Always ask whether the user intends to `create-task` or `start-implementation`.

---

## Hard Rules

- **Do not code without a task card for standard development**.
- **Do not deliver without Verify and Review**.
- **Exception for Minor Fixes**: Minor fixes bypass dedicated cards and gates, directly updating the codebase.
- **Adaptive Docs**: Maintain `BUILD_PLAN.md` only when milestones are needed. It is a living document, updated dynamically as project requirements evolve.

---

## Status Output

Whenever asked "where are we now", report exactly:
1. **Current Phase** — Current Phase
2. **Current Task** — Current Task (file path)
3. **Current Gate** — Current Gate
4. **Allowed Now** — Allowed Now
5. **Blocking Issue** — Blocking Issue (or None)
6. **Next Action** — Next Action
