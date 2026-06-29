# TUI Live Prompt Transport

**Beads:** `TUI-LIVE-13` / `codex-hxrust-0gms`, `TUI-LIVE-14` / `codex-hxrust-og2d`, `TUI-LIVE-15` / `codex-hxrust-0l44`, `TUI-LIVE-16` / `codex-hxrust-cjj4`, `TUI-LIVE-17` / `codex-hxrust-xezg`

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

Accepted fake submissions also record the first stream-shaped app-server
notification, `turn/started`, with the active thread id and the same typed turn
payload as the response:

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

The harness parses that notification through `AppProtocol.parseFixtureItem`.
The live shell still consumes the existing queued fake events for visible
behavior:

- working status
- assistant echo delta
- ready status

Tests can inject another transport to prove refusal behavior. A rejected
transport preserves the prompt envelope and request-registration effects, but
does not enqueue fake assistant/status events.

Tests can also inject a rejecting JSON-RPC exchange. That path records the
outbound request, records no response, returns a typed transport rejection, and
queues no fake events.

Validation:

```bash
bash harness/check-tui-prompt-submit-envelope.sh
```

This is still not app-server socket ownership, credentialed model traffic, tool
execution, or persistent state. It is the shell-facing JSON-RPC
request/response/notification seam those later transports can implement without
changing ChatWidget or terminal-loop code.
