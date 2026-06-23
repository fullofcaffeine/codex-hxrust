package codexhx.runtime.tui.resume.host;

typedef RefreshApplicationFields = {
	final kind:RefreshApplicationKind;
	final requestClass:PendingRequestClassKind;
	final payloadKind:PayloadKind;
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
class RefreshApplication {
	@:recordDefault(RefreshApplicationKind.Unknown)
	public final kind:RefreshApplicationKind;
	@:recordDefault(PendingRequestClassKind.Unknown)
	public final requestClass:PendingRequestClassKind;
	@:recordDefault(PayloadKind.Unknown)
	public final payloadKind:PayloadKind;
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
