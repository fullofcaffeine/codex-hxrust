#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${ROOT}"
RUNBOOK="${REPO_ROOT}/reference/operator-runbook.v1.json"

jq -e '
  .schema == "codex-hxrust.operator-runbook.v1"
  and .bead == "HXCX-6.4"
  and .decisionRecordRequiredBeforeDefaultChange == true
  and .productionDefaultChanged == false
  and .currentProductionDefault == "disabled"
  and .currentSupportedRunMode == "local_experiment_only"
' "$RUNBOOK" >/dev/null

jq -e '
  (.distribution.artifactShape | length) >= 4
  and ([.distribution.artifactShape[].id] | sort) == [
    "generated_rust",
    "haxe_rust_compiler",
    "pins_and_decision_inputs",
    "source_and_fixtures"
  ]
  and (.distribution.artifactShape[] | select(.id == "generated_rust").distributionStatus == "build_output_not_committed")
  and (.distribution.artifactShape[] | select(.id == "haxe_rust_compiler").distributionStatus == "external_checkout_not_bundled")
' "$RUNBOOK" >/dev/null

jq -e '
  (.run.localSmokeCommands | length) >= 4
  and (.run.cafeteraIntegrationStatus == "not_enabled_by_default")
  and (.run.defaultEnablementRule | test("Do not route Cafetera workflows"))
' "$RUNBOOK" >/dev/null

jq -e '
  (.disable.currentPath | length) >= 3
  and (.disable.reservedFutureControls[] | select(.name == "CAF_CODEX_HXRUST_MODE" and .disabledValue == "disabled"))
' "$RUNBOOK" >/dev/null

jq -e '
  (.rollback.currentExperimentCommands[] | select(. == "git revert <codexhx-integration-commit>"))
  and (.rollback.currentExperimentCommands[] | select(. == "bd sync"))
  and (.rollback.generatedOutputCleanup | length) >= 2
  and (.rollback.pinRollback[] | select(. == "scripts/audit-haxe-rust.sh"))
  and (.rollback.statePolicy | test("Do not migrate or delete production state"))
' "$RUNBOOK" >/dev/null

jq -e '
  ([.diagnostics.operatorChecks[].id] | sort) == [
    "diagnostics_redaction",
    "doctor",
    "friction_comparison",
    "migration_modes"
  ]
  and (.diagnostics.failureHandoff | length) >= 3
' "$RUNBOOK" >/dev/null

echo "Operator runbook policy passed."
