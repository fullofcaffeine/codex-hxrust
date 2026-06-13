#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${ROOT}"
PIN_FILE="${REPO_ROOT}/reference/upstream-codex.pin.json"
GOLDEN="${REPO_ROOT}/reference/app-protocol-schema-fingerprints.v1.json"
REPORT_DIR="${ROOT}/generated/reports"
ACTUAL="${REPORT_DIR}/app-protocol-schema-fingerprints.actual.v1.json"
DIFF_REPORT="${REPORT_DIR}/app-protocol-schema-diff.v1.json"

mkdir -p "$REPORT_DIR"

upstream_path="$(jq -r '.localPath' "$PIN_FILE")"
upstream_commit="$(jq -r '.commit' "$PIN_FILE")"
schema_root="${REPO_ROOT}/${upstream_path}/codex-rs/app-server-protocol/schema/json"

if [[ ! -d "$schema_root" ]]; then
  echo "Upstream app-server schema root is missing: ${schema_root}" >&2
  exit 1
fi

selected_schemas=(
  "ThreadStartParams:v2/ThreadStartParams.json"
  "ThreadStartResponse:v2/ThreadStartResponse.json"
  "TurnStartParams:v2/TurnStartParams.json"
  "TurnStartResponse:v2/TurnStartResponse.json"
  "TurnSteerParams:v2/TurnSteerParams.json"
  "TurnSteerResponse:v2/TurnSteerResponse.json"
  "TurnInterruptParams:v2/TurnInterruptParams.json"
  "TurnInterruptResponse:v2/TurnInterruptResponse.json"
  "ReviewStartParams:v2/ReviewStartParams.json"
  "ReviewStartResponse:v2/ReviewStartResponse.json"
  "ThreadReadParams:v2/ThreadReadParams.json"
  "ThreadReadResponse:v2/ThreadReadResponse.json"
  "ThreadResumeParams:v2/ThreadResumeParams.json"
  "ThreadResumeResponse:v2/ThreadResumeResponse.json"
  "ThreadForkParams:v2/ThreadForkParams.json"
  "ThreadForkResponse:v2/ThreadForkResponse.json"
  "ThreadArchiveParams:v2/ThreadArchiveParams.json"
  "ThreadArchiveResponse:v2/ThreadArchiveResponse.json"
  "ThreadUnarchiveParams:v2/ThreadUnarchiveParams.json"
  "ThreadUnarchiveResponse:v2/ThreadUnarchiveResponse.json"
  "ThreadUnsubscribeParams:v2/ThreadUnsubscribeParams.json"
  "ThreadUnsubscribeResponse:v2/ThreadUnsubscribeResponse.json"
  "ThreadSetNameParams:v2/ThreadSetNameParams.json"
  "ThreadSetNameResponse:v2/ThreadSetNameResponse.json"
  "ThreadGoalSetParams:v2/ThreadGoalSetParams.json"
  "ThreadGoalSetResponse:v2/ThreadGoalSetResponse.json"
  "ThreadGoalGetParams:v2/ThreadGoalGetParams.json"
  "ThreadGoalGetResponse:v2/ThreadGoalGetResponse.json"
  "ThreadGoalClearParams:v2/ThreadGoalClearParams.json"
  "ThreadGoalClearResponse:v2/ThreadGoalClearResponse.json"
  "ThreadMetadataUpdateParams:v2/ThreadMetadataUpdateParams.json"
  "ThreadMetadataUpdateResponse:v2/ThreadMetadataUpdateResponse.json"
  "ThreadCompactStartParams:v2/ThreadCompactStartParams.json"
  "ThreadCompactStartResponse:v2/ThreadCompactStartResponse.json"
  "ThreadShellCommandParams:v2/ThreadShellCommandParams.json"
  "ThreadShellCommandResponse:v2/ThreadShellCommandResponse.json"
  "ThreadApproveGuardianDeniedActionParams:v2/ThreadApproveGuardianDeniedActionParams.json"
  "ThreadApproveGuardianDeniedActionResponse:v2/ThreadApproveGuardianDeniedActionResponse.json"
  "ThreadRollbackParams:v2/ThreadRollbackParams.json"
  "ThreadRollbackResponse:v2/ThreadRollbackResponse.json"
  "ThreadInjectItemsParams:v2/ThreadInjectItemsParams.json"
  "ThreadInjectItemsResponse:v2/ThreadInjectItemsResponse.json"
  "ThreadListParams:v2/ThreadListParams.json"
  "ThreadListResponse:v2/ThreadListResponse.json"
  "ThreadLoadedListParams:v2/ThreadLoadedListParams.json"
  "ThreadLoadedListResponse:v2/ThreadLoadedListResponse.json"
  "WindowsSandboxSetupStartParams:v2/WindowsSandboxSetupStartParams.json"
  "WindowsSandboxSetupStartResponse:v2/WindowsSandboxSetupStartResponse.json"
  "WindowsSandboxReadinessResponse:v2/WindowsSandboxReadinessResponse.json"
  "LoginAccountParams:v2/LoginAccountParams.json"
  "LoginAccountResponse:v2/LoginAccountResponse.json"
  "CancelLoginAccountParams:v2/CancelLoginAccountParams.json"
  "CancelLoginAccountResponse:v2/CancelLoginAccountResponse.json"
  "LogoutAccountResponse:v2/LogoutAccountResponse.json"
  "GetAccountParams:v2/GetAccountParams.json"
  "GetAccountResponse:v2/GetAccountResponse.json"
  "GetAccountRateLimitsResponse:v2/GetAccountRateLimitsResponse.json"
  "GetAccountTokenUsageResponse:v2/GetAccountTokenUsageResponse.json"
  "SendAddCreditsNudgeEmailParams:v2/SendAddCreditsNudgeEmailParams.json"
  "SendAddCreditsNudgeEmailResponse:v2/SendAddCreditsNudgeEmailResponse.json"
  "FeedbackUploadParams:v2/FeedbackUploadParams.json"
  "FeedbackUploadResponse:v2/FeedbackUploadResponse.json"
  "CommandExecParams:v2/CommandExecParams.json"
  "CommandExecResponse:v2/CommandExecResponse.json"
  "CommandExecWriteParams:v2/CommandExecWriteParams.json"
  "CommandExecWriteResponse:v2/CommandExecWriteResponse.json"
  "CommandExecTerminateParams:v2/CommandExecTerminateParams.json"
  "CommandExecTerminateResponse:v2/CommandExecTerminateResponse.json"
  "CommandExecResizeParams:v2/CommandExecResizeParams.json"
  "CommandExecResizeResponse:v2/CommandExecResizeResponse.json"
  "ConfigReadParams:v2/ConfigReadParams.json"
  "ConfigReadResponse:v2/ConfigReadResponse.json"
  "ConfigValueWriteParams:v2/ConfigValueWriteParams.json"
  "ConfigBatchWriteParams:v2/ConfigBatchWriteParams.json"
  "ConfigWriteResponse:v2/ConfigWriteResponse.json"
  "ConfigRequirementsReadResponse:v2/ConfigRequirementsReadResponse.json"
  "ExternalAgentConfigDetectParams:v2/ExternalAgentConfigDetectParams.json"
  "ExternalAgentConfigDetectResponse:v2/ExternalAgentConfigDetectResponse.json"
  "ExternalAgentConfigImportParams:v2/ExternalAgentConfigImportParams.json"
  "ExternalAgentConfigImportResponse:v2/ExternalAgentConfigImportResponse.json"
  "CommandExecutionRequestApprovalParams:CommandExecutionRequestApprovalParams.json"
  "CommandExecutionRequestApprovalResponse:CommandExecutionRequestApprovalResponse.json"
  "FileChangeRequestApprovalParams:FileChangeRequestApprovalParams.json"
  "FileChangeRequestApprovalResponse:FileChangeRequestApprovalResponse.json"
  "PermissionsRequestApprovalParams:PermissionsRequestApprovalParams.json"
  "PermissionsRequestApprovalResponse:PermissionsRequestApprovalResponse.json"
  "ToolRequestUserInputParams:ToolRequestUserInputParams.json"
  "ToolRequestUserInputResponse:ToolRequestUserInputResponse.json"
  "McpServerElicitationRequestParams:McpServerElicitationRequestParams.json"
  "McpServerElicitationRequestResponse:McpServerElicitationRequestResponse.json"
  "DynamicToolCallParams:DynamicToolCallParams.json"
  "DynamicToolCallResponse:DynamicToolCallResponse.json"
  "ChatgptAuthTokensRefreshParams:ChatgptAuthTokensRefreshParams.json"
  "ChatgptAuthTokensRefreshResponse:ChatgptAuthTokensRefreshResponse.json"
  "AttestationGenerateParams:AttestationGenerateParams.json"
  "AttestationGenerateResponse:AttestationGenerateResponse.json"
  "ThreadStartedNotification:v2/ThreadStartedNotification.json"
  "ThreadStatusChangedNotification:v2/ThreadStatusChangedNotification.json"
  "ThreadArchivedNotification:v2/ThreadArchivedNotification.json"
  "ThreadUnarchivedNotification:v2/ThreadUnarchivedNotification.json"
  "ThreadClosedNotification:v2/ThreadClosedNotification.json"
  "ThreadNameUpdatedNotification:v2/ThreadNameUpdatedNotification.json"
  "ThreadGoalUpdatedNotification:v2/ThreadGoalUpdatedNotification.json"
  "ThreadGoalClearedNotification:v2/ThreadGoalClearedNotification.json"
  "ThreadSettingsUpdatedNotification:v2/ThreadSettingsUpdatedNotification.json"
  "ThreadTokenUsageUpdatedNotification:v2/ThreadTokenUsageUpdatedNotification.json"
  "TurnStartedNotification:v2/TurnStartedNotification.json"
  "TurnCompletedNotification:v2/TurnCompletedNotification.json"
  "TurnPlanUpdatedNotification:v2/TurnPlanUpdatedNotification.json"
  "ItemStartedNotification:v2/ItemStartedNotification.json"
  "AgentMessageDeltaNotification:v2/AgentMessageDeltaNotification.json"
  "PlanDeltaNotification:v2/PlanDeltaNotification.json"
  "RawResponseItemCompletedNotification:v2/RawResponseItemCompletedNotification.json"
  "CommandExecOutputDeltaNotification:v2/CommandExecOutputDeltaNotification.json"
  "ProcessOutputDeltaNotification:v2/ProcessOutputDeltaNotification.json"
  "ProcessExitedNotification:v2/ProcessExitedNotification.json"
  "CommandExecutionOutputDeltaNotification:v2/CommandExecutionOutputDeltaNotification.json"
  "TerminalInteractionNotification:v2/TerminalInteractionNotification.json"
  "FileChangeOutputDeltaNotification:v2/FileChangeOutputDeltaNotification.json"
  "FileChangePatchUpdatedNotification:v2/FileChangePatchUpdatedNotification.json"
  "ServerRequestResolvedNotification:v2/ServerRequestResolvedNotification.json"
  "McpToolCallProgressNotification:v2/McpToolCallProgressNotification.json"
  "McpServerOauthLoginCompletedNotification:v2/McpServerOauthLoginCompletedNotification.json"
  "McpServerStatusUpdatedNotification:v2/McpServerStatusUpdatedNotification.json"
  "AccountUpdatedNotification:v2/AccountUpdatedNotification.json"
  "AccountLoginCompletedNotification:v2/AccountLoginCompletedNotification.json"
  "AccountRateLimitsUpdatedNotification:v2/AccountRateLimitsUpdatedNotification.json"
  "AppListUpdatedNotification:v2/AppListUpdatedNotification.json"
  "RemoteControlStatusChangedNotification:v2/RemoteControlStatusChangedNotification.json"
  "ExternalAgentConfigImportCompletedNotification:v2/ExternalAgentConfigImportCompletedNotification.json"
  "FsChangedNotification:v2/FsChangedNotification.json"
  "ReasoningSummaryTextDeltaNotification:v2/ReasoningSummaryTextDeltaNotification.json"
  "ReasoningSummaryPartAddedNotification:v2/ReasoningSummaryPartAddedNotification.json"
  "ReasoningTextDeltaNotification:v2/ReasoningTextDeltaNotification.json"
  "ContextCompactedNotification:v2/ContextCompactedNotification.json"
  "ModelReroutedNotification:v2/ModelReroutedNotification.json"
  "ModelVerificationNotification:v2/ModelVerificationNotification.json"
  "TurnModerationMetadataNotification:v2/TurnModerationMetadataNotification.json"
  "WarningNotification:v2/WarningNotification.json"
  "GuardianWarningNotification:v2/GuardianWarningNotification.json"
  "DeprecationNoticeNotification:v2/DeprecationNoticeNotification.json"
  "ConfigWarningNotification:v2/ConfigWarningNotification.json"
  "FuzzyFileSearchSessionUpdatedNotification:FuzzyFileSearchSessionUpdatedNotification.json"
  "FuzzyFileSearchSessionCompletedNotification:FuzzyFileSearchSessionCompletedNotification.json"
  "ThreadRealtimeStartedNotification:v2/ThreadRealtimeStartedNotification.json"
  "ThreadRealtimeItemAddedNotification:v2/ThreadRealtimeItemAddedNotification.json"
  "ThreadRealtimeTranscriptDeltaNotification:v2/ThreadRealtimeTranscriptDeltaNotification.json"
  "ThreadRealtimeTranscriptDoneNotification:v2/ThreadRealtimeTranscriptDoneNotification.json"
  "ThreadRealtimeOutputAudioDeltaNotification:v2/ThreadRealtimeOutputAudioDeltaNotification.json"
  "ThreadRealtimeSdpNotification:v2/ThreadRealtimeSdpNotification.json"
  "ThreadRealtimeErrorNotification:v2/ThreadRealtimeErrorNotification.json"
  "ThreadRealtimeClosedNotification:v2/ThreadRealtimeClosedNotification.json"
  "WindowsWorldWritableWarningNotification:v2/WindowsWorldWritableWarningNotification.json"
  "WindowsSandboxSetupCompletedNotification:v2/WindowsSandboxSetupCompletedNotification.json"
  "ItemCompletedNotification:v2/ItemCompletedNotification.json"
  "ErrorNotification:v2/ErrorNotification.json"
  "JSONRPCError:JSONRPCError.json"
)

entries_dir="$(mktemp -d)"
trap 'rm -rf "$entries_dir"' EXIT

for selected in "${selected_schemas[@]}"; do
  id="${selected%%:*}"
  rel="${selected#*:}"
  file="${schema_root}/${rel}"
  if [[ ! -f "$file" ]]; then
    echo "Selected schema is missing: ${rel}" >&2
    exit 1
  fi

  canonical="$(jq -S -c . "$file")"
  hash="$(printf '%s' "$canonical" | shasum -a 256 | awk '{print $1}')"
  fields="$(jq -S -c '
    ([(.required // [])[] | "required:" + .]
    + [(.properties // {}) | keys[] | "property:" + .]
    + [(.definitions // {}) | keys[] | "definition:" + .])
    | sort
  ' "$file")"

  jq -n \
    --arg id "$id" \
    --arg sourcePath "$rel" \
    --arg sha256 "$hash" \
    --argjson fields "$fields" \
    '{id: $id, sourcePath: $sourcePath, sha256: $sha256, fields: $fields}' \
    > "${entries_dir}/${id}.json"
done

entries_json="${entries_dir}/entries.json"
jq -s 'sort_by(.id)' "${entries_dir}"/*.json > "$entries_json"

fingerprint_payload="$(jq -S -c '{schemas: [.[] | {id, sourcePath, sha256, fields}]}' "$entries_json")"
fingerprint="$(printf '%s' "$fingerprint_payload" | shasum -a 256 | awk '{print $1}')"

jq -n \
  --arg schema "codex-hxrust.app-protocol-schema-fingerprints.v1" \
  --arg owner "upstream-codex" \
  --arg pinFile "reference/upstream-codex.pin.json" \
  --arg sourceRoot "../codex/codex-rs/app-server-protocol/schema/json" \
  --arg sourceCommit "$upstream_commit" \
  --arg fingerprint "sha256:${fingerprint}" \
  --slurpfile schemas "$entries_json" \
  '{
    schema: $schema,
    source: {
      owner: $owner,
      pinFile: $pinFile,
      sourceRoot: $sourceRoot,
      sourceCommit: $sourceCommit
    },
    fingerprint: $fingerprint,
    schemas: $schemas[0],
    gaps: [
      {
        id: "cafex-schema-diff",
        status: "deferred_to_M5",
        reason: "Cafex/Cafetera fixtures are adapter oracles and are intentionally inactive until the upstream-shaped core exists."
      },
      {
        id: "process-request-schemas",
        status: "tracked_from_rust_source",
        reason: "Upstream exports process/spawn, process/writeStdin, process/kill, and process/resizePty request DTOs from Rust source and experimental protocol mappings, but does not currently emit standalone v2/Process*Params.json or v2/Process*Response.json request/response schema files for these methods. The local subset validates the Rust DTO contracts and keeps process output/exited notification schemas fingerprinted."
      },
      {
        id: "thread-state-rust-source-schemas",
        status: "tracked_from_rust_source",
        reason: "Upstream exports thread/increment_elicitation, thread/decrement_elicitation, thread/settings/update, thread/memoryMode/set, memory/reset, and thread/backgroundTerminals/clean from Rust DTO/protocol source, but the pinned schema export does not currently emit standalone v2 JSON schema files for those experimental request/response surfaces. The local subset validates the Rust DTO contracts and keeps paired emitted thread state notification schemas fingerprinted."
      },
      {
        id: "thread-turn-pagination-schemas",
        status: "tracked_from_rust_source",
        reason: "Upstream exports thread/turns/list and thread/turns/items/list from Rust DTO/protocol source, but the pinned schema export does not currently emit standalone v2 JSON schema files for those experimental request/response surfaces. The local subset validates the Rust DTO contracts using shared Turn and ThreadItem shapes."
      }
    ]
  }' > "$ACTUAL"

if [[ "${ACCEPT_SCHEMA_FINGERPRINT:-0}" == "1" ]]; then
  cp "$ACTUAL" "$GOLDEN"
  echo "Accepted schema fingerprint golden: ${GOLDEN}"
fi

if [[ ! -f "$GOLDEN" ]]; then
  echo "Missing golden schema fingerprint: ${GOLDEN}" >&2
  echo "Run with ACCEPT_SCHEMA_FINGERPRINT=1 to create it after review." >&2
  exit 1
fi

jq -n \
  --slurpfile expected "$GOLDEN" \
  --slurpfile actual "$ACTUAL" '
  def by_id($items):
    reduce $items[] as $item ({}; .[$item.id] = $item);
  def status_for($expected; $actual):
    if $expected == null then "extra_schema"
    elif $actual == null then "missing_schema"
    elif $expected.sha256 != $actual.sha256 then "changed_schema"
    elif (($expected.fields // []) - ($actual.fields // []) | length) > 0 then "field_drift"
    elif (($actual.fields // []) - ($expected.fields // []) | length) > 0 then "field_drift"
    else "match"
    end;
  ($expected[0].schemas // []) as $expectedSchemas
  | ($actual[0].schemas // []) as $actualSchemas
  | (by_id($expectedSchemas)) as $expectedById
  | (by_id($actualSchemas)) as $actualById
  | (($expectedById | keys) + ($actualById | keys) | unique | sort) as $ids
  | {
      schema: "codex-hxrust.app-protocol-schema-diff.v1",
      status: (if $expected[0].fingerprint == $actual[0].fingerprint then "match" else "mismatch" end),
      expectedFingerprint: $expected[0].fingerprint,
      actualFingerprint: $actual[0].fingerprint,
      schemas: [
        $ids[] as $id
        | ($expectedById[$id] // null) as $expectedSchema
        | ($actualById[$id] // null) as $actualSchema
        | {
            id: $id,
            status: status_for($expectedSchema; $actualSchema),
            missingFields: (($expectedSchema.fields // []) - ($actualSchema.fields // [])),
            extraFields: (($actualSchema.fields // []) - ($expectedSchema.fields // [])),
            changedFields: (if ($expectedSchema != null and $actualSchema != null and $expectedSchema.sha256 != $actualSchema.sha256 and (($expectedSchema.fields // []) - ($actualSchema.fields // []) | length) == 0 and (($actualSchema.fields // []) - ($expectedSchema.fields // []) | length) == 0) then ["schema-content"] else [] end)
          }
      ],
      gaps: ($actual[0].gaps // [])
    }
  ' > "$DIFF_REPORT"

if ! cmp -s "$GOLDEN" "$ACTUAL"; then
  echo "Schema fingerprint mismatch." >&2
  jq '.status, .expectedFingerprint, .actualFingerprint, [.schemas[] | select(.status != "match")]' "$DIFF_REPORT" >&2
  echo "Actual: ${ACTUAL}" >&2
  echo "Diff: ${DIFF_REPORT}" >&2
  echo "Review upstream schema drift, then rerun with ACCEPT_SCHEMA_FINGERPRINT=1 if accepted." >&2
  exit 1
fi

echo "Schema fingerprint gate passed: ${DIFF_REPORT}"
