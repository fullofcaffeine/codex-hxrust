package codexhx.runtime.model.streamitem;

typedef ModelKeymapOverlapConflictOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapOverlapConflictDecisionKind;
	final explicitListLegacyConflictPreserved:Bool;
	final appBindingPrunesListDefaultPreserved:Bool;
	final approvalBindingPrunesListDefaultPreserved:Bool;
	final explicitListApprovalConflictPreserved:Bool;
	final legacyVimChangePruningPreserved:Bool;
	final explicitVimChangeConflictPreserved:Bool;
	final legacyVimSubstitutePruningPreserved:Bool;
	final explicitVimSubstituteConflictPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapOverlapConflictOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapOverlapConflictDecisionKind;
	public final explicitListLegacyConflictPreserved:Bool;
	public final appBindingPrunesListDefaultPreserved:Bool;
	public final approvalBindingPrunesListDefaultPreserved:Bool;
	public final explicitListApprovalConflictPreserved:Bool;
	public final legacyVimChangePruningPreserved:Bool;
	public final explicitVimChangeConflictPreserved:Bool;
	public final legacyVimSubstitutePruningPreserved:Bool;
	public final explicitVimSubstituteConflictPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapOverlapConflictOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapOverlapConflictDecisionKind.KeymapOverlapConflictsRejected : fields.decisionKind;
		this.explicitListLegacyConflictPreserved = fields.explicitListLegacyConflictPreserved;
		this.appBindingPrunesListDefaultPreserved = fields.appBindingPrunesListDefaultPreserved;
		this.approvalBindingPrunesListDefaultPreserved = fields.approvalBindingPrunesListDefaultPreserved;
		this.explicitListApprovalConflictPreserved = fields.explicitListApprovalConflictPreserved;
		this.legacyVimChangePruningPreserved = fields.legacyVimChangePruningPreserved;
		this.explicitVimChangeConflictPreserved = fields.explicitVimChangeConflictPreserved;
		this.legacyVimSubstitutePruningPreserved = fields.legacyVimSubstitutePruningPreserved;
		this.explicitVimSubstituteConflictPreserved = fields.explicitVimSubstituteConflictPreserved;
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
			+ ";explicitListLegacyConflictPreserved=" + boolText(explicitListLegacyConflictPreserved)
			+ ";appBindingPrunesListDefaultPreserved=" + boolText(appBindingPrunesListDefaultPreserved)
			+ ";approvalBindingPrunesListDefaultPreserved=" + boolText(approvalBindingPrunesListDefaultPreserved)
			+ ";explicitListApprovalConflictPreserved=" + boolText(explicitListApprovalConflictPreserved)
			+ ";legacyVimChangePruningPreserved=" + boolText(legacyVimChangePruningPreserved)
			+ ";explicitVimChangeConflictPreserved=" + boolText(explicitVimChangeConflictPreserved)
			+ ";legacyVimSubstitutePruningPreserved=" + boolText(legacyVimSubstitutePruningPreserved)
			+ ";explicitVimSubstituteConflictPreserved=" + boolText(explicitVimSubstituteConflictPreserved)
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
