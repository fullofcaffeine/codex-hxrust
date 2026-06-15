package codexhx.runtime.model.streamitem;

typedef ModelKeymapApprovalConflictOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapApprovalConflictDecisionKind;
	final approveBindingPreserved:Bool;
	final declineBindingPreserved:Bool;
	final denyBindingPreserved:Bool;
	final listAcceptBindingPreserved:Bool;
	final listCancelBindingPreserved:Bool;
	final conflictActionNamesPreserved:Bool;
	final conflictRejectionPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapApprovalConflictOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapApprovalConflictDecisionKind;
	public final approveBindingPreserved:Bool;
	public final declineBindingPreserved:Bool;
	public final denyBindingPreserved:Bool;
	public final listAcceptBindingPreserved:Bool;
	public final listCancelBindingPreserved:Bool;
	public final conflictActionNamesPreserved:Bool;
	public final conflictRejectionPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapApprovalConflictOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapApprovalConflictDecisionKind.KeymapApprovalConflictMissed : fields.decisionKind;
		this.approveBindingPreserved = fields.approveBindingPreserved;
		this.declineBindingPreserved = fields.declineBindingPreserved;
		this.denyBindingPreserved = fields.denyBindingPreserved;
		this.listAcceptBindingPreserved = fields.listAcceptBindingPreserved;
		this.listCancelBindingPreserved = fields.listCancelBindingPreserved;
		this.conflictActionNamesPreserved = fields.conflictActionNamesPreserved;
		this.conflictRejectionPreserved = fields.conflictRejectionPreserved;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";decisionKind=" + decisionKind
			+ ";approveBindingPreserved=" + boolText(approveBindingPreserved)
			+ ";declineBindingPreserved=" + boolText(declineBindingPreserved)
			+ ";denyBindingPreserved=" + boolText(denyBindingPreserved)
			+ ";listAcceptBindingPreserved=" + boolText(listAcceptBindingPreserved)
			+ ";listCancelBindingPreserved=" + boolText(listCancelBindingPreserved)
			+ ";conflictActionNamesPreserved=" + boolText(conflictActionNamesPreserved)
			+ ";conflictRejectionPreserved=" + boolText(conflictRejectionPreserved)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
