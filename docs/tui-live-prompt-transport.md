# TUI Live Prompt Transport

**Beads:** `TUI-LIVE-13` / `codex-hxrust-0gms`, `TUI-LIVE-14` / `codex-hxrust-og2d`, `TUI-LIVE-15` / `codex-hxrust-0l44`, `TUI-LIVE-16` / `codex-hxrust-cjj4`, `TUI-LIVE-17` / `codex-hxrust-xezg`, `TUI-LIVE-18` / `codex-hxrust-0pd9`, `TUI-LIVE-19` / `codex-hxrust-a3lb`, `TUI-LIVE-20` / `codex-hxrust-lt1m`, `TUI-LIVE-21` / `codex-hxrust-183g`, `TUI-LIVE-22` / `codex-hxrust-9iys`, `TUI-LIVE-23` / `codex-hxrust-2e88`, `TUI-LIVE-24` / `codex-hxrust-it36`, `TUI-LIVE-25` / `codex-hxrust-hooe`, `TUI-LIVE-26` / `codex-hxrust-6rza`

This slice moves prompt-submission response events behind a typed transport
seam. `FakeTuiAppServerFacade` still owns credential-free session/thread
validation and still defaults to fake echo behavior, but it now asks a
`TuiPromptTransport` to turn a `TuiPromptSubmitEnvelope` into queued
`TuiAppServerEvent` values.

The default `JsonRpcTuiPromptTransport` records an outbound JSON-RPC
`turn/start` request and sends it through a credential-free
`TuiPromptJsonRpcExchange`. The request keeps a typed `RequestId`, typed method,
and typed `turn/start` params with the active `ThreadId` plus one text
user-input entry:

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

Tests can inject another transport to prove refusal behavior. A rejected
transport preserves the prompt envelope and request-registration effects, but
does not enqueue fake assistant/status events.

Tests can also inject a rejecting JSON-RPC exchange. That path records the
outbound request and its request frame, records no response or stream frames,
returns a typed transport rejection, and queues no fake events.

Validation:

```bash
bash harness/check-tui-prompt-submit-envelope.sh
```

This is still not app-server socket ownership, credentialed model traffic, tool
execution, or persistent state. It is the shell-facing JSON-RPC
request/response/notification-to-event seam those later transports can
implement without changing ChatWidget or terminal-loop code.
