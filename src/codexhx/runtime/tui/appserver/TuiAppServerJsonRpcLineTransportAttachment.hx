package codexhx.runtime.tui.appserver;

/**
	Typed result from binding an opened app-server line connection to a transport.
**/
class TuiAppServerJsonRpcLineTransportAttachment {
	public final status:TuiAppServerJsonRpcLineAttachmentStatus;

	final outcomeValue:TuiAppServerJsonRpcLineOpenOutcome;

	function new(status:TuiAppServerJsonRpcLineAttachmentStatus, outcome:TuiAppServerJsonRpcLineOpenOutcome) {
		this.status = status;
		this.outcomeValue = outcome == null ? TuiAppServerJsonRpcLineOpenOutcome.refused(null) : outcome;
	}

	public static function ready(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment {
		if (outcome == null || !outcome.isOpened())
			return refused(outcome);
		return new TuiAppServerJsonRpcLineTransportAttachment(TuiAppServerJsonRpcLineAttachmentStatus.Ready, outcome);
	}

	public static function refused(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment {
		return new TuiAppServerJsonRpcLineTransportAttachment(TuiAppServerJsonRpcLineAttachmentStatus.Refused, outcome);
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

	public function hasTransport():Bool {
		return isReady();
	}

	public function transportOpen():Bool {
		return isReady();
	}

	public function hasLaunchPlan():Bool {
		return outcomeValue.hasLaunchPlan();
	}

	public function launchPlan():Null<TuiAppServerJsonRpcProcessLaunchPlan> {
		return outcomeValue.launchPlan();
	}

	public function hasSocketTarget():Bool {
		return outcomeValue.hasSocketTarget();
	}

	public function socketHost():String {
		return outcomeValue.socketHost();
	}

	public function socketPort():Int {
		return outcomeValue.socketPort();
	}

	public function outboundLineCount():Int {
		return 0;
	}

	public function inboundLineCount():Int {
		return 0;
	}
}
