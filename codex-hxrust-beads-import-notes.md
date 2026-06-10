# Beads import notes for `codex-hxrust`

This document accompanies `codex-hxrust-beads-backlog.seed.jsonl`.

The JSONL file uses stable planning keys such as `HXCX-2.4`. Beads will generate its own issue IDs when imported, so the stable keys should be copied into the Beads title, description, or labels during import.

Suggested import flow:

```bash
bd init

# Create epics first. Example:
bd create "HXCX-0 Inventory, oracle, and parity matrix" --type epic --priority 1

# Create children with --parent once the generated parent Beads ID is known.
bd create "HXCX-0.1 Baseline upstream, Cafex, and haxe.rust topology" --type task --priority 1 --parent <BEADS_ID_FOR_HXCX_0>

# Add dependencies after all issues exist.
bd dep add <BEADS_ID_FOR_HXCX_0_2> <BEADS_ID_FOR_HXCX_0_1>

# Let Beads surface unblocked work.
bd ready
```

Recommended labels:

- `codex-hxrust`
- `hxrust`
- `codex`
- `cafex`
- `cafetera`
- `parity`
- `protocol`
- `runtime`
- `security`
- `decision`

Import policy:

1. Keep epics coarse.
2. Keep tasks small enough to close with one concrete artifact or test result.
3. Do not close a task until every acceptance criterion is satisfied or explicitly moved to a follow-up task.
4. Add dependencies aggressively; this experiment should use `bd ready` as a safety rail.
5. Preserve stable keys in issue titles so later conversion to Caf Brew can map history cleanly.
