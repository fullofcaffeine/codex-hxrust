package codexhx.runtime.tui.resume.host;

typedef DispatchOutcomeFields = {
	final kind:DispatchOutcomeKind;
	final requestClass:PendingRequestClassKind;
	final payloadKind:PayloadKind;
	final requestId:String;
	final correlationKey:String;
	final sequence:Int;
	final sourceOrder:Int;
	final refreshScheduled:Bool;
	final pendingReplayRefresh:Bool;
	final sideParentStatusUpdated:Bool;
	final liveTransportAttempted:Bool;
	final liveTransportSuppressed:Bool;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class DispatchOutcome {
	@:recordDefault(DispatchOutcomeKind.Unknown)
	public final kind:DispatchOutcomeKind;
	@:recordDefault(PendingRequestClassKind.Unknown)
	public final requestClass:PendingRequestClassKind;
	@:recordDefault(PayloadKind.Unknown)
	public final payloadKind:PayloadKind;
	public final requestId:String;
	public final correlationKey:String;
	public final sequence:Int;
	public final sourceOrder:Int;
	public final refreshScheduled:Bool;
	public final pendingReplayRefresh:Bool;
	public final sideParentStatusUpdated:Bool;
	public final liveTransportAttempted:Bool;
	public final liveTransportSuppressed:Bool;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";class=" + requestClass + ";payloadKind=" + payloadKind + ";request=" + requestId + ";correlation=" + correlationKey
			+ ";sequence=" + sequence + ";sourceOrder=" + sourceOrder + ";refresh=" + boolLabel(refreshScheduled) + ";pendingReplayRefresh="
			+ boolLabel(pendingReplayRefresh) + ";sideParentStatus=" + boolLabel(sideParentStatusUpdated) + ";liveTransport="
			+ boolLabel(liveTransportAttempted) + ";suppressed=" + boolLabel(liveTransportSuppressed) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
