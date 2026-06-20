package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerTypedResponseRefreshApplicationFields = {
	final kind:ResumePickerAppServerTypedResponseRefreshApplicationKind;
	final requestClass:ResumePickerAppServerPendingRequestClassKind;
	final payloadKind:ResumePickerAppServerTypedResponsePayloadKind;
	final requestId:String;
	final dispatchSequence:Int;
	final appliedIndex:Int;
	final pendingReplayRefreshed:Bool;
	final sideParentStatusRefreshed:Bool;
	final activeThreadStatusUpdated:Bool;
	final mutationApplied:Bool;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRefreshApplication {
	@:recordDefault(ResumePickerAppServerTypedResponseRefreshApplicationKind.Unknown)
	public final kind:ResumePickerAppServerTypedResponseRefreshApplicationKind;
	@:recordDefault(ResumePickerAppServerPendingRequestClassKind.Unknown)
	public final requestClass:ResumePickerAppServerPendingRequestClassKind;
	@:recordDefault(ResumePickerAppServerTypedResponsePayloadKind.Unknown)
	public final payloadKind:ResumePickerAppServerTypedResponsePayloadKind;
	public final requestId:String;
	public final dispatchSequence:Int;
	public final appliedIndex:Int;
	public final pendingReplayRefreshed:Bool;
	public final sideParentStatusRefreshed:Bool;
	public final activeThreadStatusUpdated:Bool;
	public final mutationApplied:Bool;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";class=" + requestClass + ";payloadKind=" + payloadKind + ";request=" + requestId + ";dispatchSequence=" + dispatchSequence
			+ ";appliedIndex=" + appliedIndex + ";pendingReplay=" + boolLabel(pendingReplayRefreshed) + ";sideParentStatus="
			+ boolLabel(sideParentStatusRefreshed) + ";activeThreadStatus=" + boolLabel(activeThreadStatusUpdated) + ";mutation="
			+ boolLabel(mutationApplied) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
