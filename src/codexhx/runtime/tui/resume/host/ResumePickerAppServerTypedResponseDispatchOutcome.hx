package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerTypedResponseDispatchOutcomeFields = {
	final kind:ResumePickerAppServerTypedResponseDispatchOutcomeKind;
	final requestClass:ResumePickerAppServerPendingRequestClassKind;
	final payloadKind:ResumePickerAppServerTypedResponsePayloadKind;
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
class ResumePickerAppServerTypedResponseDispatchOutcome {
	@:recordDefault(ResumePickerAppServerTypedResponseDispatchOutcomeKind.Unknown)
	public final kind:ResumePickerAppServerTypedResponseDispatchOutcomeKind;
	@:recordDefault(ResumePickerAppServerPendingRequestClassKind.Unknown)
	public final requestClass:ResumePickerAppServerPendingRequestClassKind;
	@:recordDefault(ResumePickerAppServerTypedResponsePayloadKind.Unknown)
	public final payloadKind:ResumePickerAppServerTypedResponsePayloadKind;
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
