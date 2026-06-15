package codexhx.runtime.model.streamitem;

typedef ModelBacktrackSelectionOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelBacktrackSelectionDecisionKind;
	final userCountSinceLastSession:Int;
	final selectedNthUserMessage:Int;
	final selectedPrefill:String;
	final selectedTextElementCount:Int;
	final selectedLocalImageCount:Int;
	final selectedRemoteImageCount:Int;
	final selectedLocalImagePath:String;
	final selectedRemoteImageUrl:String;
	final rollbackTurnCount:Int;
	final remoteImagesApplied:Bool;
	final composerPrefilled:Bool;
	final pendingRollbackRecorded:Bool;
	final threadRollbackSubmitted:Bool;
	final duplicateHistoryIgnoredBeforeLastSession:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelBacktrackSelectionOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelBacktrackSelectionDecisionKind;
	public final userCountSinceLastSession:Int;
	public final selectedNthUserMessage:Int;
	public final selectedPrefill:String;
	public final selectedTextElementCount:Int;
	public final selectedLocalImageCount:Int;
	public final selectedRemoteImageCount:Int;
	public final selectedLocalImagePath:String;
	public final selectedRemoteImageUrl:String;
	public final rollbackTurnCount:Int;
	public final remoteImagesApplied:Bool;
	public final composerPrefilled:Bool;
	public final pendingRollbackRecorded:Bool;
	public final threadRollbackSubmitted:Bool;
	public final duplicateHistoryIgnoredBeforeLastSession:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelBacktrackSelectionOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelBacktrackSelectionDecisionKind.SelectionUnavailable : fields.decisionKind;
		this.userCountSinceLastSession = fields.userCountSinceLastSession;
		this.selectedNthUserMessage = fields.selectedNthUserMessage;
		this.selectedPrefill = fields.selectedPrefill == null ? "" : fields.selectedPrefill;
		this.selectedTextElementCount = fields.selectedTextElementCount;
		this.selectedLocalImageCount = fields.selectedLocalImageCount;
		this.selectedRemoteImageCount = fields.selectedRemoteImageCount;
		this.selectedLocalImagePath = fields.selectedLocalImagePath == null ? "" : fields.selectedLocalImagePath;
		this.selectedRemoteImageUrl = fields.selectedRemoteImageUrl == null ? "" : fields.selectedRemoteImageUrl;
		this.rollbackTurnCount = fields.rollbackTurnCount;
		this.remoteImagesApplied = fields.remoteImagesApplied;
		this.composerPrefilled = fields.composerPrefilled;
		this.pendingRollbackRecorded = fields.pendingRollbackRecorded;
		this.threadRollbackSubmitted = fields.threadRollbackSubmitted;
		this.duplicateHistoryIgnoredBeforeLastSession = fields.duplicateHistoryIgnoredBeforeLastSession;
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
			+ ";userCountSinceLastSession=" + userCountSinceLastSession
			+ ";selectedNthUserMessage=" + selectedNthUserMessage
			+ ";selectedTextElementCount=" + selectedTextElementCount
			+ ";selectedLocalImageCount=" + selectedLocalImageCount
			+ ";selectedRemoteImageCount=" + selectedRemoteImageCount
			+ ";rollbackTurnCount=" + rollbackTurnCount
			+ ";remoteImagesApplied=" + boolText(remoteImagesApplied)
			+ ";composerPrefilled=" + boolText(composerPrefilled)
			+ ";pendingRollbackRecorded=" + boolText(pendingRollbackRecorded)
			+ ";threadRollbackSubmitted=" + boolText(threadRollbackSubmitted)
			+ ";duplicateHistoryIgnoredBeforeLastSession=" + boolText(duplicateHistoryIgnoredBeforeLastSession)
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
