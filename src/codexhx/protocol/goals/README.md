# Goals Protocol

This package owns the minimal mainstream Codex goal DTO subset for HXCX-5.3.

`ThreadGoal` follows the app-server/core protocol field names:

- `threadId`
- `objective`
- `status`
- `tokenBudget`
- `tokensUsed`
- `timeUsedSeconds`
- `createdAt`
- `updatedAt`

Supported statuses are `active`, `paused`, `blocked`, `usageLimited`, `budgetLimited`, and `complete`.

The app-server DTO renders `tokenBudget: null` when no budget is present. Tool output follows the core `ThreadGoal` serde shape and omits `tokenBudget` when absent.
