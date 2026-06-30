package codexhx.runtime.tui.appserver;

/**
	Credential-free app-server wire session backed by a fake line transport.
**/
class FakeTuiAppServerJsonRpcWireSession implements TuiAppServerJsonRpcWireSession {
	final lineTransport:TuiAppServerJsonRpcLineTransport;

	public function new(?exchange:TuiPromptJsonRpcExchange, ?lineTransport:TuiAppServerJsonRpcLineTransport) {
		this.lineTransport = lineTransport == null ? new FakeTuiAppServerJsonRpcLineTransport(exchange) : lineTransport;
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
		final outcome = lineTransport.sendPromptLine(request, envelope, outboundRecord.lineText());
		if (outcome == null)
			return TuiAppServerJsonRpcWireOutcome.rejected("missing_line_outcome");
		if (!outcome.isAccepted())
			return TuiAppServerJsonRpcWireOutcome.rejected(outcome.code());
		final inboundFrames = inboundFramesFromLineOutcome(outcome);
		final inboundRecords = TuiPromptJsonRpcFrameCodec.recordsFrom(1, inboundFrames);
		final lineCheck = validateInboundLines(inboundRecords, outcome.inboundLines());
		if (lineCheck.length > 0)
			return TuiAppServerJsonRpcWireOutcome.rejected(lineCheck, inboundRecords);
		return TuiAppServerJsonRpcWireOutcome.accepted(outcome.response(), outcome.notifications(), outcome.streamNotifications(), outcome.events(),
			inboundRecords);
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

	static function inboundFramesFromLineOutcome(outcome:TuiAppServerJsonRpcLineOutcome):Array<TuiPromptJsonRpcFrame> {
		final frames:Array<TuiPromptJsonRpcFrame> = [];
		final response = outcome.response();
		if (response != null)
			frames.push(TuiPromptJsonRpcFrame.Response(response));
		for (notification in outcome.streamNotifications())
			frames.push(TuiPromptJsonRpcFrame.StreamNotification(notification));
		return frames;
	}

	static function validateInboundLines(records:Array<TuiPromptJsonRpcFrameRecord>, lines:Array<String>):String {
		if (lines == null)
			return records.length == 0 ? "" : "missing_inbound_lines";
		if (records.length != lines.length)
			return "inbound_line_count_mismatch";
		var index = 0;
		while (index < records.length) {
			if (records[index].lineText() != lines[index])
				return "mismatched_inbound_line";
			index = index + 1;
		}
		return "";
	}
}
