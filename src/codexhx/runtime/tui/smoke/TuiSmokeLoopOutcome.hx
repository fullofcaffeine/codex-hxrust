package codexhx.runtime.tui.smoke;

typedef TuiSmokeLoopOutcomeFields = {
	final ok:Bool;
	final code:String;
	final exit:TuiSmokeExitKind;
	final snapshot:String;
	final trace:String;
	final renderCount:Int;
	final appEventLogCount:Int;
	final appServerEventCount:Int;
	final appServerRequestCount:Int;
	final appServerRejectedRequestCount:Int;
	final appServerResolutionCount:Int;
	final appServerStaleResolutionCount:Int;
	final appServerDeliveredRequestCount:Int;
	final appServerEvictedRequestCount:Int;
	final threadNotificationCount:Int;
	final threadNotificationDeliveryCount:Int;
	final threadNotificationEvictionCount:Int;
	final threadReplayCount:Int;
	final threadReplayRequestCount:Int;
	final threadReplaySkippedRequestCount:Int;
	final threadReplaySuppressedNoticeCount:Int;
	final threadReplayTurnCount:Int;
	final threadReplayItemCount:Int;
	final threadReplayCompletionCount:Int;
	final terminalRestored:Bool;
}

class TuiSmokeLoopOutcome {
	public final ok:Bool;
	public final code:String;
	public final exit:TuiSmokeExitKind;
	public final snapshot:String;
	public final trace:String;
	public final renderCount:Int;
	public final appEventLogCount:Int;
	public final appServerEventCount:Int;
	public final appServerRequestCount:Int;
	public final appServerRejectedRequestCount:Int;
	public final appServerResolutionCount:Int;
	public final appServerStaleResolutionCount:Int;
	public final appServerDeliveredRequestCount:Int;
	public final appServerEvictedRequestCount:Int;
	public final threadNotificationCount:Int;
	public final threadNotificationDeliveryCount:Int;
	public final threadNotificationEvictionCount:Int;
	public final threadReplayCount:Int;
	public final threadReplayRequestCount:Int;
	public final threadReplaySkippedRequestCount:Int;
	public final threadReplaySuppressedNoticeCount:Int;
	public final threadReplayTurnCount:Int;
	public final threadReplayItemCount:Int;
	public final threadReplayCompletionCount:Int;
	public final terminalRestored:Bool;

	public function new(fields:TuiSmokeLoopOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.exit = fields.exit == null ? TuiSmokeExitKind.Unknown : fields.exit;
		this.snapshot = fields.snapshot == null ? "" : fields.snapshot;
		this.trace = fields.trace == null ? "" : fields.trace;
		this.renderCount = fields.renderCount;
		this.appEventLogCount = fields.appEventLogCount;
		this.appServerEventCount = fields.appServerEventCount;
		this.appServerRequestCount = fields.appServerRequestCount;
		this.appServerRejectedRequestCount = fields.appServerRejectedRequestCount;
		this.appServerResolutionCount = fields.appServerResolutionCount;
		this.appServerStaleResolutionCount = fields.appServerStaleResolutionCount;
		this.appServerDeliveredRequestCount = fields.appServerDeliveredRequestCount;
		this.appServerEvictedRequestCount = fields.appServerEvictedRequestCount;
		this.threadNotificationCount = fields.threadNotificationCount;
		this.threadNotificationDeliveryCount = fields.threadNotificationDeliveryCount;
		this.threadNotificationEvictionCount = fields.threadNotificationEvictionCount;
		this.threadReplayCount = fields.threadReplayCount;
		this.threadReplayRequestCount = fields.threadReplayRequestCount;
		this.threadReplaySkippedRequestCount = fields.threadReplaySkippedRequestCount;
		this.threadReplaySuppressedNoticeCount = fields.threadReplaySuppressedNoticeCount;
		this.threadReplayTurnCount = fields.threadReplayTurnCount;
		this.threadReplayItemCount = fields.threadReplayItemCount;
		this.threadReplayCompletionCount = fields.threadReplayCompletionCount;
		this.terminalRestored = fields.terminalRestored;
	}
}
