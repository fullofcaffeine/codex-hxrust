#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"
SPIKE="${REPO_ROOT}/reference/state-backend-spike.v1.json"
G6="${REPO_ROOT}/reference/replacement-go-no-go.v1.json"

jq -e '
  .schema == "codex-hxrust.state-backend-spike.v1"
  and .bead == "HXCX-4.4"
  and .gate == "G4"
  and .decision.currentExperimentBackend == "jsonl_plain_files"
  and .decision.productionStateMigrationImplied == false
  and .decision.replacementGateRequirement == "sqlite_or_equivalent_required_for_persistent_goal_runtime_or_app_server_state_replacement"
' "$SPIKE" >/dev/null

jq -e '
  (.jsonl.ownedSurfaces | length) >= 4
  and (.jsonl.strengths | length) >= 5
  and (.jsonl.limitations | length) >= 6
  and (.jsonl.limitations | any(test("multi-writer")))
  and (.jsonl.limitations | any(test("SQLite")))
  and (.jsonl.limitations | any(test("migration")))
' "$SPIKE" >/dev/null

jq -e '
  (.sqliteSqlx.requiredFor | length) >= 6
  and .sqliteSqlx.wrapperCost.estimate == "medium_high"
  and .sqliteSqlx.wrapperCost.minimumFollowUpBeads >= 2
  and (.sqliteSqlx.wrapperCost.tasklets | length) >= 8
  and (.sqliteSqlx.wrapperCost.tasklets | any(test("license")))
  and (.sqliteSqlx.wrapperCost.tasklets | any(test("schema")))
  and (.sqliteSqlx.wrapperCost.tasklets | any(test("locked, missing, corrupt")))
' "$SPIKE" >/dev/null

jq -e '
  .replacementGate.helperOnly == "jsonl_plain_files_sufficient"
  and .replacementGate.sidecarHeadless == "jsonl_plain_files_sufficient_for_fixture_backed_credential_free_state"
  and .replacementGate.selectedAdapterSlice == "jsonl_sufficient_unless_slice_claims_persistent_goal_runtime_or_app_server_state_parity"
  and .replacementGate.broadReplacement == "sqlite_or_equivalent_persistence_parity_required_before_review"
' "$SPIKE" >/dev/null

jq -e '
  .noProductionMigration.implied == false
  and (.noProductionMigration.rules | length) >= 4
  and (.noProductionMigration.rules | any(test("do not rewrite")))
  and (.noProductionMigration.rules | any(test("rollback drill")))
' "$SPIKE" >/dev/null

jq -e --slurpfile g "$G6" '
  $g[0].decision.selectedMode == "selected_adapter_slice"
  and $g[0].decision.productionDefaultChanged == false
  and ($g[0].stateBackendDecision.source == "reference/state-backend-spike.v1.json")
  and ($g[0].stateBackendDecision.broadReplacementRequirement | test("SQLite"))
' "$SPIKE" >/dev/null

while IFS= read -r path; do
  [[ -f "$REPO_ROOT/$path" ]]
done < <(jq -r '.evidence[]' "$SPIKE")

echo "State backend spike passed."
