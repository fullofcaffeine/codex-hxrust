package codexhx.runtime.tui.appserver;

/**
	Process-backed app-server JSON-RPC line transport for one prompt exchange.

	Why
	- The live TUI needs the existing wire/session prompt path to consume real
	  stdio process output, not only fake in-process exchange output.

	What
	- Implements `TuiAppServerJsonRpcLineTransport` by running a typed stdio
	  launch plan, writing the outbound prompt JSONL line, reading stdout JSONL,
	  and decoding the currently modeled prompt response/stream subset.

	How
	- Uses `TuiAppServerJsonRpcStdioLineRunner` for process ownership.
	- Uses `TuiPromptJsonRpcInboundLineDecoder` for strict typed JSON-RPC
	  narrowing before app-facing transport outcomes are produced.
**/
class ProcessBackedTuiAppServerJsonRpcLineTransport implements TuiAppServerJsonRpcLineTransport {
	final plan:TuiAppServerJsonRpcProcessLaunchPlan;
	final runner:TuiAppServerJsonRpcStdioLineRunner;
	final decoder:TuiPromptJsonRpcInboundLineDecoder;
	final interruptDecoder:TuiPromptTurnInterruptInboundLineDecoder;

	var state:TuiAppServerJsonRpcLineTransportState;
	var outboundLines:Int;
	var inboundLines:Int;
	var lastRunReportValue:TuiAppServerJsonRpcStdioLineRunReport;

	public function new(plan:TuiAppServerJsonRpcProcessLaunchPlan, ?runner:TuiAppServerJsonRpcStdioLineRunner, ?decoder:TuiPromptJsonRpcInboundLineDecoder) {
		this.plan = plan;
		this.runner = runner == null ? new TuiAppServerJsonRpcStdioLineRunner() : runner;
		this.decoder = decoder == null ? new TuiPromptJsonRpcInboundLineDecoder() : decoder;
		this.interruptDecoder = new TuiPromptTurnInterruptInboundLineDecoder();
		this.state = TuiAppServerJsonRpcLineTransportState.Open;
		this.outboundLines = 0;
		this.inboundLines = 0;
		this.lastRunReportValue = null;
	}

	public function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome {
		lastRunReportValue = null;
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

		final report = runner.run(plan, outboundLine);
		lastRunReportValue = report;
		if (report == null)
			return TuiAppServerJsonRpcLineOutcome.disconnected("missing_stdio_run_report", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));
		outboundLines = outboundLines + report.outboundLineCount();
		inboundLines = inboundLines + report.inboundLineCount();
		if (report.status == TuiAppServerJsonRpcStdioLineRunStatus.Rejected)
			return TuiAppServerJsonRpcLineOutcome.rejected(report.code, report.transcript().inboundLines(), report.transcript());
		if (report.status == TuiAppServerJsonRpcStdioLineRunStatus.Failed)
			return TuiAppServerJsonRpcLineOutcome.disconnected(report.code, report.transcript().inboundLines(), report.transcript());

		final decoded = decoder.decode(request, report.transcript().inboundLines());
		if (decoded == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_inbound_decode", report.transcript().inboundLines(), report.transcript());
		if (!decoded.isAccepted())
			return TuiAppServerJsonRpcLineOutcome.rejected(decoded.code(), report.transcript().inboundLines(), report.transcript());
		return TuiAppServerJsonRpcLineOutcome.accepted(decoded.response(), decoded.notifications(), decoded.streamNotifications(), decoded.events(),
			report.transcript().inboundLines(), report.transcript());
	}

	public function sendInterruptLine(request:TuiPromptTurnInterruptRequest, envelope:TuiPromptTurnInterruptEnvelope,
			outboundLine:String):TuiPromptTurnInterruptLineOutcome {
		lastRunReportValue = null;
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

		final report = runner.run(plan, outboundLine);
		lastRunReportValue = report;
		if (report == null)
			return TuiPromptTurnInterruptLineOutcome.disconnected("missing_stdio_run_report", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));
		outboundLines = outboundLines + report.outboundLineCount();
		inboundLines = inboundLines + report.inboundLineCount();
		if (report.status == TuiAppServerJsonRpcStdioLineRunStatus.Rejected)
			return TuiPromptTurnInterruptLineOutcome.rejected(report.code, report.transcript().inboundLines(), report.transcript());
		if (report.status == TuiAppServerJsonRpcStdioLineRunStatus.Failed)
			return TuiPromptTurnInterruptLineOutcome.disconnected(report.code, report.transcript().inboundLines(), report.transcript());

		final decoded = interruptDecoder.decode(request, report.transcript().inboundLines());
		if (decoded == null)
			return TuiPromptTurnInterruptLineOutcome.rejected("missing_inbound_decode", report.transcript().inboundLines(), report.transcript());
		if (!decoded.isAccepted())
			return TuiPromptTurnInterruptLineOutcome.rejected(decoded.code(), report.transcript().inboundLines(), report.transcript());
		return TuiPromptTurnInterruptLineOutcome.accepted(decoded.response(), decoded.events(), report.transcript().inboundLines(), report.transcript());
	}

	public function readLateJsonlBatchLines(_maxLines:Int):TuiAppServerJsonRpcLateJsonlBatch {
		if (!isOpen())
			return TuiAppServerJsonRpcLateJsonlBatch.disconnected("line_transport_closed", []);
		return TuiAppServerJsonRpcLateJsonlBatch.rejected("late_jsonl_read_unsupported");
	}

	public function isOpen():Bool {
		return state == TuiAppServerJsonRpcLineTransportState.Open;
	}

	public function stateText():String {
		return state.text();
	}

	public function close(code:String):TuiAppServerJsonRpcLineCloseReport {
		state = TuiAppServerJsonRpcLineTransportState.Closed;
		return TuiAppServerJsonRpcLineCloseReport.closed(code, outboundLines, inboundLines);
	}

	public function outboundLineCount():Int {
		return outboundLines;
	}

	public function inboundLineCount():Int {
		return inboundLines;
	}

	public function lastRunReport():TuiAppServerJsonRpcStdioLineRunReport {
		return lastRunReportValue;
	}
}
