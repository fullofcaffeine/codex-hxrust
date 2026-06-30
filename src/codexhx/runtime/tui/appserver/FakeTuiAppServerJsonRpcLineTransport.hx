package codexhx.runtime.tui.appserver;

/**
	Credential-free line transport backed by the fake prompt exchange.
**/
class FakeTuiAppServerJsonRpcLineTransport implements TuiAppServerJsonRpcLineTransport {
	final exchange:TuiPromptJsonRpcExchange;

	public function new(?exchange:TuiPromptJsonRpcExchange) {
		this.exchange = exchange == null ? new EchoTuiPromptJsonRpcExchange() : exchange;
	}

	public function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome {
		if (request == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_request");
		if (outboundLine.length == 0)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_outbound_line");
		if (outboundLine != request.messageJson() + "\n")
			return TuiAppServerJsonRpcLineOutcome.rejected("mismatched_outbound_line");
		if (envelope == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_envelope");
		final outcome = exchange.send(request, envelope);
		if (outcome == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_exchange_outcome");
		if (!outcome.isAccepted())
			return TuiAppServerJsonRpcLineOutcome.rejected(outcome.code());
		final inboundFrames = inboundFramesFromOutcome(outcome);
		return TuiAppServerJsonRpcLineOutcome.accepted(outcome.response(), outcome.notifications(), outcome.streamNotifications(), outcome.events(),
			linesFromFrames(inboundFrames));
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
