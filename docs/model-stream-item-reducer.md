# Stream Item Reducer And Assistant Output Routing

**Bead:** HXCX-4.48 / `codex-hxrust-19q`; HXCX-4.50 / `codex-hxrust-9rq`; HXCX-4.51 / `codex-hxrust-xh4`; HXCX-4.52 / `codex-hxrust-7md`; HXCX-4.53 / `codex-hxrust-8p1`; HXCX-4.54 / `codex-hxrust-485`; HXCX-4.55 / `codex-hxrust-2og`; HXCX-4.56 / `codex-hxrust-4bi`; HXCX-4.57 / `codex-hxrust-aiz`; HXCX-4.58 / `codex-hxrust-3ll`; HXCX-4.59 / `codex-hxrust-fvw`; HXCX-4.60 / `codex-hxrust-euw`
**Scope:** raw upstream Codex first; no live network, no real credentials, no live async ownership, no Cafex/Cafetera behavior.

## Upstream References

Read-only upstream reference: `../codex`.

- `../codex/codex-rs/core/src/stream_events_utils.rs:405` handles completed output items.
- `../codex/codex-rs/core/src/stream_events_utils.rs:413` classifies model-emitted tool calls through `ToolRouter`.
- `../codex/codex-rs/core/src/stream_events_utils.rs:427` accepts current-turn mailbox delivery, records the tool call, and queues the tool future.
- `../codex/codex-rs/core/src/stream_events_utils.rs:448` sets `needs_follow_up` when a tool future is queued.
- `../codex/codex-rs/core/src/stream_events_utils.rs:445` converts non-tool messages/reasoning into completed turn items.
- `../codex/codex-rs/core/src/stream_events_utils.rs:517` handles non-tool response items.
- `../codex/codex-rs/core/src/stream_events_utils.rs:555` finalizes assistant messages and strips hidden assistant markup.
- `../codex/codex-rs/core/src/session/turn.rs:1951` handles `OutputItemAdded` active-item setup and streamed item starts.
- `../codex/codex-rs/core/src/session/turn.rs:2062` handles terminal `Completed` outcomes and follow-up decisions.
- `../codex/codex-rs/core/src/session/turn.rs:2086` routes assistant output text deltas.
- `../codex/codex-rs/core/src/session/turn.rs:2118` routes `ToolCallInputDelta` by active custom tool `call_id` and ignores mismatches.
- `../codex/codex-rs/core/src/session/turn.rs:2136` routes reasoning summary deltas.
- `../codex/codex-rs/core/src/session/turn.rs:2172` routes raw reasoning content deltas.
- `../codex/codex-rs/core/src/tools/registry.rs:150` defines the runtime-neutral `ToolArgumentDiffConsumer` contract.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch.rs:78` consumes streamed apply-patch argument diffs into protocol events.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch.rs:99` pushes deltas through the streaming patch parser.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch.rs:124` flushes pending diff updates on tool completion.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch.rs:364` invokes apply-patch argument verification before runtime execution.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch.rs:385` converts verified file changes into protocol-shaped file-change events.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch.rs:399` builds the runtime apply-patch request from verified action, file paths, and permission facts.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch.rs:430` maps `ApplyPatchRuntimeOutput` into emitter finish output and applied patch delta.
- `../codex/codex-rs/core/src/tools/context.rs:235` defines `ApplyPatchToolOutput`.
- `../codex/codex-rs/core/src/tools/context.rs:240` constructs apply-patch model-visible output text.
- `../codex/codex-rs/core/src/tools/context.rs:254` converts apply-patch output into a response item.
- `../codex/codex-rs/core/src/tools/context.rs:438` centralizes function/custom tool-output response item selection.
- `../codex/codex-rs/core/src/tools/parallel.rs:67` converts tool futures into response items.
- `../codex/codex-rs/core/src/tools/parallel.rs:186` converts tool failures into model-visible tool-output responses.
- `../codex/codex-rs/core/src/session/turn.rs:242` reads `SamplingRequestResult.needs_follow_up` after a model request.
- `../codex/codex-rs/core/src/session/turn.rs:246` enables pending-input draining after a sampling request completes.
- `../codex/codex-rs/core/src/session/turn.rs:247` collects pending input, token status, and estimated token count after sampling.
- `../codex/codex-rs/core/src/session/turn.rs:258` combines model follow-up with pending input state.
- `../codex/codex-rs/core/src/session/turn.rs:279` routes token-limit-plus-follow-up through mid-turn auto-compaction.
- `../codex/codex-rs/core/src/session/turn.rs:295` preserves model/tool continuation priority over pending input after auto-compaction.
- `../codex/codex-rs/core/src/session/turn.rs:299` ends the turn only when neither model follow-up nor pending input requires another sampling request.
- `../codex/codex-rs/core/src/session/turn.rs:1721` drains in-flight tool futures in response order.
- `../codex/codex-rs/core/src/session/turn.rs:1726` reads each completed in-flight tool response.
- `../codex/codex-rs/core/src/session/turn.rs:1729` converts `ResponseInputItem` into a conversation `ResponseItem`.
- `../codex/codex-rs/core/src/session/turn.rs:2205` starts tool-blocking timing when in-flight tools remain.
- `../codex/codex-rs/core/src/session/turn.rs:2210` drains in-flight tool responses before returning from sampling.
- `../codex/codex-rs/core/src/session/mod.rs:3216` records response-input-derived items into conversation history.
- `../codex/codex-rs/core/src/tools/events.rs:154` creates apply-patch tool event emitters for the active environment.
- `../codex/codex-rs/core/src/tools/events.rs:216` emits patch begin/end tool events with file-change payloads.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:47` defines the runtime apply-patch request.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:63` defines runtime output as exec output plus applied patch delta.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:109` marks apply-patch runtime sandbox preference as auto and enables escalation on failure.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:121` derives approval cache keys from environment id and file paths.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:134` starts the apply-patch approval flow.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:150` short-circuits approval when permissions are preapproved and this is not a retry.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:155` emits a patch approval request when retrying with a reason.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:186` checks whether the active approval policy allows sandbox approval.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:199` forwards the apply-patch-specific approval requirement.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:206` builds the apply-patch permission request payload.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:215` runs the runtime apply-patch tool.
- `../codex/codex-rs/core/src/tools/runtimes/apply_patch.rs:263` returns stdout/stderr/exit-code-shaped apply-patch output.
- `../codex/codex-rs/apply-patch/src/lib.rs:184` defines `AppliedPatchDelta`.
- `../codex/codex-rs/core/src/tools/events.rs:72` defines `TurnDiffTrackerUpdate`.
- `../codex/codex-rs/core/src/tools/events.rs:81` maps known applied patch deltas into tracker updates.
- `../codex/codex-rs/core/src/tools/events.rs:243` invalidates the tracker when successful apply-patch output has no known delta.
- `../codex/codex-rs/core/src/tools/events.rs:566` completes patch events and updates the turn diff tracker.
- `../codex/codex-rs/core/src/tools/events.rs:588` applies tracker updates and emits `TurnDiffEvent` when the visible diff changes.
- `../codex/codex-rs/core/src/turn_diff_tracker.rs:66` tracks exact applied patch deltas by environment.
- `../codex/codex-rs/core/src/turn_diff_tracker.rs:70` invalidates the turn diff tracker.
- `../codex/codex-rs/core/src/turn_diff_tracker.rs:74` renders the accumulated unified diff.
- `../codex/codex-rs/protocol/src/items.rs:157` defines `FileChangeItem`.
- `../codex/codex-rs/protocol/src/items.rs:508` converts `FileChangeItem` into legacy `PatchApplyBegin` events.
- `../codex/codex-rs/protocol/src/items.rs:520` converts `FileChangeItem` into legacy `PatchApplyEnd` events.
- `../codex/codex-rs/protocol/src/items.rs:579` preserves file-change item ids during turn item conversion.
- `../codex/codex-rs/protocol/src/protocol.rs:1298` carries `PatchApplyBegin` on `EventMsg`.
- `../codex/codex-rs/protocol/src/protocol.rs:1304` carries `PatchApplyEnd` on `EventMsg`.
- `../codex/codex-rs/protocol/src/protocol.rs:1306` carries `TurnDiff` on `EventMsg`.
- `../codex/codex-rs/protocol/src/protocol.rs:3352` defines `TurnDiffEvent`.
- `../codex/codex-rs/app-server-protocol/src/protocol/item_builders.rs:50` builds begin file-change thread items.
- `../codex/codex-rs/app-server-protocol/src/protocol/item_builders.rs:58` builds end file-change thread items.
- `../codex/codex-rs/app-server-protocol/src/protocol/item_builders.rs:279` converts patch changes into app-server file-change shapes.
- `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:458` handles patch-apply begin events in thread history projection.
- `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:467` handles patch-apply end events in thread history projection.
- `../codex/codex-rs/app-server/src/bespoke_event_handling.rs:1080` ignores legacy patch apply begin/end events for v2 clients because canonical file-change items are used.
- `../codex/codex-rs/app-server/src/bespoke_event_handling.rs:1255` projects turn-diff notifications to app-server clients.
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/item.rs:278` defines the v2 `ThreadItem::FileChange` shape.
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/item.rs:844` converts core turn items into v2 file-change items.
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/item.rs:1272` defines file-change output delta notifications.
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/item.rs:1282` defines patch-updated notifications.
- `../codex/codex-rs/tui/src/diff_render.rs:297` begins selected file-change render handling.
- `../codex/codex-rs/tui/src/diff_render.rs:423` renders selected file-change status facts.
- `../codex/codex-rs/tui/src/chatwidget/replay.rs:131` replays completed file-change items.
- `../codex/codex-rs/tui/src/app/agent_status_feed.rs:146` adds file-change status feed entries.
- `../codex/codex-rs/tui/src/app/thread_events.rs:284` looks up file-change turn items.
- `../codex/codex-rs/tui/src/app/app_server_event_targets.rs:96` routes file-change output notifications.
- `../codex/codex-rs/protocol/src/approvals.rs:374` defines `ApplyPatchApprovalRequestEvent`.
- `../codex/codex-rs/protocol/src/protocol.rs:840` defines granular sandbox approval policy behavior.
- `../codex/codex-rs/protocol/src/protocol.rs:3717` defines `ReviewDecision`.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch_tests.rs:84` covers streamed `PatchApplyUpdated` events for add-file patch input.
- `../codex/codex-rs/apply-patch/src/invocation.rs:161` verifies structured apply-patch arguments.
- `../codex/codex-rs/apply-patch/src/invocation.rs:181` maps add-file hunks to verified file changes.
- `../codex/codex-rs/apply-patch/src/invocation.rs:187` maps delete-file hunks to verified file changes.
- `../codex/codex-rs/apply-patch/src/invocation.rs:204` maps update-file hunks to verified file changes.
- `../codex/codex-rs/apply-patch/src/invocation.rs:228` returns the verified patch body.
- `../codex/codex-rs/apply-patch/src/lib.rs:118` defines `MaybeApplyPatchVerified` and `ApplyPatchFileChange`.
- `../codex/codex-rs/apply-patch/src/parser.rs:65` defines typed add/delete/update hunks and update chunks.
- `../codex/codex-rs/apply-patch/src/streaming_parser.rs:22` defines `StreamingPatchParser` state.
- `../codex/codex-rs/apply-patch/src/streaming_parser.rs:47` implements streamed delta ingestion and finish validation.
- `../codex/codex-rs/apply-patch/src/streaming_parser.rs:384` covers complete-line streaming for add/delete/update/move hunks.
- `../codex/codex-rs/apply-patch/src/streaming_parser.rs:724` covers malformed streaming patch errors.
- `../codex/codex-rs/protocol/src/protocol.rs:3315` defines `PatchApplyUpdatedEvent`.
- `../codex/codex-rs/protocol/src/protocol.rs:3301` defines `PatchApplyBeginEvent`.
- `../codex/codex-rs/protocol/src/protocol.rs:3323` defines `PatchApplyEndEvent`.
- `../codex/codex-rs/protocol/src/protocol.rs:3345` defines `PatchApplyStatus`.
- `../codex/codex-rs/protocol/src/protocol.rs:3775` defines the `FileChange` variants used by patch update events.
- `../codex/codex-rs/protocol/src/models.rs:665` defines `ResponseInputItem`.
- `../codex/codex-rs/protocol/src/models.rs:673` defines `FunctionCallOutput`.
- `../codex/codex-rs/protocol/src/models.rs:683` defines `CustomToolCallOutput`.
- `../codex/codex-rs/protocol/src/models.rs:1126` converts `ResponseInputItem` into `ResponseItem`.
- `../codex/codex-rs/protocol/src/models.rs:1386` defines `FunctionCallOutputPayload`.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch_tests.rs:69` covers post-tool-use apply-patch output text.
- `../codex/codex-rs/core/tests/suite/apply_patch_cli.rs:1187` covers `response.custom_tool_call_input.delta` apply-patch streaming.
- `../codex/codex-rs/core/tests/suite/items.rs:1088` covers reasoning summary delta item metadata.
- `../codex/codex-rs/core/tests/suite/items.rs:1138` covers raw reasoning delta behavior.
- `../codex/codex-rs/core/tests/common/responses.rs:703` defines output text delta fixtures.
- `../codex/codex-rs/core/tests/common/responses.rs:710` defines reasoning item fixtures.
- `../codex/codex-rs/core/tests/common/responses.rs:815` defines function-call output-item fixtures.
- `../codex/codex-rs/core/tests/common/responses.rs:857` defines custom-tool-call output-item fixtures.

## Local Boundary

`codexhx.runtime.model.streamitem` composes HXCX-4.43 provider admission, HXCX-4.44 catalog selection, HXCX-4.45 turn model/tool planning, HXCX-4.46 request envelopes, and HXCX-4.47 stream routes before reducing selected item events:

- `ModelStreamOutputItemKind` is a typed item kind enum abstract for assistant message, reasoning, function/custom tool call, web search, image generation, tool output, and unknown items.
- `ModelStreamItemEventKind` represents selected `ResponseEvent` item-added, item-done, output text delta, tool-call input delta, reasoning summary delta, reasoning raw-content delta, and completion events.
- `ModelStreamRuntimeEventKind` captures the runtime-facing item started/completed, assistant delta, reasoning delta, raw reasoning delta, tool-call input delta, ignored tool-call input delta, patch-style tool argument diff update, tool-call queued, stream completed, route denied, and reducer error outcomes.
- `ModelStreamActiveToolCall`, `ModelStreamToolInputDelta`, and `ModelStreamToolInputDeltaStatus` keep active custom tool-call state, accepted diffs, no-active-consumer ignores, and call-id mismatch ignores typed instead of stringly.
- `ModelToolArgumentDiffConsumerState`, `ModelToolArgumentDiffConsumerEvent`, `ModelPatchFileChange`, `ModelPatchUpdateChunk`, `ModelPatchParseError`, and their enum abstracts model the selected `ToolArgumentDiffConsumer` and `StreamingPatchParser` event surface for apply-patch-shaped custom tool input.
- `ModelPatchVerificationPolicy`, `ModelPatchVerificationRequest`, `ModelPatchVerificationOutcome`, `ModelPatchVerificationEvent`, `ModelPatchVirtualFile`, `ModelPatchApplyStatus`, and `ModelPatchVerificationEventKind` model the selected upstream apply-patch verification/tool-event boundary against fixture-only filesystem facts. They emit deterministic begin/end events and completed/failed/declined status summaries without live network, real filesystem mutation, or out-of-fixture tool execution.
- `ModelPatchApplicationPolicy`, `ModelPatchApplicationRequest`, and `ModelPatchApplicationOutcome` model the selected runtime result boundary against copied virtual workspace facts. Completed patches update the copy; failed and declined results keep before/after facts unchanged. The policy carries stdout/stderr and status while proving no live network, real filesystem mutation, or out-of-fixture tool execution occurred.
- `ModelPatchApprovalDecisionPolicy`, `ModelPatchApprovalDecisionRequest`, `ModelPatchApprovalDecisionOutcome`, `ModelPatchApprovalKey`, `ModelPatchApprovalRequirement`, `ModelPatchReviewDecision`, and `ModelPatchSandboxAttemptKind` model the selected approval/sandbox decision boundary. They derive environment/path approval keys, model permission-preapproval short-circuiting, emitted approval requests, opaque review decisions, auto sandbox preference, and sandbox retry intent without granting permissions or executing tools.
- `ModelPatchTurnDiffTrackerPolicy`, `ModelPatchTurnDiffTrackerRequest`, `ModelPatchTurnDiffTrackerOutcome`, `ModelPatchAppliedDelta`, `ModelPatchToolEventStageKind`, and `ModelPatchTurnDiffTrackerUpdateKind` model the selected turn-diff tracker boundary. They distinguish known exact deltas, unknown deltas, invalidation, rejected/no-delta no-ops, environment-scoped diff summaries, and whether a `TurnDiffEvent` would be emitted.
- `ModelPatchProjectionPolicy`, `ModelPatchProjectionRequest`, `ModelPatchProjectionOutcome`, `ModelPatchProjectionEventKind`, and `ModelPatchFileChangeProjection` model the selected `FileChangeItem`/legacy patch-event/app-server/TUI projection boundary. Canonical file-change item projection is distinct from optional legacy `PatchApplyBegin`/`PatchApplyEnd` projection, and the output carries typed status, auto-approved facts, stdout/stderr visibility, projected change summaries, and turn-diff notification intent.
- `ModelPatchToolFollowUpPolicy`, `ModelPatchToolFollowUpRequest`, `ModelPatchToolFollowUpOutcome`, and `ModelPatchToolOutputItemKind` model the selected apply-patch tool-output and model-follow-up boundary. They find the queued apply-patch call, project custom/function tool-output response shape, success status, post-tool-use response visibility, stdout/stderr/result text visibility, and the model follow-up requirement without executing tools.
- `ModelPatchToolResponseInputPolicy`, `ModelPatchToolResponseInputRequest`, `ModelPatchToolResponseInputOutcome`, and `ModelPatchToolResponseAdmissionKind` model the selected in-flight tool response collection and next-input admission boundary. They preserve response ordering, response kind, success/error output text, conversation-item recording intent, and follow-up-request requirement without owning live futures.
- `ModelSamplingContinuationPolicy`, `ModelSamplingContinuationRequest`, `ModelSamplingContinuationOutcome`, and `ModelSamplingContinuationKind` model the selected post-sampling continuation decision. They combine model follow-up, pending input, token-limit compaction, next request index, admitted response-input count, pending-input drain intent, and no-live-effect proofs without performing provider traffic.
- `ModelStreamItemReducerPolicy` maintains active item/tool metadata, emits deltas against that item or call id, strips selected hidden assistant markup at completion, accumulates accepted custom tool input when the completed item omits it, emits deterministic patch update events for supported streamed argument diffs, and queues tool calls for follow-up without executing them.

The fixture `fixtures/hxrust/model-stream-item-reducer.v1.json` covers OpenAI assistant text deltas and completion, OpenAI reasoning summary/raw deltas, OpenAI custom tool input delta routing and mismatch ignores, OpenAI and Responses Lite apply-patch-style `PatchApplyUpdated` progress/final events, add/delete/update/move/end-of-file patch chunks, apply-patch begin/end verification events, fixture-only virtual workspace application results, approval/preapproval/review/sandbox retry decisions, turn-diff tracker track/invalidate/no-op decisions, canonical file-change item projection, optional legacy patch begin/end projection, TUI/app-server status and stdout/stderr visibility facts, turn-diff notification projection, model-facing apply-patch tool-output response shape, follow-up queue admission, post-tool-use response visibility, tool-response input admission, response ordering, follow-up sampling continuation, pending-input drain decision, token-limit compaction routing, completed/failed/declined statuses, malformed patch refusal, Bedrock function delta ignored without a custom diff consumer, Bedrock function tool call follow-up routing, Responses Lite custom tool-call input accumulation, inherited local envelope refusal, no live traffic, no filesystem mutation, no tool execution, and secret-free summaries.

## Non-Goals

This is not live SSE parsing, WebSocket ownership, Tokio task ownership, actual tool execution, real workspace mutation, native apply-patch process ownership, plan-mode proposed-plan item extraction, provider auth refresh, unauthorized retry handling, inference trace persistence, realtime/audio transport, or interactive TUI implementation.

## Gate

Run:

```bash
bash harness/check-model-stream-item-reducer.sh
```

The gate runs Haxe interpreter validation, haxe.rust portable generation, generated `cargo check --locked`, generated `cargo test --locked`, and the generated binary.
