package codexhx.runtime.model.streamitem;

typedef ModelKeymapAliasOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapAliasDecisionKind;
	final emptyArrayUnbindPreserved:Bool;
	final rawOutputDefaultAltRPreserved:Bool;
	final rawOutputRemapF12Preserved:Bool;
	final editorNewlineAliasesPreserved:Bool;
	final deleteForwardWordAltDPreserved:Bool;
	final modifiedDeletionAliasesPreserved:Bool;
	final composerToggleShiftQuestionPreserved:Bool;
	final approvalOpenFullscreenCtrlShiftAPreserved:Bool;
	final primaryBindingFirstPreserved:Bool;
	final primaryBindingEmptyNonePreserved:Bool;
	final defaultsConflictValidationPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapAliasOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapAliasDecisionKind;
	public final emptyArrayUnbindPreserved:Bool;
	public final rawOutputDefaultAltRPreserved:Bool;
	public final rawOutputRemapF12Preserved:Bool;
	public final editorNewlineAliasesPreserved:Bool;
	public final deleteForwardWordAltDPreserved:Bool;
	public final modifiedDeletionAliasesPreserved:Bool;
	public final composerToggleShiftQuestionPreserved:Bool;
	public final approvalOpenFullscreenCtrlShiftAPreserved:Bool;
	public final primaryBindingFirstPreserved:Bool;
	public final primaryBindingEmptyNonePreserved:Bool;
	public final defaultsConflictValidationPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapAliasOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapAliasDecisionKind.KeymapAliasesRejected : fields.decisionKind;
		this.emptyArrayUnbindPreserved = fields.emptyArrayUnbindPreserved;
		this.rawOutputDefaultAltRPreserved = fields.rawOutputDefaultAltRPreserved;
		this.rawOutputRemapF12Preserved = fields.rawOutputRemapF12Preserved;
		this.editorNewlineAliasesPreserved = fields.editorNewlineAliasesPreserved;
		this.deleteForwardWordAltDPreserved = fields.deleteForwardWordAltDPreserved;
		this.modifiedDeletionAliasesPreserved = fields.modifiedDeletionAliasesPreserved;
		this.composerToggleShiftQuestionPreserved = fields.composerToggleShiftQuestionPreserved;
		this.approvalOpenFullscreenCtrlShiftAPreserved = fields.approvalOpenFullscreenCtrlShiftAPreserved;
		this.primaryBindingFirstPreserved = fields.primaryBindingFirstPreserved;
		this.primaryBindingEmptyNonePreserved = fields.primaryBindingEmptyNonePreserved;
		this.defaultsConflictValidationPreserved = fields.defaultsConflictValidationPreserved;
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
			+ ";emptyArrayUnbindPreserved=" + boolText(emptyArrayUnbindPreserved)
			+ ";rawOutputDefaultAltRPreserved=" + boolText(rawOutputDefaultAltRPreserved)
			+ ";rawOutputRemapF12Preserved=" + boolText(rawOutputRemapF12Preserved)
			+ ";editorNewlineAliasesPreserved=" + boolText(editorNewlineAliasesPreserved)
			+ ";deleteForwardWordAltDPreserved=" + boolText(deleteForwardWordAltDPreserved)
			+ ";modifiedDeletionAliasesPreserved=" + boolText(modifiedDeletionAliasesPreserved)
			+ ";composerToggleShiftQuestionPreserved=" + boolText(composerToggleShiftQuestionPreserved)
			+ ";approvalOpenFullscreenCtrlShiftAPreserved=" + boolText(approvalOpenFullscreenCtrlShiftAPreserved)
			+ ";primaryBindingFirstPreserved=" + boolText(primaryBindingFirstPreserved)
			+ ";primaryBindingEmptyNonePreserved=" + boolText(primaryBindingEmptyNonePreserved)
			+ ";defaultsConflictValidationPreserved=" + boolText(defaultsConflictValidationPreserved)
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
