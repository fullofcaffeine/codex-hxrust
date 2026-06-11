# Tools

Tool-facing helpers for the pure-Haxe Codex experiment live here.

Current slices:

- `goals/GoalToolHandler` implements the HXCX-5.3 `get_goal`, `create_goal`, and `update_goal` model-facing subset.
- `patch/ApplyPatchDryRun` implements the HXCX-4.1 apply-patch dry-run compatibility wrapper with mutation disabled by default.
- `process/ProcessExecRunner` implements the HXCX-4.2 exact-approval process execution wrapper with denied-by-default behavior.
- `sandbox/SandboxPermissionGate` implements the HXCX-4.3 fail-closed sandbox policy gate without claiming host enforcement.

Tool DTOs, policy, diagnostics, and dry-run wrappers go here.

Execution must be denied by default until the G4 gate proves safe wrapper behavior.
