# Sandbox Permission Gate

**Date:** 2026-06-10
**Bead:** `HXCX-4.3` / `codex-hxrust-hpu.3`

## Boundary

`codexhx.tools.sandbox.SandboxPermissionGate` is a fail-closed policy gate, not an OS sandbox implementation.

The first supported platform is `fixture-posix`, which exists only so policy decisions can be fixture-tested through Haxe and haxe.rust. Any other platform, including real platform names such as `linux` or `macos`, returns `unsupported_sandbox_platform` until a native/metal enforcement wrapper exists.

## Decisions

The gate allows only:

- `read` under `read-only` or `workspace-write`
- `workspace-write` under `workspace-write`

The gate denies:

- unsupported platforms
- invalid modes and operations
- unsafe paths, including absolute paths and `..`
- `danger-full-access`
- `external-sandbox` until enforcement is verified by a native wrapper
- `exec`, which must pass `ProcessExecRunner` approval instead
- `network`
- any bypass request

The decision JSON includes `enforced: false` for every row in this slice. That is deliberate: HXCX-4.3 proves the Codex-facing policy boundary and fail-closed shape before claiming host sandbox enforcement.

## Security Review Notes

- There is no allow-bypass output state.
- `danger-full-access` is not treated as an allow mode.
- Unsupported real platforms fail closed.
- Process execution remains delegated to the HXCX-4.2 exact-approval wrapper.
- Network access remains denied.
- This gate should not be used as a production sandbox until a native enforcement bridge sets `enforced: true` with its own tests.

## Gate

Run from `.`:

```bash
harness/check-sandbox-gate.sh
```

The gate runs:

- Haxe interpreter harness
- haxe.rust generation through `hxml/sandbox-gate.hxml`
- generated `cargo check --locked`
- generated `cargo test --locked`
- generated binary execution
- fixture comparison with `fixtures/hxrust/sandbox-gate-output.v1.jsonl`
