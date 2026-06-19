package codexhx.runtime.model.streamitem;

typedef ModelCancelledTurnEditOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelCancelledTurnEditDecisionKind;
	final userCountSinceLastSession:Int;
	final selectedNthUserMessage:Int;
	final rollbackTurnCount:Int;
	final usedBacktrackRollbackPath:Bool;
	final usedFirstPromptRollbackPath:Bool;
	final promptText:String;
	final promptTextElementCount:Int;
	final promptLocalImageCount:Int;
	final promptRemoteImageCount:Int;
	final promptRemoteImageUrl:String;
	final composerTextAfter:String;
	final remoteImagesApplied:Bool;
	final pendingRollbackRecorded:Bool;
	final threadRollbackSubmitted:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelCancelledTurnEditOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelCancelledTurnEditDecisionKind;
	public final userCountSinceLastSession:Int;
	public final selectedNthUserMessage:Int;
	public final rollbackTurnCount:Int;
	public final usedBacktrackRollbackPath:Bool;
	public final usedFirstPromptRollbackPath:Bool;
	public final promptText:String;
	public final promptTextElementCount:Int;
	public final promptLocalImageCount:Int;
	public final promptRemoteImageCount:Int;
	public final promptRemoteImageUrl:String;
	public final composerTextAfter:String;
	public final remoteImagesApplied:Bool;
	public final pendingRollbackRecorded:Bool;
	public final threadRollbackSubmitted:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelCancelledTurnEditOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelCancelledTurnEditDecisionKind.PendingRollbackRejected : fields.decisionKind;
		this.userCountSinceLastSession = fields.userCountSinceLastSession;
		this.selectedNthUserMessage = fields.selectedNthUserMessage;
		this.rollbackTurnCount = fields.rollbackTurnCount;
		this.usedBacktrackRollbackPath = fields.usedBacktrackRollbackPath;
		this.usedFirstPromptRollbackPath = fields.usedFirstPromptRollbackPath;
		this.promptText = fields.promptText == null ? "" : fields.promptText;
		this.promptTextElementCount = fields.promptTextElementCount;
		this.promptLocalImageCount = fields.promptLocalImageCount;
		this.promptRemoteImageCount = fields.promptRemoteImageCount;
		this.promptRemoteImageUrl = fields.promptRemoteImageUrl == null ? "" : fields.promptRemoteImageUrl;
		this.composerTextAfter = fields.composerTextAfter == null ? "" : fields.composerTextAfter;
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
			+ userCountSinceLastSession + ";selectedNthUserMessage=" + selectedNthUserMessage + ";rollbackTurnCount=" + rollbackTurnCount
			+ ";usedBacktrackRollbackPath=" + boolText(usedBacktrackRollbackPath) + ";usedFirstPromptRollbackPath=" + boolText(usedFirstPromptRollbackPath)
			+ ";promptTextElementCount=" + promptTextElementCount + ";promptLocalImageCount=" + promptLocalImageCount + ";promptRemoteImageCount="
			+ promptRemoteImageCount + ";remoteImagesApplied=" + boolText(remoteImagesApplied) + ";pendingRollbackRecorded="
			+ boolText(pendingRollbackRecorded) + ";threadRollbackSubmitted=" + boolText(threadRollbackSubmitted) + ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
