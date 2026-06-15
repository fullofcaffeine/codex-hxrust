package codexhx.runtime.model.streamitem;

typedef ModelBacktrackResubmitOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelBacktrackResubmitDecisionKind;
	final userCountSinceLastSession:Int;
	final selectedNthUserMessage:Int;
	final rollbackTurnCount:Int;
	final composerTextAfterRollback:String;
	final composerRemoteImageCountAfterRollback:Int;
	final submittedImageItemCount:Int;
	final submittedTextItemCount:Int;
	final submittedImageUrl:String;
	final dataImageUrlPreserved:Bool;
	final imageItemBeforeTextItem:Bool;
	final rollbackSubmitted:Bool;
	final userTurnSubmitted:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelBacktrackResubmitOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelBacktrackResubmitDecisionKind;
	public final userCountSinceLastSession:Int;
	public final selectedNthUserMessage:Int;
	public final rollbackTurnCount:Int;
	public final composerTextAfterRollback:String;
	public final composerRemoteImageCountAfterRollback:Int;
	public final submittedImageItemCount:Int;
	public final submittedTextItemCount:Int;
	public final submittedImageUrl:String;
	public final dataImageUrlPreserved:Bool;
	public final imageItemBeforeTextItem:Bool;
	public final rollbackSubmitted:Bool;
	public final userTurnSubmitted:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelBacktrackResubmitOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelBacktrackResubmitDecisionKind.ResubmitBlocked : fields.decisionKind;
		this.userCountSinceLastSession = fields.userCountSinceLastSession;
		this.selectedNthUserMessage = fields.selectedNthUserMessage;
		this.rollbackTurnCount = fields.rollbackTurnCount;
		this.composerTextAfterRollback = fields.composerTextAfterRollback == null ? "" : fields.composerTextAfterRollback;
		this.composerRemoteImageCountAfterRollback = fields.composerRemoteImageCountAfterRollback;
		this.submittedImageItemCount = fields.submittedImageItemCount;
		this.submittedTextItemCount = fields.submittedTextItemCount;
		this.submittedImageUrl = fields.submittedImageUrl == null ? "" : fields.submittedImageUrl;
		this.dataImageUrlPreserved = fields.dataImageUrlPreserved;
		this.imageItemBeforeTextItem = fields.imageItemBeforeTextItem;
		this.rollbackSubmitted = fields.rollbackSubmitted;
		this.userTurnSubmitted = fields.userTurnSubmitted;
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
			+ ";rollbackTurnCount=" + rollbackTurnCount
			+ ";composerRemoteImageCountAfterRollback=" + composerRemoteImageCountAfterRollback
			+ ";submittedImageItemCount=" + submittedImageItemCount
			+ ";submittedTextItemCount=" + submittedTextItemCount
			+ ";dataImageUrlPreserved=" + boolText(dataImageUrlPreserved)
			+ ";imageItemBeforeTextItem=" + boolText(imageItemBeforeTextItem)
			+ ";rollbackSubmitted=" + boolText(rollbackSubmitted)
			+ ";userTurnSubmitted=" + boolText(userTurnSubmitted)
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
