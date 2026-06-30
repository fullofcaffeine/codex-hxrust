# TUI Live Prompt Transport

**Beads:** `TUI-LIVE-13` / `codex-hxrust-0gms`, `TUI-LIVE-14` / `codex-hxrust-og2d`, `TUI-LIVE-15` / `codex-hxrust-0l44`, `TUI-LIVE-16` / `codex-hxrust-cjj4`, `TUI-LIVE-17` / `codex-hxrust-xezg`, `TUI-LIVE-18` / `codex-hxrust-0pd9`, `TUI-LIVE-19` / `codex-hxrust-a3lb`, `TUI-LIVE-20` / `codex-hxrust-lt1m`, `TUI-LIVE-21` / `codex-hxrust-183g`, `TUI-LIVE-22` / `codex-hxrust-9iys`, `TUI-LIVE-23` / `codex-hxrust-2e88`, `TUI-LIVE-24` / `codex-hxrust-it36`, `TUI-LIVE-25` / `codex-hxrust-hooe`, `TUI-LIVE-26` / `codex-hxrust-6rza`, `TUI-LIVE-27` / `codex-hxrust-notn`, `TUI-LIVE-28` / `codex-hxrust-6k41`, `TUI-LIVE-29` / `codex-hxrust-4jpd`, `TUI-LIVE-30` / `codex-hxrust-c0wj`, `TUI-LIVE-31` / `codex-hxrust-jb4r`, `TUI-LIVE-32` / `codex-hxrust-5mcs`, `TUI-LIVE-33` / `codex-hxrust-55o0`, `TUI-LIVE-34` / `codex-hxrust-4i2c`, `TUI-LIVE-35` / `codex-hxrust-fcy7`, `TUI-LIVE-36` / `codex-hxrust-vdtr`, `TUI-LIVE-37` / `codex-hxrust-ahkq`, `TUI-LIVE-38` / `codex-hxrust-h9e4`, `TUI-LIVE-39` / `codex-hxrust-swjp`, `TUI-LIVE-40` / `codex-hxrust-1cii`, `TUI-LIVE-41` / `codex-hxrust-0blg`, `TUI-LIVE-42` / `codex-hxrust-urdy`, `TUI-LIVE-43` / `codex-hxrust-pc6f`, `TUI-LIVE-44` / `codex-hxrust-cfmt`, `TUI-LIVE-45` / `codex-hxrust-tf5g`, `TUI-LIVE-46` / `codex-hxrust-85n6`, `TUI-LIVE-47` / `codex-hxrust-9dsd`, `TUI-LIVE-48` / `codex-hxrust-5qfz`, `TUI-LIVE-49` / `codex-hxrust-vued`, `TUI-LIVE-50` / `codex-hxrust-62ls`, `TUI-LIVE-51` / `codex-hxrust-qzqn`, `TUI-LIVE-52` / `codex-hxrust-z0st`, `TUI-LIVE-53` / `codex-hxrust-iwy1`, `TUI-LIVE-54` / `codex-hxrust-tmvb`, `TUI-LIVE-55` / `codex-hxrust-fet2`, `TUI-LIVE-56` / `codex-hxrust-4cp2`, `TUI-LIVE-57` / `codex-hxrust-54gu`, `TUI-LIVE-58` / `codex-hxrust-8i0f`, `TUI-LIVE-59` / `codex-hxrust-ez0a`, `TUI-LIVE-60` / `codex-hxrust-riav`, `TUI-LIVE-61` / `codex-hxrust-9oi7`, `TUI-LIVE-62` / `codex-hxrust-dgl3`

This slice moves prompt-submission response events behind a typed transport
seam. `FakeTuiAppServerFacade` still owns credential-free session/thread
validation and still defaults to fake echo behavior, but it now asks a
`TuiPromptTransport` to turn a `TuiPromptSubmitEnvelope` into queued
`TuiAppServerEvent` values.

The default `JsonRpcTuiPromptTransport` records an outbound JSON-RPC
`turn/start` request and sends it through the typed
`TuiAppServerJsonRpcTransport` contract. `FakeTuiAppServerJsonRpcTransport`
now writes the outbound request as a `TuiPromptJsonRpcFrameRecord` into a
`TuiAppServerJsonRpcWireSession`. `FakeTuiAppServerJsonRpcWireSession` keeps the
credential-free `TuiPromptJsonRpcExchange` implementation behind that
wire-facing boundary until a process/socket transport exists. The request keeps
a typed `RequestId`, typed method, and typed `turn/start` params with the active
`ThreadId` plus one text user-input entry:

`TuiAppServerJsonRpcTransportTranscript` records the outbound request plus
inbound response/stream frames at the transport boundary. `JsonRpcTuiPromptTransport`
now consumes that transcript for accepted and rejected diagnostic frame and
wire-record state instead of reconstructing transport history after the fact.
The prompt-submit gate asserts request ownership, inbound frame count, response
frame projection, disconnected outbound-only evidence, and missing-response
outbound-only evidence. Its generated Rust `frameAt` lookup is direct-indexed
so a single frame lookup does not allocate a full frame list.

`TuiAppServerJsonRpcWireOutcome` carries accepted, rejected, and disconnected
wire-session status plus typed inbound records. The fake wire session validates
that the outbound record is an outbound request line matching the request JSON,
then returns inbound response and stream records with sequence numbers starting
at `1`. The transport owns sequence `0` for the written request, while the
session owns the inbound record stream. This is still an in-process fake session;
it does not spawn or connect to a real app-server process.

`TuiAppServerJsonRpcLineTransport` sits below the wire session as the raw JSONL
read/write boundary. `FakeTuiAppServerJsonRpcLineTransport` validates the exact
outbound request line, delegates to the credential-free exchange, and returns
raw inbound JSONL lines for the response and stream notifications. The wire
session then rebuilds typed inbound records and rejects mismatches between the
typed record line and the raw line evidence. This keeps the process/socket seam
line-oriented without giving up typed diagnostics above it.

The line transport also has explicit lifecycle state. `TuiAppServerJsonRpcLineTransportState`
models open/closed, `TuiAppServerJsonRpcLineCloseReport` records the close code
and line counts, and the fake line transport rejects send attempts after close
as a disconnected outcome. This is still not a spawned app-server process; it is
the typed lifecycle contract that a process-backed transport can implement.

`TuiAppServerJsonRpcLineTranscript` records the outbound line that passed the
write boundary plus inbound raw JSONL lines. Accepted fake line outcomes carry
outbound+inbound transcript evidence, post-write rejections carry outbound-only
evidence, and pre-write or closed refusals carry an empty transcript. This gives
future process/socket transports a typed raw-line diagnostic contract without
making callers infer writes from counters.

`TuiAppServerJsonRpcLineEndpoint` types the future line transport endpoint as
either a stdio process launch plan, a TCP socket, or an explicitly unsupported
endpoint class. `TuiAppServerJsonRpcProcessLaunchPlan` owns command, argv, cwd,
and env values with copy-on-construction semantics, while
`TuiAppServerJsonRpcLineEndpointReport` validates stdio and socket readiness
without spawning a process or opening a socket. This keeps the next native
boundary out of string flags and nullable endpoint records.

`TuiAppServerJsonRpcLineOpenIntent` projects a validated endpoint into the
native boundary action a later backend must execute: spawn a stdio app-server
process, connect to a TCP socket, or refuse invalid/unsupported configuration.
`TuiAppServerJsonRpcLineOpenIntentReport` keeps that projection inspectable in
the generated-Rust gate without returning a fake transport handle or performing
live I/O.

`TuiAppServerJsonRpcLineNativeOpener` defines the typed native-open boundary and
`DryRunTuiAppServerJsonRpcLineNativeOpener` exercises it without live I/O. The
dry-run opener turns actionable stdio/socket intents into opened outcomes with
deterministic connection labels and monotonically increasing connection indices,
while invalid or unsupported intents become refused outcomes. It still returns
only typed outcome evidence, not a live process, socket, or transport handle.

`TuiAppServerJsonRpcLineTransportAttacher` and
`DryRunTuiAppServerJsonRpcLineTransportAttacher` bind opened outcomes to the
next line-transport step. The attachment value records ready/refused metadata
without storing a transport handle, so generated Rust stays diagnostic-value
shaped; the dry-run attacher materializes a fake line transport only when the
attachment is ready. The gate proves stdio and socket attachment readiness,
invalid and unsupported refusal, and a prompt line sent through the materialized
fake transport, still without spawning or connecting.

`TuiAppServerJsonRpcLineConnector` and
`DryRunTuiAppServerJsonRpcLineConnector` compose endpoint validation, open-intent
projection, native-open dry-run, attachment, and fake line transport
materialization behind one typed connector call. `TuiAppServerJsonRpcLineConnectReport`
keeps endpoint/open/attachment status together as structured evidence, while
`transportFor` materializes the fake line transport only for ready reports. This
keeps the dry-run path close to the eventual production connection pipeline
without opening a socket or spawning an app-server process.

`DryRunTuiAppServerJsonRpcLineConnectedTransport` implements the
`TuiAppServerJsonRpcTransport` contract on top of the dry-run line connector.
`JsonRpcTuiPromptTransport` can now submit through a connector-backed line
transport, preserve the connect report for diagnostics, reject invalid
endpoints before a line send, and convert accepted line outcomes back into the
same transport outcome shape used by the earlier fake transport.

The connector-backed transport now closes the materialized fake line transport
after a prompt send and exposes the `TuiAppServerJsonRpcLineCloseReport`.
Accepted sends prove outbound/inbound line counts at cleanup time, while invalid
endpoint refusals still produce no line outcome and no close report because no
transport was materialized.

The connector-backed transport can also run with a dry-run rejecting exchange
selected by a typed rejection code. This keeps the transport API value-shaped
for generated Rust while proving the post-write rejection path: the outbound
line is recorded, no inbound lines are produced, the transport outcome is
rejected with the exchange code, and the materialized line transport is still
closed with outbound/inbound counts.

`TuiAppServerJsonRpcLineTransportAttemptReport` records a scalar typed summary
for each connector-backed submit attempt: connect status/code, whether a line
transport was materialized, line outcome presence/status/code, close report
presence/state/code, and close-time line counts. The connector-backed transport
exposes the latest attempt report so future process/socket implementations can
surface one diagnostic value without making callers stitch together nullable
connect, line, and close handles.

`TuiAppServerJsonRpcLineConnector` now owns both connection reporting and line
transport materialization in its typed contract. `transportFor` returns
`Null<TuiAppServerJsonRpcLineTransport>` because failed materialization is a
modeled outcome, not an implicit trait-object default. The connector-backed
transport materializes through the interface before sending, so the prompt path
targets the same boundary a future process or socket connector must implement.
This slice exposed and fixed a generic haxe.rust trait-object null-return
lowering issue in `../haxe.rust` (`bf0a2d17`, `interface_return_null`), while
keeping codexhx source free of raw Rust, `Dynamic`, `cast`, `Any`, and smoke
imports.

`DryRunTuiAppServerJsonRpcLineConnector` now takes explicit non-null
`TuiAppServerJsonRpcLineNativeOpener` and
`TuiAppServerJsonRpcLineTransportAttacher` dependencies, with `dryRun()` as the
default factory. This keeps dry-run behavior available without baking dry-run
construction into the connector internals. The attacher interface also owns
`transportFor`, so a future stdio process or TCP socket boundary can keep open
handles behind the attachment layer and materialize the line transport there.
The generated Rust constructor shape uses non-null trait-object inputs rather
than optional interface guards, which keeps this hot connector path free of
fresh-upcast `Null Access` checks.

`TuiAppServerJsonRpcStdioLineRunner` owns the first synchronous stdio process
exchange beneath the line transport layer. It spawns a typed launch plan, writes
one outbound JSONL prompt request, closes stdin, reads stdout/stderr, waits for
the exit code, and returns a typed run report. `ProcessBackedTuiAppServerJsonRpcLineTransport`
now implements `TuiAppServerJsonRpcLineTransport` on top of that runner, so
`FakeTuiAppServerJsonRpcWireSession` can consume process-backed JSONL through
the same contract as fake line transport. `TuiPromptJsonRpcInboundLineDecoder`
strictly narrows raw inbound lines into the modeled prompt response and stream
notification DTOs; unknown methods, child failures, endpoint refusals, and
send-after-close all remain typed rejected or disconnected outcomes with raw
transcript evidence. This is still a one-shot, credential-free process boundary:
it does not own a long-lived app-server child, async reader/writer tasks, socket
transport, model calls, persistence, or tools.

`ProcessBackedTuiAppServerJsonRpcLineTransportAttacher` lets the existing typed
line connector materialize that process-backed transport from a ready stdio
attachment. The dry-run fake attacher remains the default, while tests can now
inject the process-backed attacher through `DryRunTuiAppServerJsonRpcLineConnector`
and prove accepted prompt submission plus decoder rejection through the same
connector-backed transport used by the live shell prompt path. Socket transport,
long-lived child ownership, async reader/writer tasks, credentials, model calls,
persistence, and tools remain deferred.

`TuiAppServerJsonRpcStdioSession` owns the first persistent synchronous stdio
JSONL session beneath the app-server prompt path. It lazily spawns a typed launch
plan once, writes multiple outbound prompt lines to the same child process,
flushes stdin, reads stdout JSONL incrementally for each prompt, narrows the raw
lines through `TuiPromptJsonRpcInboundLineDecoder`, and closes the child with
aggregate outbound/inbound line counts. The prompt-submit harness proves two
prompt exchanges through one shell-backed process session, cwd refusal before
spawn, unknown-method decoder rejection, send-after-close refusal, interpreter
execution, generated Cargo checks/tests, generated binary execution, and focused
generated-Rust inspection. This is still a bounded synchronous session, not the
final async app-server transport: socket transport, background reader/writer
tasks, cancellation/backpressure, credentials, model calls, persistence, and
tools remain deferred.

`PersistentStdioTuiAppServerJsonRpcLineTransportAttacher` and
`PersistentTuiAppServerJsonRpcLineConnectedTransport` lift the persistent stdio
session into the connector-backed JSON-RPC prompt path. The persistent transport
connects and materializes once, reuses the same line transport across multiple
`sendPrompt` calls, keeps per-send attempt diagnostics without closing between
sends, and exposes an explicit close report for final cleanup. The prompt-submit
harness proves two `FakeTuiAppServerFacade.submitPrompt` calls through one
shell-backed stdio session, aggregate close counts, after-close disconnection,
interpreter execution, generated Cargo checks/tests, generated binary execution,
and focused generated-Rust inspection. This is still synchronous and bounded:
background app-server pumps, sockets, cancellation/backpressure, credentials,
model calls, persistence, and tools remain deferred.

`TuiLiveShellRunRequest` can now select that connector-backed JSON-RPC line
pipeline without replacing the whole fake facade. `withJsonRpcPromptTransport`
accepts the concrete JSON-RPC prompt transport, and
`withLineConnectedPromptTransport` builds the dry-run connector-backed pipeline
from a typed line endpoint. The persistent stdio helper builds the long-lived
connector-backed prompt path from the same endpoint shape. The default live
shell remains fake and credential-free, but the generated runner gate now proves
a prompt submitted through the live shell can travel through the JSONL line
connector and still return typed close/attempt diagnostics.

`TuiLiveShellDemoConfig` now separates `line_stdio` from `process_stdio`.
`line_stdio` remains the dry-run safe mode. `process_stdio` injects
`ProcessBackedTuiAppServerJsonRpcLineTransportAttacher` through
`TuiLiveShellRunRequest.withProcessBackedLineConnectedPromptTransport()`, so the
user-runnable generated demo can submit a scripted prompt through a real
one-shot child-process JSONL responder. This still keeps the long-lived
app-server child, async stdin/stdout pumps, sockets, credentials, model calls,
persistence, and tools out of scope.

`TuiLiveShellDemoConfig` can also select `persistent_stdio` for the generated
demo. Repeated `--scripted-prompt=...` values become repeated typed key/Enter
sequences, and
`TuiLiveShellRunRequest.withPersistentStdioLineConnectedPromptTransport()` wires
the shell through the persistent connector-backed transport. The generated demo
harness proves two scripted prompt submissions through one shell-backed stdio
session and reports `transport=persistent_stdio` plus `prompts=2`. This is still
synchronous and bounded; it proves the demo can hold the persistent prompt
transport across submits before the async app-server pump exists.

The live-shell runner now owns prompt-transport shutdown as a typed contract.
`TuiPromptTransport.shutdown()` and `TuiAppServerJsonRpcTransport.shutdown()`
return `TuiPromptTransportShutdownReport`; fake transports report a no-line
shutdown, dry-run line transports surface their already-recorded one-shot close,
and persistent stdio closes the held line/session transport at runner shutdown.
`TuiLiveShellRunOutcome` records the shutdown before terminal restore, so the
generated demo can report `transportClosed=true`, persistent `lineClose=true`,
and aggregate outbound/inbound line counts after scripted prompts.

The facade also records the accepted `turn/start` response as active turn state.
`FakeTuiAppServerFacade` exposes active, last-started, and last-completed turn
IDs plus a completed-turn count. The projected `turn/completed` ready status
clears the active turn while preserving the last completed ID, giving the live
shell a typed prerequisite for a later `turn/interrupt` request path.

`TUI-LIVE-63` adds that typed `turn/interrupt` request path for the minimal
live shell. `TuiPromptTurnInterruptEnvelope`, params, request, response,
transport outcome, and facade result keep the request shape explicit instead of
reusing nullable `turn/start` fields. `FakeTuiAppServerFacade.interruptActiveTurn`
targets the current active turn, rejects idle interrupts with `no_active_turn`,
records last-interrupted turn state, clears the active turn, and deliberately
does not increment completed-turn count. The default fake JSON-RPC transport
returns an empty-result `turn/interrupt` response and projects a ready
`interrupted` status.

`TUI-LIVE-64` routes the same typed interrupt request through the persistent
stdio JSONL transport. `TuiAppServerJsonRpcStdioSession` and
`PersistentTuiAppServerJsonRpcLineConnectedTransport` now write a
`turn/interrupt` line, decode the empty-result response with request-id
correlation, surface accepted/rejected line evidence, and keep malformed or
JSON-RPC error responses fail-closed as typed codes. The one-shot dry-run line
transport still reports interrupt unsupported, and this slice still does not
own async task cancellation, socket sessions, model-provider aborts, or OS
process teardown.

```json
{
  "jsonrpc": "2.0",
  "id": 78,
  "method": "turn/start",
  "params": {
    "threadId": "00000000-0000-0000-0000-000000005556",
    "input": [{ "type": "text", "text": "json rpc ask" }]
  }
}
```

The prompt-submit harness parses that fixture-shaped request through
`AppProtocol.parseFixtureItem`, so the shell submit path is checked against the
same selected upstream `turn/start` subset as the rest of the app-protocol
gates.

Accepted fake submissions also carry a typed JSON-RPC response with a selected
upstream-shaped `TurnStartResponse` result:

```json
{
  "jsonrpc": "2.0",
  "id": 78,
  "result": {
    "turn": {
      "id": "turn-78",
      "status": "inProgress",
      "itemsView": "full",
      "items": []
    }
  }
}
```

The harness parses that response through the same app-protocol gate. The
response is recorded on `JsonRpcTuiPromptTransport` for tests and later socket
transport work; the live shell still consumes the queued fake events for its
visible behavior. `EchoTuiPromptJsonRpcExchange` remains the default fake
response exchange and preserves the prior behavior:

Accepted fake submissions also record stream-shaped app-server notifications.
The first is `thread/status/changed`, marking the thread active with the
selected upstream active flag shape:

```json
{
  "jsonrpc": "2.0",
  "method": "thread/status/changed",
  "params": {
    "status": { "activeFlags": ["turnRunning"], "type": "active" },
    "threadId": "00000000-0000-0000-0000-000000005556"
  }
}
```

The next turn-level notification is `turn/started`, with the active thread id
and the same typed turn payload as the response:

```json
{
  "jsonrpc": "2.0",
  "method": "turn/started",
  "params": {
    "threadId": "00000000-0000-0000-0000-000000005556",
    "turn": {
      "id": "turn-78",
      "status": "inProgress",
      "itemsView": "full",
      "items": []
    }
  }
}
```

After `turn/completed`, the exchange records a final `thread/status/changed`
idle notification. The projector treats both thread-status stream notifications
as shell no-ops because `turn/started` and `turn/completed` already drive the
visible working/ready status for this minimal shell:

```json
{
  "jsonrpc": "2.0",
  "method": "thread/status/changed",
  "params": {
    "status": { "type": "idle" },
    "threadId": "00000000-0000-0000-0000-000000005556"
  }
}
```

The harness parses that notification through `AppProtocol.parseFixtureItem`.
The exchange also records a matching `turn/completed` notification with the same
turn id and `completed` status, and the harness parses that notification through
the same app-protocol gate.

The exchange also emits the submitted prompt as an upstream-shaped
`item/completed` user-message notification. The projector treats it as a shell
no-op because the composer submit path already rendered the local user row:

```json
{
  "jsonrpc": "2.0",
  "method": "item/completed",
  "params": {
    "completedAtMs": 500,
    "item": {
      "id": "user-turn-78",
      "type": "userMessage",
      "content": [{ "type": "text", "text": "json rpc ask" }]
    },
    "threadId": "00000000-0000-0000-0000-000000005556",
    "turnId": "turn-78"
  }
}
```

The exchange also emits the assistant echo as an upstream-shaped
`item/agentMessage/delta` stream notification. The assistant message item is
wrapped by upstream lifecycle notifications: `item/started` before the delta and
`item/completed` after it.

```json
{
  "jsonrpc": "2.0",
  "method": "item/started",
  "params": {
    "threadId": "00000000-0000-0000-0000-000000005556",
    "turnId": "turn-78",
    "item": {
      "id": "item-78",
      "type": "agentMessage",
      "text": "echo: json rpc ask"
    },
    "startedAtMs": 1000
  }
}
```

The exchange also records the upstream raw response item completion before the
assistant app transcript item is completed. The live shell treats this as a
transport/protocol event only for now:

```json
{
  "jsonrpc": "2.0",
  "method": "rawResponseItem/completed",
  "params": {
    "item": {
      "content": [{ "text": "echo: json rpc ask", "type": "output_text" }],
      "role": "assistant",
      "type": "message"
    },
    "threadId": "00000000-0000-0000-0000-000000005556",
    "turnId": "turn-78"
  }
}
```

```json
{
  "jsonrpc": "2.0",
  "method": "item/agentMessage/delta",
  "params": {
    "threadId": "00000000-0000-0000-0000-000000005556",
    "turnId": "turn-78",
    "itemId": "item-78",
    "delta": "echo: json rpc ask"
  }
}
```

```json
{
  "jsonrpc": "2.0",
  "method": "item/completed",
  "params": {
    "threadId": "00000000-0000-0000-0000-000000005556",
    "turnId": "turn-78",
    "item": {
      "id": "item-78",
      "type": "agentMessage",
      "text": "echo: json rpc ask"
    },
    "completedAtMs": 2000
  }
}
```

`JsonRpcTuiPromptTransport` records both the turn-only notification list and the
ordered stream notification list. The stream list is represented as a typed enum
so `thread/status/changed`, `turn/*`, `item/started`,
`item/agentMessage/delta`, `item/completed`, and
`rawResponseItem/completed` payloads do not share nullable fields. The harness
parses the thread-status, started-item, delta, raw-response-item,
completed-agent-item, and completed-user-item notifications through
`AppProtocol.parseFixtureItem` and proves the shell-facing event order:

- active `thread/status/changed` as a shell no-op
- `turn/started` to working status
- user `item/completed` as a shell no-op
- `item/started` as a shell no-op
- `item/agentMessage/delta` to assistant echo delta
- `rawResponseItem/completed` as a shell no-op
- `item/completed` as a shell no-op
- `turn/completed` to ready status
- idle `thread/status/changed` as a shell no-op

This keeps the generated live demo behavior unchanged while making the prompt
transport consume the same notification objects that later socket transport can
read from the real app-server stream.

`JsonRpcTuiPromptTransport` also records an ordered typed JSON-RPC frame log:
the outbound request, the inbound response, and each inbound stream
notification in delivery order. The frame log is intentionally modeled as a
small enum instead of text trace lines, so later socket work can replace the
fake exchange with a real reader/writer while keeping request/response/stream
ordering assertions tied to typed protocol objects.

The frame log can be viewed as newline-delimited JSON-RPC wire records through
`TuiPromptJsonRpcFrameCodec` and `TuiPromptJsonRpcFrameRecord`. Each record
keeps a typed sequence number, direction, kind, and source frame, then derives
the JSON-RPC method, message JSON, and line text only at the process-transport
boundary. This mirrors the upstream app-server test-client shape, where
requests are written and notifications/responses are read as JSON-RPC lines,
without replacing typed protocol values with trace strings inside the TUI
runtime.

`TuiPromptJsonRpcFrameCorrelation` validates the outbound request id against the
inbound response id before the transport records an accepted response,
notifications, or projected shell events. Mismatched responses keep the typed
request/response frame and wire-record diagnostics, but return a typed
`response_id_mismatch` refusal and queue no fake shell events.

`TuiPromptJsonRpcStreamScopeReport` validates stream notifications against the
submitted thread and accepted turn id before those notifications are recorded
as accepted transport state or projected into shell events. A wrong-thread or
wrong-turn notification keeps typed diagnostic frames and wire records, returns
a typed refusal such as `thread_mismatch` or `turn_mismatch`, and queues no fake
shell events.

`FakeTuiAppServerFacade` now registers prompt submits in the same typed pending
map used by session attach. `TuiPromptPendingRequestLifecycle` records the
prompt request moving through register and synchronous resolve/reject, so
accepted, rejected, stale-response, and out-of-scope stream paths all prove the
facade leaves no stranded prompt request after transport completion.

`TuiPromptTurnLifecycleReport` records whether the accepted stream for the
selected turn includes both `turn/started` and `turn/completed`. Missing either
side of that lifecycle returns a typed refusal such as `missing_started` or
`missing_completed` before response state is marked accepted or shell events
are queued.

`TuiAppServerJsonRpcTransportOutcome` is the first app-server transport-level
result shape for prompt requests. It carries accepted responses, stream
notifications, shell events, typed rejection codes, and disconnect outcomes
without requiring ChatWidget or terminal-loop code to know whether the source
was an in-process fake exchange or a future real transport. The prompt-submit
gate covers disconnect-before-response and accepted-with-missing-response paths
as typed refusals with no queued shell events.

Tests can inject another transport to prove refusal behavior. A rejected
transport preserves the prompt envelope and request-registration effects, but
does not enqueue fake assistant/status events.

Tests can also inject a rejecting JSON-RPC exchange. That path records the
outbound request, its request frame, and its outbound wire record, records no
response or stream frames, returns a typed transport rejection, and queues no
fake events.

Validation:

```bash
bash harness/check-tui-prompt-submit-envelope.sh
```

This is still not app-server socket ownership, credentialed model traffic, tool
execution, or persistent state. It is the shell-facing JSON-RPC
request/response/notification-to-event seam those later transports can
implement without changing ChatWidget or terminal-loop code.
