# Resume Picker Live Integration Plan

This is the upstream/raw Codex plan for turning the current deterministic resume picker smoke evidence into the first live haxe->rust TUI module. It is mainstream Codex work only; Cafex/Cafetera adapters remain later compatibility layers.

The target is not a headless picker helper. The target is a generated Rust binary that can eventually own the same resume picker path as upstream Codex: app-server page loading, terminal input, ratatui rendering, frame scheduling, config persistence, transcript preview, and transcript overlay.

## Current Evidence

The smoke sequence already captures the pure behavior we should preserve before adding live effects:

- `HXCX-TUI-94` through `HXCX-TUI-101` cover raw Codex resume picker thread list filtering, row projection, pagination, preview loading, full transcript open, keyboard/loading routing, density/toolbar persistence intent, footer progress, and render-state labels.
- `fixtures/hxrust/tui-smoke.v1.json` is still deterministic evidence: no live crossterm input, no live app-server fanout, no ratatui snapshot ownership, no state DB reads, no real config mutation, no model traffic, and no Cafex behavior.
- `harness/check-tui-smoke.sh` remains the current regression gate for the fixture boundary.
- `src/codexhx/runtime/tui/resume/` now owns the first pure Haxe resume picker kernel. `harness/check-resume-picker-kernel.sh` runs the same fixture evidence through the Haxe interpreter, portable haxe.rust generation, generated Cargo `check`, generated Cargo `test`, and the generated binary.
- `harness/check-resume-picker-host-facade.sh` validates the runtime-neutral host contracts for deterministic app-server thread sources, background loader events, frame scheduling, terminal-renderer snapshots, backpressure, cancellation, and in-memory density persistence.
- `harness/check-resume-picker-no-credential-gate.sh` now validates the first combined no-credential generated-Rust gate: fixture-backed thread list/read through the host facade, deterministic key events, frame requests, terminal/test rendering, transcript overlay open, and temp Codex-home density persistence.
- `harness/check-resume-picker-render-snapshot.sh` validates stable normalized test-backend screen snapshots for the no-credential picker path, including visible rows, selected row marker, loading overlay, transcript overlay, footer, and temp-home config evidence.
- `harness/check-resume-picker-preview-render.sh` validates fixture-backed `thread/read` preview rendering through the same normalized test-backend surface, including selected row, loading preview evidence, preview lines, and footer state.
- `harness/check-resume-picker-pagination-render.sh` validates fixture-backed second-page ingestion, next-cursor render evidence, loading-older state, visible loaded rows, and footer progress through the same normalized test-backend surface.
- `harness/check-resume-picker-empty-error-render.sh` validates normalized empty/loading/no-results and app-server page-failure render states, including visible error labels and footer state.
- `harness/check-resume-picker-transcript-overlay-render.sh` validates fixture-backed full transcript loading, loading overlay state, loaded transcript detail cells, and empty-transcript fallback cells through the normalized test-backend surface.
- `harness/check-resume-picker-toolbar-footer-render.sh` validates normalized toolbar focus/value display plus wide, compact, key-only, and loading footer/progress variants through the normalized test-backend surface.
- `harness/check-resume-picker-keyboard-navigation-render.sh` validates normalized keyboard navigation render states for selection movement, page/end-style scroll evidence, search query display, query clear restoration, and frame/render counts through the normalized test-backend surface.
- `harness/check-resume-picker-density-persistence-render.sh` validates normalized density persistence render states for temp-home config write success and persistence failure/error/footer evidence through the normalized test-backend surface.
- `harness/check-resume-picker-loader-cancellation-render.sh` validates normalized background-loader stale page/preview/transcript refusal and cancellation render states through the normalized test-backend surface.
- `harness/check-resume-picker-host-backpressure-render.sh` validates normalized bounded-loader backpressure states for best-effort frame drops, lossless page request backpressure, skipped/pending counts, and post-drain recovery through the normalized test-backend surface.

## Upstream Anchors

Use these upstream files as the live integration map:

- `../codex/codex-rs/tui/src/resume_picker.rs:550` owns `spawn_app_server_page_loader`, the Tokio task and unbounded channel that consume `PickerLoadRequest` and emit page, preview, and transcript background events.
- `../codex/codex-rs/tui/src/resume_picker.rs:633` owns `PickerState`, including pagination, query/search state, selected row, toolbar focus, density, transcript previews, transcript cells, pending transcript open, overlay, keymaps, and frame requester.
- `../codex/codex-rs/tui/src/resume_picker.rs:733` owns `load_app_server_page`, which calls `AppServerSession::thread_list`, maps `ThreadListResponse` rows, and carries cursor/pagination state.
- `../codex/codex-rs/tui/src/resume_picker.rs:765` owns `load_transcript_preview`, which calls `AppServerSession::thread_read(include_turns=true)` and projects preview lines.
- `../codex/codex-rs/tui/src/resume_picker.rs:1653` owns `toggle_density` and `persist_density`; `persist_density` uses `ConfigEditsBuilder::set_session_picker_view`.
- `../codex/codex-rs/tui/src/thread_transcript.rs:28` owns `load_session_transcript`; it calls `thread_read(include_turns=true)` and delegates to `thread_to_transcript_cells`.
- `../codex/codex-rs/tui/src/thread_transcript.rs:43` owns `thread_to_transcript_cells`, including `Arc<dyn HistoryCell>` transcript projection.
- `../codex/codex-rs/tui/src/pager_overlay.rs:53` owns `Overlay::new_transcript`, and `../codex/codex-rs/tui/src/pager_overlay.rs:435` owns `TranscriptOverlay`.
- `../codex/codex-rs/tui/src/app_server_session.rs:171` owns `AppServerSession`; `../codex/codex-rs/tui/src/app_server_session.rs:530` and `../codex/codex-rs/tui/src/app_server_session.rs:557` own `thread_list` and `thread_read`.
- `../codex/codex-rs/tui/src/tui/frame_requester.rs:31` owns `FrameRequester`; `../codex/codex-rs/tui/src/tui/frame_requester.rs:76` owns `FrameScheduler`, including coalesced draw notifications.
- `../codex/codex-rs/tui/src/tui.rs:68` aliases the production crossterm terminal; `../codex/codex-rs/tui/src/tui.rs:173` sets terminal modes; `../codex/codex-rs/tui/src/tui.rs:935` and `../codex/codex-rs/tui/src/tui.rs:1049` draw frames.
- `../codex/codex-rs/tui/src/lib.rs:1362` initializes the terminal before app startup, and `../codex/codex-rs/tui/src/lib.rs:1889` owns `TerminalRestoreGuard`.
- `../codex/codex-rs/tui/src/custom_terminal.rs:146` owns the custom terminal wrapper and `../codex/codex-rs/tui/src/custom_terminal.rs:170` owns its drop-time cursor restoration.
- `../codex/codex-rs/core/src/config/edit.rs:101` defines `session_picker_view_edit`; `../codex/codex-rs/core/src/config/edit.rs:753` owns `ConfigEditsBuilder`; `../codex/codex-rs/core/src/config/edit.rs:957` owns `set_session_picker_view`.

## Readiness Split

### Haxe-Owned Pure State

These pieces should move into typed Haxe first and remain runnable under both the Haxe interpreter and haxe.rust-generated Rust:

- `ResumePickerState` field model: pagination, rows, filtered rows, selected index, scroll, frozen footer percent, query/search token, toolbar focus, density, sort/filter mode, inline error, pending transcript open, overlay state tag, and keymap decisions.
- Typed row/protocol DTOs: thread ids, seen-row keys, provider filter, page cursor, sort key, filter mode, density, launch context, action, transcript preview lines, footer labels, and render-state variants.
- Pure decisions: filter/sort/search, selection movement, scroll visibility, load-more intent, query clearing with stable-row restoration, toolbar value changes, density toggle outcome, footer/hint fitting, empty-state labels, transcript loading gate, and overlay close routing.
- Fixture and differential public-behavior checks derived from upstream behavior, not upstream private test helper coupling.

Status: the first implementation slice is `codexhx.runtime.tui.resume`. It introduces typed command, state, effect, density, filter, sort, toolbar, and action spaces and reduces the existing smoke fixture into pure picker state transitions. The current kernel covers picker open, page request/ingest, stale page refusal, search continuation, sort/filter toggles, preview request/completion/render gating, transcript request/loading/completion/overlay opening, keyboard movement, query clearing, load-more intent, metadata failures, density persistence intent, toolbar focus/activation/render state, footer progress, hints, empty-state labels, loading overlay text, selection, and failure surfacing.

This is still pure state and effect-intent evidence. It does not own live `AppServerSession`, crossterm input, ratatui frames, config writes, state DB/rollout reads, transcript `HistoryCell` renderables, or pager overlay rendering.

### Metal/Native Boundaries

These should be typed Haxe APIs but lowered through haxe.rust metal/native Rust facades where production behavior depends on Rust crates, ownership, or async runtime semantics:

- Terminal ownership: crossterm raw mode, alternate screen or inline viewport, `CustomTerminal`, ratatui frame lifetimes, terminal restore guards, and drop-time cursor recovery.
- Frame scheduling: cloneable `FrameRequester`, coalesced `FrameScheduler`, draw broadcast notifications, rate limiting, and delayed redraws.
- App-server session: `thread/list`, `thread/read`, request ids, typed request/response boundaries, remote cwd behavior, and app-server client ownership.
- Loader task and channels: page/preview/transcript request queue, background events, cancellation/drop behavior, and backpressure story.
- Transcript overlay renderables: `Arc<dyn HistoryCell>`, pager overlay state, live tail cache keys, and ratatui text/layout rendering.
- Config persistence: `ConfigEditsBuilder`, `config.toml` writes, path handling, async error mapping, and no-op behavior when persistence is absent.

### Fixture-Only Until Replaced

These are still fixture evidence and must not be described as live parity yet:

- VT100/render labels that do not use real ratatui frame ownership.
- App-server thread/list/read intents without an app-server client or in-process no-credential server.
- Config persistence intents without real filesystem mutation.
- Transcript overlay open decisions without pager rendering.
- Frame request counts without a scheduler task and draw loop.

## Implementation Sequence

1. Port the pure picker kernel.
   - Add a Haxe `codexhx.tui.resume` module for typed picker state, page requests, background events, row projection, keyboard decisions, density/toolbar decisions, footer/render-state calculation, and transcript-open lifecycle.
   - Prefer abstracts/newtypes for ids and enum/enum abstract values for action spaces. Avoid stringly typed action dispatch except at JSON, CLI, or upstream compatibility boundaries.
   - Gate with interpreter tests and haxe.rust-generated Rust tests against the existing smoke fixture.

2. Add a runtime-neutral host facade.
   - Define typed Haxe interfaces for `PickerHost`, `AppServerThreadSource`, `FrameSchedulerHandle`, `TerminalRenderer`, and `PickerConfigPersistence`.
   - Keep the Haxe-facing async contract runtime-neutral: tasks, streams, poll/next outcomes, cancellation, and backpressure. Do not expose Tokio handles or Tokio types in codexhx APIs.
   - Start with deterministic in-memory implementations, then add metal/native Rust implementations behind haxe.rust.

Status: `codexhx.runtime.tui.resume.host` owns the first runtime-neutral host facade. It defines typed app-server thread-list/thread-read requests and responses, background loader requests/events, frame scheduler, terminal renderer, and config persistence contracts. `harness/check-resume-picker-host-facade.sh` validates deterministic in-memory implementations, lossless versus best-effort backpressure, cancellation, frame scheduling, rendering, and density persistence through the Haxe interpreter and portable haxe.rust-generated Rust. Tokio, crossterm, ratatui frame lifetimes, config file mutation, and live app-server transport remain behind future metal/native boundaries.

3. Add the no-credential app-server loop.
   - Build an in-process or local fixture-backed app-server implementation that serves `thread/list` and `thread/read` through the same typed request/response path as production.
   - Prove page load, cursor pagination, preview load, and full transcript load through generated Rust without provider credentials or model traffic.
   - Keep upstream `AppServerSession` semantics visible: request ids, include-turns flags, cursor propagation, and error mapping.

Status: `codexhx.runtime.tui.resume.live.ResumePickerNoCredentialGate` composes the host facade into the first credential-free generated-Rust app loop slice. The gate loads fixture-backed threads, applies deterministic key events, requests and renders frames through the test terminal renderer, opens the selected transcript overlay, and writes `session_picker_view = "dense"` into a temp Codex home. This is still a deterministic facade gate: it does not claim live JSON-RPC transport, crossterm input, ratatui frame ownership, state DB/rollout querying, provider traffic, or real user config mutation.

4. Add the terminal/render smoke runner.
   - First use a VT100/test backend to render the Haxe picker through generated Rust and compare stable snapshots or normalized screen text.
   - Then add an opt-in real crossterm runner for manual/live validation. The automated gate should remain credential-free and non-destructive.
   - Confirm terminal restore behavior and raw-mode safety before any default live terminal gate.

Status: `harness/check-resume-picker-render-snapshot.sh` adds the first normalized terminal/test-backend snapshot gate for the resume picker path. It asserts six generated-Rust render snapshots across open, page load, selection movement, transcript loading, transcript loaded, and density persistence. The snapshot is text-normalized evidence only: it is not live crossterm takeover, ratatui frame lifetime ownership, state DB mutation, model traffic, or Cafex behavior.

5. Replace smoke-only behaviors incrementally.
   - Page load: typed fixture intent -> generated Rust app-server request path.
   - Selection/render: pure state text evidence -> ratatui/VT100 snapshot.
   - Preview: request intent -> app-server `thread/read(include_turns=true)` through host facade and normalized preview-line render snapshot.
   - Full transcript: pending-open fixture -> loaded `TranscriptOverlay` state and render snapshot.
   - Toolbar/density: persistence intent -> temp-home `config.toml` mutation through `ConfigEditsBuilder` equivalent.
   - Footer/progress: label fixture -> rendered footer snapshot at multiple widths.

Status: pagination/load-more now has generated-Rust normalized render evidence in `harness/check-resume-picker-pagination-render.sh`. The gate loads the first page through the host facade, renders the next cursor and `moreBelow` state, renders the loading-older frame, ingests a second fixture-backed page, and asserts final loaded-row/footer state. This is still deterministic test-backend evidence, not live app-server fanout, live crossterm input, ratatui frame ownership, state DB/rollout querying, or Cafex behavior.

Status: empty/error render states now have generated-Rust normalized evidence in `harness/check-resume-picker-empty-error-render.sh`. The gate renders initial loading, no-sessions, search no-results, and a failed page-load surface through the host facade and deterministic renderer. This is still deterministic test-backend evidence, not live app-server fanout, live crossterm input, ratatui frame ownership, state DB/rollout querying, or Cafex behavior.

Status: transcript overlay detail now has generated-Rust normalized evidence in `harness/check-resume-picker-transcript-overlay-render.sh`. The gate renders pending full-transcript loading, loaded transcript detail cells, and the empty-transcript fallback cell through fixture-backed `thread/read` calls on the host facade. This is still deterministic test-backend evidence, not pager overlay ownership, live app-server fanout, live crossterm input, ratatui frame ownership, state DB/rollout querying, or Cafex behavior.

Status: toolbar/footer width variants now have generated-Rust normalized evidence in `harness/check-resume-picker-toolbar-footer-render.sh`. The gate renders Filter/Sort toolbar focus and value states plus wide, compact, key-only, and loading footer/progress variants. This is still deterministic test-backend evidence, not live crossterm input, ratatui layout ownership, app-server fanout, state DB/rollout querying, or Cafex behavior.

Status: keyboard navigation variants now have generated-Rust normalized evidence in `harness/check-resume-picker-keyboard-navigation-render.sh`. The gate renders initial selection, down movement, page/end-style selection and scroll evidence, active search query display, and query-clear/start-fresh restoration. This is still deterministic test-backend evidence, not live crossterm input, ratatui layout ownership, app-server fanout, state DB/rollout querying, or Cafex behavior.

Status: density persistence success/failure variants now have generated-Rust normalized evidence in `harness/check-resume-picker-density-persistence-render.sh`. The gate renders a temp Codex-home `config.toml` write for dense mode and a deterministic persistence-unconfigured failure with visible inline error, config status, and footer labels. This is still deterministic test-backend evidence, not live user config mutation, live crossterm input, ratatui layout ownership, app-server fanout, state DB/rollout querying, or Cafex behavior.

Status: background-loader cancellation and stale-event variants now have generated-Rust normalized evidence in `harness/check-resume-picker-loader-cancellation-render.sh`. The gate renders accepted baseline page state, stale page/preview/transcript events ignored without mutating visible picker state, and loader cancellation evidence. This is still deterministic test-backend evidence, not live app-server fanout, live crossterm input, ratatui layout ownership, state DB/rollout querying, Tokio task ownership, or Cafex behavior.

Status: bounded-loader backpressure variants now have generated-Rust normalized evidence in `harness/check-resume-picker-host-backpressure-render.sh`. The gate renders best-effort frame drop evidence, lossless page request backpressure evidence, skipped/pending counts, and recovered page rendering after draining the stream. This is still deterministic test-backend evidence, not live app-server fanout, live crossterm input, ratatui layout ownership, state DB/rollout querying, Tokio task ownership, or Cafex behavior.

6. Add differential upstream checks.
   - Use upstream schemas, fixtures, and public behavior as oracle evidence.
   - Do not treat upstream Rust-internal test success as sufficient for codexhx. The proof is Haxe source running through haxe.rust-generated Rust.
   - Once a generated codexhx binary exists, compare public inputs and normalized visible output against upstream where feasible.

7. Only then return to Cafex adapter surfaces.
   - Cafex should consume the upstream-shaped picker/core seams after they are strong enough.
   - Cafex behavior must stay out of core picker state and out of `../haxe.rust`.

## haxe.rust Pressure Points

Expected generic pressure points to watch while implementing the live picker are:

- Borrow/ownership-shaped APIs for ratatui frame lifetimes, terminal backends, and drop/RAII restore guards.
- Async task/channel lowering for the loader queue and frame scheduler without exposing Tokio in Haxe-facing APIs.
- Efficient enum/newtype lowering for picker actions, toolbar controls, density, filter/sort modes, background events, and request/result unions.
- Trait object or equivalent renderable support for transcript cells and pager overlays.
- Low-clone collection lowering for rows, preview lines, transcript cells, and stable row keys.
- Native `Result`/error-boundary output quality for app-server, terminal, config, and IO errors.
- Warning-clean, readable Rust for state reducers and host facades with minimal hxrt/runtime involvement on hot paths.
- Nullable JSON enum helper lowering: the pure picker kernel initially exposed a portable generated-Rust mismatch around matching `Null<haxe.json.Value>` helper returns, where the emitted Rust pattern shape confused `Option<Value>` and `Value`. This is fixed upstream in haxe.rust `8b7b97b24f19577dda522e7d0cae33853a4ff44c` / `haxe.rust-qsoq` with a product-neutral `json_nullable_value_switch` snapshot. codexhx can revisit local typed field-lookup workarounds when a future picker slice benefits from the clearer direct `Null<Value>` switch shape.

Any concrete compiler/runtime limitation found while implementing the picker belongs in `../haxe.rust` as a generic fixture or test. Do not add Codex-specific compiler behavior.

## Validation Gates

Near-term gates:

- `harness/check-tui-smoke.sh`
- `harness/check-resume-picker-kernel.sh` for Haxe interpreter tests plus haxe.rust-generated Cargo `check`, `test`, and binary execution for the pure picker kernel.
- `harness/check-resume-picker-host-facade.sh` for runtime-neutral host contracts, deterministic in-memory implementations, backpressure/cancellation, and portable haxe.rust-generated Rust validation.
- `harness/check-resume-picker-no-credential-gate.sh` for the first combined no-credential generated-Rust app-server facade, deterministic key, frame/render, transcript overlay, and temp-home density persistence gate.
- `harness/check-resume-picker-render-snapshot.sh` for normalized VT100/test-backend-style screen snapshots before any live crossterm automation.
- `harness/check-resume-picker-preview-render.sh` for normalized preview-line render snapshots driven by fixture-backed `thread/read previewOnly=true`.
- `harness/check-resume-picker-pagination-render.sh` for normalized pagination/load-more snapshots driven by fixture-backed first and second page loads.
- `harness/check-resume-picker-empty-error-render.sh` for normalized empty/loading/no-results and page-failure render snapshots.
- `harness/check-resume-picker-transcript-overlay-render.sh` for normalized full-transcript loading, loaded detail, and empty-fallback transcript snapshots.
- `harness/check-resume-picker-toolbar-footer-render.sh` for normalized toolbar focus/value and footer width/fallback snapshots.
- `harness/check-resume-picker-keyboard-navigation-render.sh` for normalized selection movement, page/end-style navigation, search query, and query-clear/start-fresh snapshots.
- `harness/check-resume-picker-density-persistence-render.sh` for normalized density config persistence success and failure/error/footer snapshots.
- `harness/check-resume-picker-loader-cancellation-render.sh` for normalized background-loader stale event refusal and cancellation snapshots.
- `harness/check-resume-picker-host-backpressure-render.sh` for normalized bounded-loader best-effort drop, lossless backpressure, skipped/pending count, and recovery snapshots.

Exit criteria for "first live resume picker slice":

- A generated Rust binary can load fixture-backed threads through the app-server facade, render the picker through a terminal/test backend, accept deterministic key events, request frames, open a transcript overlay, and persist density into a temp Codex home.
- The automated proof is credential-free, filesystem mutations are confined to temp dirs, generated Rust is not manually edited, and `bd ready` still presents upstream/raw work before Cafex adapters.
