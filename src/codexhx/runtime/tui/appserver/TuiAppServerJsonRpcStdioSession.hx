package codexhx.runtime.tui.appserver;

import sys.io.Process;

/**
	Persistent stdio session for app-server JSON-RPC line traffic.

	Why
	- The live TUI needs a process-backed app-server boundary that can survive
	  more than one prompt exchange. The one-shot line runner is useful proof,
	  but a real TUI keeps a session attached while events flow.

	What
	- Spawns a typed stdio launch plan lazily.
	- Writes one outbound prompt JSONL line per call.
	- Reads stdout JSONL incrementally until the decoder can produce the typed
	  response/stream outcome for that prompt.
	- Closes the child process explicitly and reports aggregate line counts.

	How
	- Keeps JSON as raw line evidence only at the boundary; prompt data narrows
	  through `TuiPromptJsonRpcInboundLineDecoder` before app-facing code reads it.
	- Refuses cwd/env plans for now, matching the current stdio runner contract.
**/
class TuiAppServerJsonRpcStdioSession implements TuiAppServerJsonRpcLineTransport {
	final plan:TuiAppServerJsonRpcProcessLaunchPlan;
	final decoder:TuiPromptJsonRpcInboundLineDecoder;
	final interruptDecoder:TuiPromptTurnInterruptInboundLineDecoder;
	final maxInboundLinesPerPrompt:Int;

	var state:TuiAppServerJsonRpcLineTransportState;
	var process:Null<Process>;
	var outboundLines:Int;
	var inboundLines:Int;

	public function new(plan:TuiAppServerJsonRpcProcessLaunchPlan, maxInboundLinesPerPrompt:Int, decoder:TuiPromptJsonRpcInboundLineDecoder) {
		this.plan = plan;
		this.decoder = decoder;
		this.interruptDecoder = new TuiPromptTurnInterruptInboundLineDecoder();
		this.maxInboundLinesPerPrompt = maxInboundLinesPerPrompt <= 0 ? 64 : maxInboundLinesPerPrompt;
		this.state = TuiAppServerJsonRpcLineTransportState.Open;
		this.process = null;
		this.outboundLines = 0;
		this.inboundLines = 0;
	}

	public static function withDefaultDecoder(plan:TuiAppServerJsonRpcProcessLaunchPlan, maxInboundLinesPerPrompt:Int):TuiAppServerJsonRpcStdioSession {
		return new TuiAppServerJsonRpcStdioSession(plan, maxInboundLinesPerPrompt, new TuiPromptJsonRpcInboundLineDecoder());
	}

	public function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome {
		if (!isOpen())
			return TuiAppServerJsonRpcLineOutcome.disconnected("line_transport_closed", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (request == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_request", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (outboundLine == null || outboundLine.length == 0)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (outboundLine != request.messageJson() + "\n")
			return TuiAppServerJsonRpcLineOutcome.rejected("mismatched_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (envelope == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_envelope", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));

		final refusal = refusalCode();
		if (refusal.length > 0)
			return TuiAppServerJsonRpcLineOutcome.rejected(refusal, [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));

		final started = ensureStarted();
		if (started.length > 0)
			return TuiAppServerJsonRpcLineOutcome.disconnected(started, [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));

		final active = process;
		if (active == null)
			return TuiAppServerJsonRpcLineOutcome.disconnected("missing_stdio_process", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));

		try {
			active.stdin.writeString(outboundLine);
			active.stdin.flush();
			outboundLines = outboundLines + 1;
		} catch (e:haxe.Exception) {
			return TuiAppServerJsonRpcLineOutcome.disconnected("stdio_write_failed", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));
		}

		final inbound:Array<String> = [];
		var lastRejection = "missing_inbound_lines";
		for (_ in 0...maxInboundLinesPerPrompt) {
			final line = readInboundLine(active);
			if (!line.ok)
				return TuiAppServerJsonRpcLineOutcome.disconnected(line.code, inbound, TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
			inbound.push(line.value);
			inboundLines = inboundLines + 1;
			final decoded = decoder.decode(request, inbound);
			if (decoded == null)
				return TuiAppServerJsonRpcLineOutcome.rejected("missing_inbound_decode", inbound,
					TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
			if (decoded.isAccepted() && (promptExchangeComplete(decoded) || inbound.length >= maxInboundLinesPerPrompt))
				return TuiAppServerJsonRpcLineOutcome.accepted(decoded.response(), decoded.notifications(), decoded.streamNotifications(), decoded.events(),
					inbound, TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
			if (!decoded.isAccepted()) {
				lastRejection = decoded.code();
				if (isTerminalDecodeRejection(lastRejection))
					return TuiAppServerJsonRpcLineOutcome.rejected(lastRejection, inbound, TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
			}
			if (decoded.isAccepted())
				lastRejection = "incomplete_prompt_exchange";
		}
		return TuiAppServerJsonRpcLineOutcome.rejected(lastRejection == "" ? "inbound_limit_exceeded" : lastRejection, inbound,
			TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
	}

	public function sendInterruptLine(request:TuiPromptTurnInterruptRequest, envelope:TuiPromptTurnInterruptEnvelope,
			outboundLine:String):TuiPromptTurnInterruptLineOutcome {
		if (!isOpen())
			return TuiPromptTurnInterruptLineOutcome.disconnected("line_transport_closed", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (request == null)
			return TuiPromptTurnInterruptLineOutcome.rejected("missing_request", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (outboundLine == null || outboundLine.length == 0)
			return TuiPromptTurnInterruptLineOutcome.rejected("missing_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (outboundLine != request.messageJson() + "\n")
			return TuiPromptTurnInterruptLineOutcome.rejected("mismatched_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (envelope == null)
			return TuiPromptTurnInterruptLineOutcome.rejected("missing_envelope", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));

		final refusal = refusalCode();
		if (refusal.length > 0)
			return TuiPromptTurnInterruptLineOutcome.rejected(refusal, [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));

		final started = ensureStarted();
		if (started.length > 0)
			return TuiPromptTurnInterruptLineOutcome.disconnected(started, [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));

		final active = process;
		if (active == null)
			return TuiPromptTurnInterruptLineOutcome.disconnected("missing_stdio_process", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));

		try {
			active.stdin.writeString(outboundLine);
			active.stdin.flush();
			outboundLines = outboundLines + 1;
		} catch (e:haxe.Exception) {
			return TuiPromptTurnInterruptLineOutcome.disconnected("stdio_write_failed", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));
		}

		final inbound:Array<String> = [];
		var lastRejection = "missing_inbound_lines";
		for (_ in 0...maxInboundLinesPerPrompt) {
			final line = readInboundLine(active);
			if (!line.ok)
				return TuiPromptTurnInterruptLineOutcome.disconnected(line.code, inbound, TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
			inbound.push(line.value);
			inboundLines = inboundLines + 1;
			final decoded = interruptDecoder.decode(request, inbound);
			if (decoded == null)
				return TuiPromptTurnInterruptLineOutcome.rejected("missing_inbound_decode", inbound,
					TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
			if (decoded.isAccepted())
				return TuiPromptTurnInterruptLineOutcome.accepted(decoded.response(), decoded.events(), inbound,
					TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
			lastRejection = decoded.code();
			if (isTerminalDecodeRejection(lastRejection))
				return TuiPromptTurnInterruptLineOutcome.rejected(lastRejection, inbound, TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
		}
		return TuiPromptTurnInterruptLineOutcome.rejected(lastRejection == "" ? "inbound_limit_exceeded" : lastRejection, inbound,
			TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
	}

	public function readLateJsonlBatchLines(maxLines:Int):TuiAppServerJsonRpcLateJsonlBatch {
		if (!isOpen())
			return TuiAppServerJsonRpcLateJsonlBatch.disconnected("line_transport_closed", []);
		if (maxLines <= 0)
			return TuiAppServerJsonRpcLateJsonlBatch.rejected("invalid_late_jsonl_batch_line_count");
		final refusal = refusalCode();
		if (refusal.length > 0)
			return TuiAppServerJsonRpcLateJsonlBatch.rejected(refusal);
		final started = ensureStarted();
		if (started.length > 0)
			return TuiAppServerJsonRpcLateJsonlBatch.disconnected(started, []);
		final active = process;
		if (active == null)
			return TuiAppServerJsonRpcLateJsonlBatch.disconnected("missing_stdio_process", []);

		final lines:Array<String> = [];
		for (_ in 0...maxLines) {
			final line = readInboundLine(active);
			if (!line.ok)
				return TuiAppServerJsonRpcLateJsonlBatch.disconnected(line.code, lines);
			lines.push(line.value);
			inboundLines = inboundLines + 1;
		}
		return TuiAppServerJsonRpcLateJsonlBatch.accepted(lines);
	}

	public function isOpen():Bool {
		return state == TuiAppServerJsonRpcLineTransportState.Open;
	}

	public function stateText():String {
		return state.text();
	}

	public function close(code:String):TuiAppServerJsonRpcLineCloseReport {
		if (state == TuiAppServerJsonRpcLineTransportState.Closed)
			return TuiAppServerJsonRpcLineCloseReport.closed(code, outboundLines, inboundLines);
		state = TuiAppServerJsonRpcLineTransportState.Closed;
		final active = process;
		process = null;
		if (active != null) {
			try {
				active.stdin.close();
			} catch (e:haxe.Exception) {}
			try {
				active.close();
			} catch (e:haxe.Exception) {}
		}
		return TuiAppServerJsonRpcLineCloseReport.closed(code, outboundLines, inboundLines);
	}

	public function outboundLineCount():Int {
		return outboundLines;
	}

	public function inboundLineCount():Int {
		return inboundLines;
	}

	public function maxInboundLineCountPerPrompt():Int {
		return maxInboundLinesPerPrompt;
	}

	function ensureStarted():String {
		if (process != null)
			return "";
		try {
			process = new Process(plan.command, plan.args());
			return "";
		} catch (e:haxe.Exception) {
			return "spawn_failed";
		}
	}

	function refusalCode():String {
		if (plan == null)
			return "missing_launch_plan";
		final validationCode = plan.validationCode();
		if (validationCode != "ready")
			return validationCode;
		if (plan.cwd.length > 0)
			return "stdio_cwd_unsupported";
		if (plan.envCount() > 0)
			return "stdio_env_unsupported";
		return "";
	}

	static function readInboundLine(active:Process):StdioLineRead {
		try {
			return StdioLineRead.succeeded(normalizeNewlines(active.stdout.readLine()) + "\n");
		} catch (e:haxe.io.Eof) {
			return StdioLineRead.failed("stdio_eof");
		} catch (e:haxe.Exception) {
			return StdioLineRead.failed("stdio_read_failed");
		}
	}

	static function normalizeNewlines(text:String):String {
		if (text == null)
			return "";
		return StringTools.replace(StringTools.replace(text, "\r\n", "\n"), "\r", "\n");
	}

	static function isTerminalDecodeRejection(code:String):Bool {
		return code != "missing_response";
	}

	static function promptExchangeComplete(decoded:TuiPromptJsonRpcInboundLineDecodeOutcome):Bool {
		var sawTurnCompleted = false;
		for (notification in decoded.notifications()) {
			if (notification.methodText() == TuiPromptJsonRpcNotificationMethod.TurnCompleted.text())
				sawTurnCompleted = true;
		}
		var sawIdle = false;
		for (notification in decoded.streamNotifications()) {
			switch notification {
				case TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(status):
					switch status.status {
						case Ready(_):
							sawIdle = true;
						case Working(_) | Failed(_):
					}
				case _:
			}
		}
		return sawTurnCompleted && sawIdle;
	}
}

class StdioLineRead {
	public final ok:Bool;
	public final code:String;
	public final value:String;

	public function new(ok:Bool, code:String, value:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.value = value == null ? "" : value;
	}

	public static function succeeded(value:String):StdioLineRead {
		return new StdioLineRead(true, "ok", value);
	}

	public static function failed(code:String):StdioLineRead {
		return new StdioLineRead(false, code, "");
	}
}
