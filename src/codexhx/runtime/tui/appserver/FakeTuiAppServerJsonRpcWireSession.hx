package codexhx.runtime.tui.appserver;

/**
	Credential-free app-server wire session backed by the fake prompt exchange.
**/
class FakeTuiAppServerJsonRpcWireSession implements TuiAppServerJsonRpcWireSession {
	final exchange:TuiPromptJsonRpcExchange;

	public function new(?exchange:TuiPromptJsonRpcExchange) {
		this.exchange = exchange == null ? new EchoTuiPromptJsonRpcExchange() : exchange;
	}

	public function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope,
			outboundRecord:TuiPromptJsonRpcFrameRecord):TuiAppServerJsonRpcWireOutcome {
		if (request == null)
			return TuiAppServerJsonRpcWireOutcome.rejected("missing_request");
		if (outboundRecord == null)
			return TuiAppServerJsonRpcWireOutcome.rejected("missing_outbound_record");
		if (outboundRecord.direction != TuiPromptJsonRpcFrameDirection.Outbound)
			return TuiAppServerJsonRpcWireOutcome.rejected("invalid_outbound_direction");
		if (outboundRecord.kind != TuiPromptJsonRpcFrameKind.Request)
			return TuiAppServerJsonRpcWireOutcome.rejected("invalid_outbound_kind");
		if (!matchesRequest(outboundRecord.frame, request))
			return TuiAppServerJsonRpcWireOutcome.rejected("mismatched_outbound_request");
		if (outboundRecord.lineText() != request.messageJson() + "\n")
			return TuiAppServerJsonRpcWireOutcome.rejected("mismatched_outbound_line");
		if (envelope == null)
			return TuiAppServerJsonRpcWireOutcome.rejected("missing_envelope");
		final outcome = exchange.send(request, envelope);
		if (outcome == null)
			return TuiAppServerJsonRpcWireOutcome.rejected("missing_exchange_outcome");
		if (!outcome.isAccepted())
			return TuiAppServerJsonRpcWireOutcome.rejected(outcome.code());
		final inboundFrames = inboundFramesFromOutcome(outcome);
		return TuiAppServerJsonRpcWireOutcome.accepted(outcome.response(), outcome.notifications(), outcome.streamNotifications(), outcome.events(),
			TuiPromptJsonRpcFrameCodec.recordsFrom(1, inboundFrames));
	}

	static function matchesRequest(frame:TuiPromptJsonRpcFrame, request:TuiPromptJsonRpcRequest):Bool {
		final recorded = switch frame {
			case TuiPromptJsonRpcFrame.Request(recorded):
				recorded;
			case _:
				null;
		};
		if (recorded == null)
			return false;
		return recorded.messageJson() == request.messageJson();
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
}
