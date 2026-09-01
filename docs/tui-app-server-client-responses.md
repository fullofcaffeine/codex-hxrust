# TUI App-Server Client Responses

The TUI can now answer a request that the app-server sends to the client.
Before this change, the session returned `server_request_response_unsupported` and sent no bytes.

The response path has three steps:

1. `TuiAppServerSession` receives a typed request ID and result or error.
2. `TuiAppServerClientTransport` creates the protocol response.
3. The persistent line transport writes one JSON line on its existing connection.

The prompt transport remains prompt-only. A persistent transport object implements both narrow contracts, so both operations use one connection.

## Wire format

Current upstream Codex responses do not include a `jsonrpc` member. A successful response has this form:

```json
{"id":"server-request-1","result":{"answer":"yes"}}
```

An error response has this form:

```json
{"error":{"code":-32000,"message":"cannot handle"},"id":7}
```

`TuiAppServerJsonRpcError` owns the error code, message, and optional data value. App code cannot construct error fields by string lookup.

## Upstream anchors

The clean mainstream reference checkout is `../codex-upstream-reference` at `b8c86376a258e55efc8e5ecfbabc21c16c07d814`.

- `codex-rs/tui/src/app_server_session.rs` delegates both response operations to the app-server client.
- `codex-rs/app-server-client/src/remote.rs` writes `JSONRPCResponse` or `JSONRPCError` on the existing connection.
- `codex-rs/app-server-protocol/src/rpc.rs` defines the request ID and error shapes.

The requested `../codex-vanilla` path is not present in this workspace. The clean reference checkout supplies the mainstream comparison.

## Compiler pressure

This response fixture exposed a general haxe.rust `Debug`-derive problem. A generated class could contain another generated class that stores a trait object. The outer class still derived `Debug`, so Rust rejected the nested field even though the inner class correctly omitted that derive.

[haxe.rust PR #17](https://github.com/fullofcaffeine/reflaxe.rust/pull/17) fixes the compiler-wide analysis. It landed as `b4975cb3bc0039cfabf498e455cbab4e36de58de`. The unchanged session contract passed against a clean worktree at that exact merge commit. Portable and metal generated-Cargo admission also passed before this repository updated its compiler pin.

The fix is generic. It follows generated class dependencies and does not contain Codex-specific names, paths, or behavior.

## Gate

Run this command:

```sh
npm run test:tui-app-server-session-contract
```

The contract covers success, missing typed input, a disconnected transport, and a response after shutdown. It preserves string and integer request IDs.

## Limits

The deterministic gate does not receive a live server request. It proves response encoding and transport ownership with a credential-free persistent connection.

A later slice must connect inbound server requests to the active TUI action handlers. Live provider work and production socket ownership also remain separate.
