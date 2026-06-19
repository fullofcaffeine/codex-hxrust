package codexhx.runtime.model.streamitem;

typedef ModelBacktrackRollbackOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelBacktrackRollbackDecisionKind;
	final userCountSinceLastSession:Int;
	final selectedNthUserMessage:Int;
	final prefillEmpty:Bool;
	final remoteImageOnlySelection:Bool;
	final selectedTextElementCount:Int;
	final selectedLocalImageCount:Int;
	final selectedRemoteImageCount:Int;
	final selectedRemoteImageUrl:String;
	final rollbackTurnCount:Int;
	final composerDraftBefore:String;
	final composerDraftAfter:String;
	final staleComposerDraftCleared:Bool;
	final remoteImagesApplied:Bool;
	final pendingRollbackRecorded:Bool;
	final threadRollbackSubmitted:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelBacktrackRollbackOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelBacktrackRollbackDecisionKind;
	public final userCountSinceLastSession:Int;
	public final selectedNthUserMessage:Int;
	public final prefillEmpty:Bool;
	public final remoteImageOnlySelection:Bool;
	public final selectedTextElementCount:Int;
	public final selectedLocalImageCount:Int;
	public final selectedRemoteImageCount:Int;
	public final selectedRemoteImageUrl:String;
	public final rollbackTurnCount:Int;
	public final composerDraftBefore:String;
	public final composerDraftAfter:String;
	public final staleComposerDraftCleared:Bool;
	public final remoteImagesApplied:Bool;
	public final pendingRollbackRecorded:Bool;
	public final threadRollbackSubmitted:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelBacktrackRollbackOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelBacktrackRollbackDecisionKind.RollbackUnavailable : fields.decisionKind;
		this.userCountSinceLastSession = fields.userCountSinceLastSession;
		this.selectedNthUserMessage = fields.selectedNthUserMessage;
		this.prefillEmpty = fields.prefillEmpty;
		this.remoteImageOnlySelection = fields.remoteImageOnlySelection;
		this.selectedTextElementCount = fields.selectedTextElementCount;
		this.selectedLocalImageCount = fields.selectedLocalImageCount;
		this.selectedRemoteImageCount = fields.selectedRemoteImageCount;
		this.selectedRemoteImageUrl = fields.selectedRemoteImageUrl == null ? "" : fields.selectedRemoteImageUrl;
		this.rollbackTurnCount = fields.rollbackTurnCount;
		this.composerDraftBefore = fields.composerDraftBefore == null ? "" : fields.composerDraftBefore;
		this.composerDraftAfter = fields.composerDraftAfter == null ? "" : fields.composerDraftAfter;
		this.staleComposerDraftCleared = fields.staleComposerDraftCleared;
		this.remoteImagesApplied = fields.remoteImagesApplied;
		this.pendingRollbackRecorded = fields.pendingRollbackRecorded;
		this.threadRollbackSubmitted = fields.threadRollbackSubmitted;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";userCountSinceLastSession="
			+ userCountSinceLastSession + ";selectedNthUserMessage=" + selectedNthUserMessage + ";prefillEmpty=" + boolText(prefillEmpty)
			+ ";remoteImageOnlySelection=" + boolText(remoteImageOnlySelection) + ";selectedTextElementCount=" + selectedTextElementCount
			+ ";selectedLocalImageCount=" + selectedLocalImageCount + ";selectedRemoteImageCount=" + selectedRemoteImageCount + ";rollbackTurnCount="
			+ rollbackTurnCount + ";staleComposerDraftCleared=" + boolText(staleComposerDraftCleared) + ";remoteImagesApplied="
			+ boolText(remoteImagesApplied) + ";pendingRollbackRecorded=" + boolText(pendingRollbackRecorded) + ";threadRollbackSubmitted="
			+ boolText(threadRollbackSubmitted) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
