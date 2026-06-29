# TUI Prompt Submit Envelope

**Bead:** `TUI-LIVE-7` / `codex-hxrust-mvwx`

## Purpose

This slice wires Enter in the minimal live composer into a typed fake app-server request envelope. The flow remains credential-free: typed input updates the composer, submit drains the input buffer into `TuiPromptSubmitEnvelope`, the fake app-server queues a deterministic echo, and the event pump renders the updated shell.

## Shape

- `TuiPromptSubmitEnvelope` carries `RequestId`, `SessionId`, `ThreadId`, and prompt text.
- `TuiPromptSubmitStatus` distinguishes accepted, empty prompt, missing session, and missing thread states.
- `TuiPromptSubmitResult` records prompt admission without string summaries or opaque payloads.
- `TuiPromptSubmitInteraction` combines shell input effects, prompt admission, app-server event drain, and terminal draw outcome.
- `TuiAppServerEventPump.submitComposerInput()` is the typed bridge from `TerminalInputEvent` to app-server prompt submission and redraw.

The fake app-server responds with status `submitted`, an assistant delta `echo: <prompt>`, then status `ready`. No model provider, credential, socket, or persistence boundary is touched.

## Gate

Run:

```bash
bash harness/check-tui-prompt-submit-envelope.sh
```

The gate asserts typed text entry, prompt submit envelope fields, deterministic fake echo, redraw coalescing, empty submit refusal, unattached submit refusal, headless backend draw state, live backend draw/restore behavior, metal haxe.rust generation, and generated Cargo check/test/run.

## Still Not Proven

This is not a real app-server transport, model turn, tool execution, persistence write, streaming model response, or full upstream ChatWidget submit lifecycle. The next production-shaped live step is promoting shared agent navigation state out of the smoke package while keeping the live shell path focused.
