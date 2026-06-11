# Cafex Hxrust Friction Comparison

**Date:** 2026-06-10
**Bead:** `HXCX-6.1` / `codex-hxrust-ryo.1`
**Decision feed:** `HXCX-6.3`

## Purpose

This document estimates whether the hxrust path reduces maintenance compared with the Cafex fork for the slices we can actually support today.

Machine-readable fixture:

`fixtures/cafex/cafex-hxrust-friction-comparison.v1.json`

Validation gate:

```bash
harness/check-friction-comparison.sh
```

## Evidence Sources

| Source | Use |
| --- | --- |
| `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/cafex-fork-seam-ledger.v1.json` | Source Cafex fork seam families and patch-class intent. |
| `../fullofcaffeine/tools/cafetera/modules/codex/runtime/patches/0001-cafex-runtime-0.135.patch` | Current consolidated Cafex runtime patch stack. |
| `fixtures/cafex/cafex-hxrust-seam-ledger.v1.json` | hxrust supported/unsupported mapping against Cafex seams. |
| `fixtures/cafex/cafetera-contract-subset-report.v1.json` | Contract subset result and explicit non-replacement boundary. |

## Cafex Patch Surface

The current Cafex runtime patch stack is one consolidated patch file. Counting the touched paths inside that patch gives the useful maintenance signal:

| Area | Unique touched paths | Rebase-friction signal |
| --- | ---: | --- |
| `core` | 15 | Runtime capability, session/state behavior, tools, registry, and native conformance tests. |
| `tui` | 25 | Live composer, input queue, plan checkpoint, slash command, status, and UI tests. |
| `cli` | 1 | Entrypoint integration. |
| Other crates / lockfile | 4 | Cargo lock plus adjacent runtime-composition crates. |
| **Total** | **45** | **One patch file, but broad native surface area.** |

Patch delta snapshot:

| Metric | Count |
| --- | ---: |
| Runtime patch files | 1 |
| Added lines | 6157 |
| Deleted lines | 144 |
| Total delta lines | 6301 |

Source seam-family classification from the Cafex fork ledger:

| Patch class | Seam families | Meaning |
| --- | ---: | --- |
| `fork_only_caf_adapter` | 6 | Caf-specific runtime adapter behavior that must be replayed or replaced. |
| `upstreamable_seam` | 1 | Governance/update workflow evidence, not runtime behavior. |
| `temporary_sync_shim` | 0 | No current temporary shim class in the source seam ledger. |

The highest-friction areas are the live TUI queue/plan flow and native runtime/session bridge paths because they sit in behavior that upstream Codex can reasonably change while evolving the TUI and runtime.

## Hxrust Burden

The hxrust path has a smaller native-Codex rebase surface for supported rows, but it is not free. Current burden counted by the gate:

| Metric | Count | Meaning |
| --- | ---: | --- |
| Seam ledger rows | 15 | Replacement review rows tracked locally. |
| Supported rows | 10 | Fixture-backed hxrust behavior exists. |
| Unsupported rows | 4 | Known gaps that still block broad replacement. |
| Review-only rows | 1 | Governance evidence, not runtime behavior. |
| Haxe files in compared wrapper/tool/goal surface | 33 | Implementation surface we maintain instead of replaying those slices as Rust fork patches. |
| Cafex fixture files | 32 | Adapter fixture burden in `fixtures/cafex`. |
| Experiment gates | 29 | Current proof surface for generated Haxe/Rust behavior. |
| Generated Rust committed | 0 | Generated output remains disposable; gates must regenerate/prove behavior. |

Supported hxrust rows cover deterministic receipt writing, continuity metadata, active-lane capability advertisement, effort/wake/mode/goal/queue-reconcile bridge fixtures, invalid mode refusal, and the minimal thread-goal lifecycle. Unsupported rows still include live mode runtime mutation, restart, plan-checkpoint continuation guard, and live TUI/model runtime.

## Rebase-Friction Result

Evidence supports this limited claim:

> hxrust reduces upstream Codex rebase friction for fixture-backed supported adapter slices by moving semantics into Haxe source, fixtures, and generated-Cargo gates instead of replaying native Rust fork patches.

Evidence does not support a broad replacement claim:

- The source Cafex patch still spans 45 unique native paths, with 25 under `tui`.
- hxrust has 4 unsupported replacement rows, all in live runtime or UI-owned behavior.
- Generated Rust is not the maintenance artifact; Haxe source plus fixtures are. That shifts work, it does not erase work.
- The Cafetera contract subset already says `productionReplacement == false`.

## Decision Input

Feed `HXCX-6.3` with this recommendation:

Use hxrust for sidecar/helper and selected adapter slices first. Do not position it as a full Cafex replacement until either the 4 unsupported rows and live queue mutation are implemented generically or the replacement review explicitly decides those surfaces remain native.

Any haxe.rust limitations discovered while reducing the unsupported rows should be filed and fixed in haxe.rust as general compiler capability, not as codexhx-specific compiler behavior.
