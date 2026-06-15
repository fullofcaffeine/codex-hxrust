package codexhx.runtime.model.streamitem;

typedef ModelFeedbackSubmissionRoutingOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final requestKind:ModelFeedbackSubmissionRequestKind;
	final decisionKind:ModelFeedbackSubmissionDecisionKind;
	final category:ModelFeedbackSubmissionCategory;
	final includeLogs:Bool;
	final feedbackSucceeded:Bool;
	final resultThreadId:String;
	final resultErrorMessage:String;
	final originThreadProvided:Bool;
	final originThreadActive:Bool;
	final originThreadBuffered:Bool;
	final activeThreadSendAttempted:Bool;
	final currentHistoryRendered:Bool;
	final snapshotReplayRendered:Bool;
	final historyCellKind:ModelFeedbackSubmissionHistoryCellKind;
	final historyCellText:String;
	final appEventEmittedImmediately:Bool;
	final eventOrderingPreserved:Bool;
	final liveFeedbackUploadAttempted:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelFeedbackSubmissionRoutingOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final requestKind:ModelFeedbackSubmissionRequestKind;
	public final decisionKind:ModelFeedbackSubmissionDecisionKind;
	public final category:ModelFeedbackSubmissionCategory;
	public final includeLogs:Bool;
	public final feedbackSucceeded:Bool;
	public final resultThreadId:String;
	public final resultErrorMessage:String;
	public final originThreadProvided:Bool;
	public final originThreadActive:Bool;
	public final originThreadBuffered:Bool;
	public final activeThreadSendAttempted:Bool;
	public final currentHistoryRendered:Bool;
	public final snapshotReplayRendered:Bool;
	public final historyCellKind:ModelFeedbackSubmissionHistoryCellKind;
	public final historyCellText:String;
	public final appEventEmittedImmediately:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveFeedbackUploadAttempted:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelFeedbackSubmissionRoutingOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.requestKind = fields.requestKind == null ? ModelFeedbackSubmissionRequestKind.Submitted : fields.requestKind;
		this.decisionKind = fields.decisionKind == null ? ModelFeedbackSubmissionDecisionKind.CurrentHistoryRendered : fields.decisionKind;
		this.category = fields.category == null ? ModelFeedbackSubmissionCategory.Bug : fields.category;
		this.includeLogs = fields.includeLogs;
		this.feedbackSucceeded = fields.feedbackSucceeded;
		this.resultThreadId = fields.resultThreadId == null ? "" : fields.resultThreadId;
		this.resultErrorMessage = fields.resultErrorMessage == null ? "" : fields.resultErrorMessage;
		this.originThreadProvided = fields.originThreadProvided;
		this.originThreadActive = fields.originThreadActive;
		this.originThreadBuffered = fields.originThreadBuffered;
		this.activeThreadSendAttempted = fields.activeThreadSendAttempted;
		this.currentHistoryRendered = fields.currentHistoryRendered;
		this.snapshotReplayRendered = fields.snapshotReplayRendered;
		this.historyCellKind = fields.historyCellKind == null ? ModelFeedbackSubmissionHistoryCellKind.None : fields.historyCellKind;
		this.historyCellText = fields.historyCellText == null ? "" : fields.historyCellText;
		this.appEventEmittedImmediately = fields.appEventEmittedImmediately;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveFeedbackUploadAttempted = fields.liveFeedbackUploadAttempted;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";requestKind=" + requestKind
			+ ";decisionKind=" + decisionKind
			+ ";category=" + category
			+ ";includeLogs=" + boolText(includeLogs)
			+ ";feedbackSucceeded=" + boolText(feedbackSucceeded)
			+ ";resultThreadId=" + noneIfEmpty(resultThreadId)
			+ ";originThreadProvided=" + boolText(originThreadProvided)
			+ ";originThreadActive=" + boolText(originThreadActive)
			+ ";originThreadBuffered=" + boolText(originThreadBuffered)
			+ ";activeThreadSendAttempted=" + boolText(activeThreadSendAttempted)
			+ ";currentHistoryRendered=" + boolText(currentHistoryRendered)
			+ ";snapshotReplayRendered=" + boolText(snapshotReplayRendered)
			+ ";historyCellKind=" + historyCellKind
			+ ";appEventEmittedImmediately=" + boolText(appEventEmittedImmediately)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveFeedbackUploadAttempted=" + boolText(liveFeedbackUploadAttempted)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
