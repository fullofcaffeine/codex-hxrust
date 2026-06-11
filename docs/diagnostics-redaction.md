# Diagnostics And Redaction

**Date:** 2026-06-10
**Bead:** `HXCX-4.6` / `codex-hxrust-hpu.6`

## Boundary

Diagnostics are useful only if they do not leak secrets. This slice adds:

- doctor JSON build feature flags
- doctor JSON runtime feature flags
- typed diagnostic log events
- configured secret-field redaction
- failure reports that include fixture IDs

`DiagnosticRedactor` redacts configured field names and common secret-like names such as `apiKey`, `api_key`, `token`, `authorization`, and `secrets`.

## Doctor Flags

Doctor JSON now includes:

- `build.profile`
- `build.features`
- `runtime.featureFlags`

The current runtime feature flags are:

- `headless-jsonl-adapter`
- `apply-patch-dry-run`
- `process-exec-approval`
- `sandbox-permission-gate`
- `diagnostics-redaction`

## Failure Reports

`DiagnosticFailureReport` carries `fixtureIds` so failing gates can name the fixture evidence that produced the failure without embedding raw secret-bearing input.

## Gates

Run from `.`:

```bash
harness/check-doctor-json.sh
harness/check-diagnostics.sh
```

`check-diagnostics.sh` validates:

- redacted log output
- raw secret absence
- fixture ID propagation
- haxe.rust generated Cargo check/test/run
- fixture comparison with `fixtures/hxrust/diagnostics-output.v1.jsonl`
