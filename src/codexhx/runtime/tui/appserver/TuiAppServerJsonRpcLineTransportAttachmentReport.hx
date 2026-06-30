package codexhx.runtime.tui.appserver;

/**
	Structured diagnostics for app-server line transport attachment.
**/
class TuiAppServerJsonRpcLineTransportAttachmentReport {
	public final status:TuiAppServerJsonRpcLineAttachmentStatus;
	public final code:String;
	public final connectionLabel:String;
	public final connectionIndex:Int;
	public final transportOpen:Bool;
	public final outboundLineCount:Int;
	public final inboundLineCount:Int;

	final outcomeValue:TuiAppServerJsonRpcLineOpenOutcome;

	public function new(status:TuiAppServerJsonRpcLineAttachmentStatus, code:String, connectionLabel:String, connectionIndex:Int, transportOpen:Bool,
			outboundLineCount:Int, inboundLineCount:Int, outcome:TuiAppServerJsonRpcLineOpenOutcome) {
		this.status = status;
		this.code = normalizeCode(code, status.text());
		this.connectionLabel = normalize(connectionLabel);
		this.connectionIndex = connectionIndex < 0 ? 0 : connectionIndex;
		this.transportOpen = transportOpen;
		this.outboundLineCount = outboundLineCount < 0 ? 0 : outboundLineCount;
		this.inboundLineCount = inboundLineCount < 0 ? 0 : inboundLineCount;
		this.outcomeValue = outcome;
	}

	public static function fromAttachment(attachment:TuiAppServerJsonRpcLineTransportAttachment):TuiAppServerJsonRpcLineTransportAttachmentReport {
		if (attachment == null)
			return refused(TuiAppServerJsonRpcLineOpenOutcome.refused(null));
		if (!attachment.isReady())
			return refused(attachment.outcome());
		final outcome = attachment.outcome();
		return new TuiAppServerJsonRpcLineTransportAttachmentReport(TuiAppServerJsonRpcLineAttachmentStatus.Ready, codeFromOutcome(outcome),
			labelFromOutcome(outcome), indexFromOutcome(outcome), attachment.transportOpen(), attachment.outboundLineCount(), attachment.inboundLineCount(),
			outcome);
	}

	public static function refused(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachmentReport {
		final concrete = outcome == null ? TuiAppServerJsonRpcLineOpenOutcome.refused(null) : outcome;
		return new TuiAppServerJsonRpcLineTransportAttachmentReport(TuiAppServerJsonRpcLineAttachmentStatus.Refused, concrete.code, concrete.connectionLabel,
			concrete.connectionIndex, false, 0, 0, concrete);
	}

	public function isReady():Bool {
		return status == TuiAppServerJsonRpcLineAttachmentStatus.Ready;
	}

	public function statusText():String {
		return status.text();
	}

	public function outcome():TuiAppServerJsonRpcLineOpenOutcome {
		return outcomeValue;
	}

	public function intentKindText():String {
		return outcomeValue == null ? "" : outcomeValue.intentKindText();
	}

	public function endpointStatusText():String {
		return outcomeValue == null ? "" : outcomeValue.endpointStatusText();
	}

	static function codeFromOutcome(outcome:TuiAppServerJsonRpcLineOpenOutcome):String {
		return outcome == null ? "missing_open_outcome" : outcome.code;
	}

	static function labelFromOutcome(outcome:TuiAppServerJsonRpcLineOpenOutcome):String {
		return outcome == null ? "" : outcome.connectionLabel;
	}

	static function indexFromOutcome(outcome:TuiAppServerJsonRpcLineOpenOutcome):Int {
		return outcome == null ? 0 : outcome.connectionIndex;
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}

	static function normalizeCode(value:String, fallback:String):String {
		final normalized = normalize(value);
		return normalized.length == 0 ? fallback : normalized;
	}
}
