package codexhx.runtime.tui.appserver;

/**
	Credential-free line transport backed by the fake prompt exchange.
**/
class FakeTuiAppServerJsonRpcLineTransport implements TuiAppServerJsonRpcLineTransport {
	final exchange:TuiPromptJsonRpcExchange;
	var state:TuiAppServerJsonRpcLineTransportState;
	var outboundLines:Int;
	var inboundLines:Int;

	public function new(?exchange:TuiPromptJsonRpcExchange) {
		this.exchange = exchange == null ? new EchoTuiPromptJsonRpcExchange() : exchange;
		this.state = TuiAppServerJsonRpcLineTransportState.Open;
		this.outboundLines = 0;
		this.inboundLines = 0;
	}

	public function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome {
		if (!isOpen())
			return TuiAppServerJsonRpcLineOutcome.disconnected("line_transport_closed", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (request == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_request", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (outboundLine.length == 0)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (outboundLine != request.messageJson() + "\n")
			return TuiAppServerJsonRpcLineOutcome.rejected("mismatched_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		final outboundTranscript = TuiAppServerJsonRpcLineTranscript.outbound(outboundLine);
		outboundLines = outboundLines + 1;
		if (envelope == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_envelope", [], outboundTranscript);
		final outcome = exchange.send(request, envelope);
		if (outcome == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_exchange_outcome", [], outboundTranscript);
		if (!outcome.isAccepted())
			return TuiAppServerJsonRpcLineOutcome.rejected(outcome.code(), [], outboundTranscript);
		final inboundFrames = inboundFramesFromOutcome(outcome);
		final lines = linesFromFrames(inboundFrames);
		inboundLines = inboundLines + lines.length;
		return TuiAppServerJsonRpcLineOutcome.accepted(outcome.response(), outcome.notifications(), outcome.streamNotifications(), outcome.events(), lines,
			TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, lines));
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

	static function inboundFramesFromOutcome(outcome:TuiPromptJsonRpcExchangeOutcome):Array<TuiPromptJsonRpcFrame> {
		final frames:Array<TuiPromptJsonRpcFrame> = [];
		final response = outcome.response();
		if (response != null)
			frames.push(TuiPromptJsonRpcFrame.Response(response));
		for (notification in outcome.streamNotifications())
			frames.push(TuiPromptJsonRpcFrame.StreamNotification(notification));
		return frames;
	}

	static function linesFromFrames(frames:Array<TuiPromptJsonRpcFrame>):Array<String> {
		final lines:Array<String> = [];
		for (record in TuiPromptJsonRpcFrameCodec.recordsFrom(1, frames))
			lines.push(record.lineText());
		return lines;
	}
}
