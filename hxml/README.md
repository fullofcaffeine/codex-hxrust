# HXML Profiles

Profile policy for the scaffold:

| File | Purpose |
| --- | --- |
| `portable.codegen.hxml` | Generate portable Rust only with `-D rust_no_build`. |
| `portable.hxml` | Generate portable Rust and run `cargo check`. |
| `metal.codegen.hxml` | Generate metal Rust only with `-D rust_no_build`. |
| `metal.hxml` | Generate metal Rust and run `cargo check`. |
| `diagnostics.hxml` | Compile the HXCX-4.6 diagnostics redaction and failure-report harness through portable haxe.rust. |
| `protocol-ids.hxml` | Compile the G2.1 protocol ID harness through portable haxe.rust. |
| `json-boundary.hxml` | Compile the G2.2 JSON boundary harness through portable haxe.rust. |
| `config-profile.hxml` | Compile the G2.3 config/profile DTO harness through portable haxe.rust. |
| `provider-admission.hxml` | Compile the HXCX-4.43 raw provider admission boundary harness through portable haxe.rust. |
| `model-catalog.hxml` | Compile the HXCX-4.44 raw model catalog and provider capabilities harness through portable haxe.rust. |
| `turn-model-plan.hxml` | Compile the HXCX-4.45 raw turn model selection and tool-capability planning harness through portable haxe.rust. |
| `model-request-envelope.hxml` | Compile the HXCX-4.46 raw model request envelope and response routing harness through portable haxe.rust. |
| `model-stream-route.hxml` | Compile the HXCX-4.47 raw model stream event and error routing harness through portable haxe.rust. |
| `model-stream-item-reducer.hxml` | Compile the HXCX-4.48/HXCX-4.50/HXCX-4.51/HXCX-4.52 raw stream item reducer, assistant output routing, tool-call input delta, and streamed argument diff event harness through portable haxe.rust. |
| `async-runtime-contract.hxml` | Compile the HXCX-4.49 runtime-neutral async task/stream/cancel/backpressure contract harness through portable haxe.rust. |
| `app-protocol.hxml` | Compile the G2.4 app-server protocol subset harness through portable haxe.rust. |
| `mock-model-stream.hxml` | Compile the HXCX-3.1/HXCX-3.6 mock model stream parser, fixture provider, one-turn state machine, cancellation, and transcript/state store harness through portable haxe.rust. |
| `headless-jsonl-adapter.hxml` | Compile the HXCX-3.4 command JSONL app-server/debug adapter harness through portable haxe.rust. |
| `runtime-app-client.hxml` | Compile the HXCX-4.7 runtime event bus and in-memory app-server client facade harness through portable haxe.rust. |
| `runtime-bootstrap.hxml` | Compile the HXCX-4.11 initialize/bootstrap runtime harness through portable haxe.rust. |
| `runtime-transport.hxml` | Compile the HXCX-4.12 fixture live-transport harness through portable haxe.rust. |
| `persistence-boundary.hxml` | Compile the HXCX-4.13 persistent app-server/TUI state boundary harness through portable haxe.rust. |
| `native-sqlite-persistence.hxml` | Compile the HXCX-4.14 native SQLite persistence pressure harness through metal haxe.rust. |
| `native-state-adapter.hxml` | Compile the HXCX-4.15 native SQLite state adapter reconcile/query pressure harness through metal haxe.rust. |
| `persisted-thread-read-view.hxml` | Compile the HXCX-4.16 persisted thread read-view harness through metal haxe.rust after native adapter setup. |
| `thread-read-turn-projection.hxml` | Compile the HXCX-4.17 raw thread/read turn projection harness through portable haxe.rust. |
| `thread-read-turns-page.hxml` | Compile the HXCX-4.18 raw thread/read turns page harness through portable haxe.rust. |
| `thread-read-active-turn-merge.hxml` | Compile the HXCX-4.19 raw active-turn merge/status normalization harness through portable haxe.rust. |
| `thread-read-turn-items-list.hxml` | Compile the HXCX-4.20 raw thread/turns/items unsupported-runtime harness through portable haxe.rust. |
| `thread-read-token-usage-owner.hxml` | Compile the HXCX-4.21 raw token-usage replay owner attribution harness through portable haxe.rust. |
| `thread-read-token-usage-replay.hxml` | Compile the HXCX-4.22 raw restored token-usage notification payload harness through portable haxe.rust. |
| `thread-read-token-usage-replay-delivery.hxml` | Compile the HXCX-4.23 raw restored token-usage delivery-policy harness through portable haxe.rust. |
| `thread-read-resume-goal-snapshot.hxml` | Compile the HXCX-4.24 raw resume-goal snapshot ordering harness through portable haxe.rust. |
| `thread-read-resume-idle-continuation.hxml` | Compile the HXCX-4.25 raw resume idle lifecycle continuation harness through portable haxe.rust. |
| `thread-read-goal-steering.hxml` | Compile the HXCX-4.26 raw goal steering item harness through portable haxe.rust. |
| `thread-read-try-start-turn-if-idle.hxml` | Compile the HXCX-4.27 raw try_start_turn_if_idle admission harness through portable haxe.rust. |
| `thread-read-goal-runtime-restore.hxml` | Compile the HXCX-4.28 raw goal runtime restore-after-resume harness through portable haxe.rust. |
| `thread-read-active-turn-goal-steering-injection.hxml` | Compile the HXCX-4.29 raw active-turn goal steering injection harness through portable haxe.rust. |
| `thread-read-budget-limit-goal-steering.hxml` | Compile the HXCX-4.30 raw budget-limit goal steering harness through portable haxe.rust. |
| `thread-read-active-goal-progress-accounting.hxml` | Compile the HXCX-4.31 raw active-goal progress accounting harness through portable haxe.rust. |
| `thread-read-idle-goal-progress-accounting.hxml` | Compile the HXCX-4.32 raw idle-goal progress accounting harness through portable haxe.rust. |
| `thread-read-turn-start-goal-accounting.hxml` | Compile the HXCX-4.33 raw turn-start goal accounting harness through portable haxe.rust. |
| `thread-read-turn-goal-finalization.hxml` | Compile the HXCX-4.34 raw turn-stop/abort goal finalization harness through portable haxe.rust. |
| `thread-read-turn-error-active-goal-stop.hxml` | Compile the HXCX-4.35 raw turn-error active-goal stop harness through portable haxe.rust. |
| `thread-read-goal-token-usage-record.hxml` | Compile the HXCX-4.36 raw goal token-usage contribution harness through portable haxe.rust. |
| `thread-read-tool-finish-goal-progress-admission.hxml` | Compile the HXCX-4.37 raw tool-finish goal-progress admission harness through portable haxe.rust. |
| `thread-read-goal-tool-contributor-visibility.hxml` | Compile the HXCX-4.38 raw goal tool contributor visibility harness through portable haxe.rust. |
| `thread-read-get-goal-tool.hxml` | Compile the HXCX-4.39 raw `get_goal` tool executor harness through portable haxe.rust. |
| `thread-read-create-goal-tool.hxml` | Compile the HXCX-4.40 raw `create_goal` tool executor harness through portable haxe.rust. |
| `thread-read-update-goal-tool.hxml` | Compile the HXCX-4.41 raw `update_goal` tool executor harness through portable haxe.rust. |
| `thread-read-goal-tool-dispatch.hxml` | Compile the HXCX-4.42 raw goal tool executor dispatch harness through portable haxe.rust. |
| `tui-smoke.hxml` | Compile the HXCX-TUI-0/HXCX-TUI-1/HXCX-TUI-2/HXCX-TUI-3/HXCX-TUI-4/HXCX-TUI-5/HXCX-TUI-6/HXCX-TUI-7/HXCX-TUI-8/HXCX-TUI-9/HXCX-TUI-10/HXCX-TUI-11/HXCX-TUI-12/HXCX-TUI-13/HXCX-TUI-14/HXCX-TUI-15/HXCX-TUI-16/HXCX-TUI-17/HXCX-TUI-18/HXCX-TUI-19/HXCX-TUI-20/HXCX-TUI-21/HXCX-TUI-22/HXCX-TUI-23/HXCX-TUI-24/HXCX-TUI-25/HXCX-TUI-26/HXCX-TUI-27/HXCX-TUI-28/HXCX-TUI-29/HXCX-TUI-30/HXCX-TUI-31/HXCX-TUI-32/HXCX-TUI-33/HXCX-TUI-34/HXCX-TUI-35/HXCX-TUI-36/HXCX-TUI-37/HXCX-TUI-38/HXCX-TUI-39/HXCX-TUI-40/HXCX-TUI-41/HXCX-TUI-42/HXCX-TUI-43/HXCX-TUI-44/HXCX-TUI-45/HXCX-TUI-46/HXCX-TUI-47/HXCX-TUI-48 generated TUI smoke binary, headless app-loop shell, app-event queue facade, app-server event facade, server-request facade, request-resolution facade, active-thread request delivery facade, active-thread notification delivery facade, pending interactive replay-filter facade, thread snapshot turn-history replay facade, thread snapshot session/input replay facade, replayed server-request surface facade, replayed notification/history/feedback event surface facade, replay-buffer flush/reflow facade, resize draw scheduling facade, resize repaint/scrollback facade, inline viewport resize sync facade, suspend/resume viewport facade, event-stream pause/resume facade, terminal mode/keyboard enhancement facade, alternate-screen lifecycle facade, draw/update composition facade, frame requester scheduler facade, draw-event dispatch facade, overlay routing facade, approval overlay lifecycle facade, request-user-input overlay lifecycle facade, MCP elicitation overlay lifecycle facade, app-link URL elicitation lifecycle facade, hooks browser lifecycle facade, slash-command popup lifecycle facade, file-search/mention popup lifecycle facade, composer history-search lifecycle facade, composer paste/attachment lifecycle facade, composer submission/dispatch lifecycle facade, composer editing/key-dispatch lifecycle facade, composer popup synchronization lifecycle facade, composer active-popup key lifecycle facade, composer active-popup layout/render lifecycle facade, composer footer/status hint render lifecycle facade, composer textarea render/mask/highlight lifecycle facade, ChatWidget composer render integration facade, ChatWidget active stream/live-tail facade, ChatWidget stream status restore/error facade, ChatWidget stream interruption/finish lifecycle facade, ChatWidget interrupt/quit shortcut lifecycle facade, ChatWidget interrupted-turn notice/prompt restore facade, side-conversation start/return lifecycle facade, and clear/archive lifecycle facade through metal haxe.rust. |
| `resume-picker-kernel.hxml` | Compile the HXCX-TUI-103 resume picker pure state/effect kernel harness through portable haxe.rust. |
| `resume-picker-host-facade.hxml` | Compile the HXCX-TUI-104 resume picker runtime-neutral host facade harness through portable haxe.rust. |
| `resume-picker-no-credential-gate.hxml` | Compile the HXCX-TUI-105 resume picker no-credential app-server/render/config gate through portable haxe.rust. |
| `resume-picker-render-snapshot.hxml` | Compile the HXCX-TUI-106 resume picker normalized VT100/test-backend render snapshot gate through portable haxe.rust. |
| `resume-picker-preview-render.hxml` | Compile the HXCX-TUI-107 resume picker normalized transcript-preview render snapshot gate through portable haxe.rust. |
| `resume-picker-pagination-render.hxml` | Compile the HXCX-TUI-108 resume picker normalized pagination/load-more render snapshot gate through portable haxe.rust. |
| `resume-picker-empty-error-render.hxml` | Compile the HXCX-TUI-109 resume picker normalized empty/error render snapshot gate through portable haxe.rust. |
| `resume-picker-transcript-overlay-render.hxml` | Compile the HXCX-TUI-110 resume picker normalized transcript overlay detail render snapshot gate through portable haxe.rust. |
| `resume-picker-toolbar-footer-render.hxml` | Compile the HXCX-TUI-111 resume picker normalized toolbar/footer width render snapshot gate through portable haxe.rust. |
| `resume-picker-keyboard-navigation-render.hxml` | Compile the HXCX-TUI-112 resume picker normalized keyboard navigation render snapshot gate through portable haxe.rust. |
| `resume-picker-density-persistence-render.hxml` | Compile the HXCX-TUI-113 resume picker normalized density persistence render snapshot gate through portable haxe.rust. |
| `resume-picker-loader-cancellation-render.hxml` | Compile the HXCX-TUI-114 resume picker normalized loader cancellation/stale-event render snapshot gate through portable haxe.rust. |
| `resume-picker-host-backpressure-render.hxml` | Compile the HXCX-TUI-115 resume picker normalized host backpressure render snapshot gate through portable haxe.rust. |
| `resume-picker-invalid-row-projection-render.hxml` | Compile the HXCX-TUI-116 resume picker normalized invalid-row projection render snapshot gate through portable haxe.rust. |
| `resume-picker-scan-cap-render.hxml` | Compile the HXCX-TUI-117 resume picker normalized scan-cap pagination render snapshot gate through portable haxe.rust. |
| `resume-picker-query-reload-render.hxml` | Compile the HXCX-TUI-118 resume picker normalized query reload render snapshot gate through portable haxe.rust. |
| `resume-picker-sort-filter-reload-render.hxml` | Compile the HXCX-TUI-119 resume picker normalized sort/filter reload render snapshot gate through portable haxe.rust. |
| `resume-picker-stale-reload-response-render.hxml` | Compile the HXCX-TUI-120 resume picker normalized stale reload response refusal render snapshot gate through portable haxe.rust. |
| `resume-picker-no-results-reload-recovery-render.hxml` | Compile the HXCX-TUI-121 resume picker normalized no-results reload recovery render snapshot gate through portable haxe.rust. |
| `resume-picker-reload-selection-preservation-render.hxml` | Compile the HXCX-TUI-122 resume picker normalized reload selection preservation render snapshot gate through portable haxe.rust. |
| `resume-picker-reload-scroll-preservation-render.hxml` | Compile the HXCX-TUI-123 resume picker normalized reload scroll preservation render snapshot gate through portable haxe.rust. |
| `resume-picker-reload-preview-invalidation-render.hxml` | Compile the HXCX-TUI-124 resume picker normalized reload preview invalidation render snapshot gate through portable haxe.rust. |
| `resume-picker-reload-transcript-overlay-invalidation-render.hxml` | Compile the HXCX-TUI-125 resume picker normalized reload transcript overlay invalidation render snapshot gate through portable haxe.rust. |
| `resume-picker-reload-failure-preservation-render.hxml` | Compile the HXCX-TUI-126 resume picker normalized reload failure preservation render snapshot gate through portable haxe.rust. |
| `resume-picker-live-app-server-boundary-render.hxml` | Compile the HXCX-TUI-127 resume picker normalized live app-server boundary render snapshot gate through portable haxe.rust. |
| `resume-picker-json-rpc-thread-list-transport-render.hxml` | Compile the HXCX-TUI-128 resume picker normalized JSON-RPC `thread/list` transport render gate through portable haxe.rust. |
| `resume-picker-json-rpc-thread-read-transport-render.hxml` | Compile the HXCX-TUI-129 resume picker normalized JSON-RPC `thread/read` transport render gate through portable haxe.rust. |
| `resume-picker-app-server-stream-fanout-render.hxml` | Compile the HXCX-TUI-130 resume picker normalized app-server stream/fanout render gate through portable haxe.rust. |
| `resume-picker-app-server-session-lifecycle-render.hxml` | Compile the HXCX-TUI-131 resume picker normalized app-server session lifecycle render gate through portable haxe.rust. |
| `resume-picker-app-server-event-pump-boundary-render.hxml` | Compile the HXCX-TUI-132 resume picker normalized app-server event-pump boundary render gate through portable haxe.rust. |
| `resume-picker-app-server-stream-pressure-render.hxml` | Compile the HXCX-TUI-133 resume picker normalized app-server lossless/best-effort stream pressure render gate through portable haxe.rust. |
| `resume-picker-app-server-server-request-delivery-render.hxml` | Compile the HXCX-TUI-134 resume picker normalized app-server server-request delivery render gate through portable haxe.rust. |
| `resume-picker-app-server-response-dispatch-intent-render.hxml` | Compile the HXCX-TUI-135 resume picker normalized app-server response dispatch intent render gate through portable haxe.rust. |
| `resume-picker-app-server-response-dispatch-failure-noop-render.hxml` | Compile the HXCX-TUI-136 resume picker normalized app-server response dispatch failure/noop render gate through portable haxe.rust. |
| `resume-picker-app-server-response-transport-envelope-render.hxml` | Compile the HXCX-TUI-137 resume picker normalized app-server response transport envelope render gate through portable haxe.rust. |
| `resume-picker-app-server-pending-request-registry-render.hxml` | Compile the HXCX-TUI-138 resume picker normalized app-server pending request registry render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-pending-request-registry-render.hxml` | Compile the HXCX-TUI-139 resume picker normalized app-server typed pending request-class registry render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-payload-envelope-render.hxml` | Compile the HXCX-TUI-140 resume picker normalized app-server typed response payload/envelope render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-dispatch-ordering-refresh-render.hxml` | Compile the HXCX-TUI-141 resume picker normalized app-server typed response dispatch ordering/refresh render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-refresh-application-render.hxml` | Compile the HXCX-TUI-142 resume picker normalized app-server typed response refresh application render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-refresh-replay-delivery-render.hxml` | Compile the HXCX-TUI-143 resume picker normalized app-server typed response refresh replay-delivery render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-replay-surface-update-render.hxml` | Compile the HXCX-TUI-144 resume picker normalized app-server typed response replay surface-update render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-surface-recovery-confirmation-render.hxml` | Compile the HXCX-TUI-145 resume picker normalized app-server typed response surface recovery-confirmation render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-follow-up-action-render.hxml` | Compile the HXCX-TUI-146 resume picker normalized app-server typed response recovery follow-up action render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-idle-state-handoff-render.hxml` | Compile the HXCX-TUI-147 resume picker normalized app-server typed response recovery idle-state handoff render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-keyboard-readiness-render.hxml` | Compile the HXCX-TUI-148 resume picker normalized app-server typed response recovery keyboard readiness render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-keyboard-render-state-render.hxml` | Compile the HXCX-TUI-149 resume picker normalized app-server typed response recovery keyboard render-state render gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-render-snapshot-replay-render.hxml` | Compile the HXCX-TUI-150 resume picker normalized app-server typed response recovery render snapshot replay gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-replay-completion-handoff-render.hxml` | Compile the HXCX-TUI-151 resume picker normalized app-server typed response recovery replay completion handoff gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-input-admission-render.hxml` | Compile the HXCX-TUI-152 resume picker normalized app-server typed response recovery post-completion input admission gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-input-render-intent-render.hxml` | Compile the HXCX-TUI-153 resume picker normalized app-server typed response recovery post-completion input render-intent gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-render-request-scheduling-render.hxml` | Compile the HXCX-TUI-154 resume picker normalized app-server typed response recovery post-completion render request scheduling gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-scheduled-render-execution-render.hxml` | Compile the HXCX-TUI-155 resume picker normalized app-server typed response recovery post-completion scheduled render execution gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-rendered-state-handoff-render.hxml` | Compile the HXCX-TUI-156 resume picker normalized app-server typed response recovery post-completion rendered-state handoff gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-keyboard-readiness-render.hxml` | Compile the HXCX-TUI-157 resume picker normalized app-server typed response recovery post-completion post-render keyboard readiness gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-keyboard-render-state-render.hxml` | Compile the HXCX-TUI-158 resume picker normalized app-server typed response recovery post-completion post-render keyboard render-state gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-keyboard-render-snapshot-replay-render.hxml` | Compile the HXCX-TUI-159 resume picker normalized app-server typed response recovery post-completion post-render keyboard render snapshot replay gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-completion-handoff-render.hxml` | Compile the HXCX-TUI-160 resume picker normalized app-server typed response recovery post-completion post-render replay completion handoff gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-input-admission-render.hxml` | Compile the HXCX-TUI-161 resume picker normalized app-server typed response recovery post-completion post-render input admission gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-input-render-intent-render.hxml` | Compile the HXCX-TUI-162 resume picker normalized app-server typed response recovery post-completion post-render input render-intent gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-render-request-scheduling-render.hxml` | Compile the HXCX-TUI-163 resume picker normalized app-server typed response recovery post-completion post-render render request scheduling gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-scheduled-render-execution-render.hxml` | Compile the HXCX-TUI-164 resume picker normalized app-server typed response recovery post-completion post-render scheduled render execution gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-rendered-state-handoff-render.hxml` | Compile the HXCX-TUI-165 resume picker normalized app-server typed response recovery post-completion post-render rendered-state handoff gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-keyboard-readiness-render.hxml` | Compile the HXCX-TUI-166 resume picker normalized app-server typed response recovery post-completion post-render replay-aware keyboard readiness gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-keyboard-render-state-render.hxml` | Compile the HXCX-TUI-167 resume picker normalized app-server typed response recovery post-completion post-render replay-aware keyboard render-state gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-keyboard-render-snapshot-replay-render.hxml` | Compile the HXCX-TUI-168 resume picker normalized app-server typed response recovery post-completion post-render replay-aware keyboard render-snapshot replay gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-replay-completion-handoff-render.hxml` | Compile the HXCX-TUI-169 resume picker normalized app-server typed response recovery post-completion post-render replay-aware replay-completion handoff gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-input-admission-render.hxml` | Compile the HXCX-TUI-170 resume picker normalized app-server typed response recovery post-completion post-render replay-aware input admission gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-input-render-intent-render.hxml` | Compile the HXCX-TUI-171 resume picker normalized app-server typed response recovery post-completion post-render replay-aware input render-intent gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-render-request-scheduling-render.hxml` | Compile the HXCX-TUI-172 resume picker normalized app-server typed response recovery post-completion post-render replay-aware render request scheduling gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-scheduled-render-execution-render.hxml` | Compile the HXCX-TUI-173 resume picker normalized app-server typed response recovery post-completion post-render replay-aware scheduled render execution gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-handoff-render.hxml` | Compile the HXCX-TUI-174 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state handoff gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-keyboard-readiness-render.hxml` | Compile the HXCX-TUI-175 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state keyboard readiness gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-keyboard-render-state-render.hxml` | Compile the HXCX-TUI-176 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state keyboard render-state gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-keyboard-render-snapshot-replay-render.hxml` | Compile the HXCX-TUI-177 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state keyboard render-snapshot replay gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-replay-completion-handoff-render.hxml` | Compile the HXCX-TUI-178 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state replay-completion handoff gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-input-admission-render.hxml` | Compile the HXCX-TUI-179 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state input admission gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-input-render-intent-render.hxml` | Compile the HXCX-TUI-180 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state input render-intent gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-render-request-scheduling-render.hxml` | Compile the HXCX-TUI-181 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state render request scheduling gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-scheduled-render-execution-render.hxml` | Compile the HXCX-TUI-182 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state scheduled render execution gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-scheduled-execution-handoff-render.hxml` | Compile the HXCX-TUI-183 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state scheduled execution handoff gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-keyboard-readiness-render.hxml` | Compile the HXCX-TUI-184 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state second-cycle keyboard readiness gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-keyboard-render-state-render.hxml` | Compile the HXCX-TUI-185 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state second-cycle keyboard render-state gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-keyboard-render-snapshot-replay-render.hxml` | Compile the HXCX-TUI-186 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state second-cycle keyboard render-snapshot replay gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-replay-completion-handoff-render.hxml` | Compile the HXCX-TUI-187 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state second-cycle replay-completion handoff gate through portable haxe.rust. |
| `resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-input-admission-render.hxml` | Compile the HXCX-TUI-188 resume picker normalized app-server typed response recovery post-completion post-render replay-aware rendered-state second-cycle input admission gate through portable haxe.rust. |
| `tui-story-replay.hxml` | Compile the HXCX-4.8 upstream TUI story replay parser and summary harness through portable haxe.rust. |
| `tui-render.hxml` | Compile the HXCX-4.9 VT100/history/render invariant harness through portable haxe.rust. |
| `turn-runtime-reducer.hxml` | Compile the HXCX-4.10 upstream turn-runtime reducer harness through portable haxe.rust. |
| `apply-patch-dry-run.hxml` | Compile the HXCX-4.1 apply-patch dry-run wrapper harness through portable haxe.rust. |
| `process-exec.hxml` | Compile the HXCX-4.2 exact-approval process exec wrapper harness through portable haxe.rust. |
| `sandbox-gate.hxml` | Compile the HXCX-4.3 fail-closed sandbox permission gate harness through portable haxe.rust. |
| `caf-receipts.hxml` | Compile the HXCX-5.1 Caf session/turn receipt adapter harness through portable haxe.rust. |
| `caf-bridge.hxml` | Compile the HXCX-5.2/HXCX-8.1 Caf effort/wake/goal bridge harness through portable haxe.rust. |
| `caf-active-lane.hxml` | Compile the HXCX-8.2 Caf active-lane capability writer harness through portable haxe.rust. |
| `caf-continuity.hxml` | Compile the HXCX-5.4 Caf successor/predecessor continuity metadata harness through portable haxe.rust. |
| `goals.hxml` | Compile the HXCX-5.3 goal DTO/state/tool harness through portable haxe.rust. |

`rust_output` paths are deterministic:

- `generated/portable`
- `generated/metal`

The profile hxmls intentionally use haxe.rust's `cargo check` first so the generated crates can establish their initial lockfiles and dependency shape.

Locked validation is owned by `../scripts/check-generated-cargo.sh`, which runs:

- `cargo check --locked`
- `cargo test --locked`

for both generated crates.
