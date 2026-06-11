# Goal Tools

`GoalToolHandler` is the HXCX-5.3 model-facing goal tool subset.

Implemented tools:

- `get_goal`
- `create_goal`
- `update_goal`

The handler mirrors mainstream Codex's model contract for the first slice:

- `create_goal` trims and validates `objective`.
- `create_goal` accepts optional positive `token_budget`.
- `create_goal` fails while an unfinished goal already exists.
- `update_goal` only accepts `complete` or `blocked`.
- `pause`, `resume`, `usageLimited`, and `budgetLimited` are rejected from `update_goal` because those are user/system-controlled transitions upstream.

The handler returns structured JSON with `goal`, `remainingTokens`, and `completionBudgetReport`.
