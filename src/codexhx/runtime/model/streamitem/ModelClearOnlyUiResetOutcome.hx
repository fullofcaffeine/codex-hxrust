package codexhx.runtime.model.streamitem;

typedef ModelClearOnlyUiResetOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelClearOnlyUiResetDecisionKind;
	final resetInvoked:Bool;
	final overlayCleared:Bool;
	final transcriptCleared:Bool;
	final deferredHistoryCleared:Bool;
	final historyEmittedFlagReset:Bool;
	final transcriptReflowCleared:Bool;
	final initialHistoryReplayBufferCleared:Bool;
	final backtrackPrimedCleared:Bool;
	final backtrackPreviewCleared:Bool;
	final backtrackPendingRollbackCleared:Bool;
	final backtrackRenderPendingCleared:Bool;
	final skillWarningsCleared:Bool;
	final chatSessionThreadPreserved:Bool;
	final composerDraftPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelClearOnlyUiResetOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelClearOnlyUiResetDecisionKind;
	public final resetInvoked:Bool;
	public final overlayCleared:Bool;
	public final transcriptCleared:Bool;
	public final deferredHistoryCleared:Bool;
	public final historyEmittedFlagReset:Bool;
	public final transcriptReflowCleared:Bool;
	public final initialHistoryReplayBufferCleared:Bool;
	public final backtrackPrimedCleared:Bool;
	public final backtrackPreviewCleared:Bool;
	public final backtrackPendingRollbackCleared:Bool;
	public final backtrackRenderPendingCleared:Bool;
	public final skillWarningsCleared:Bool;
	public final chatSessionThreadPreserved:Bool;
	public final composerDraftPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelClearOnlyUiResetOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelClearOnlyUiResetDecisionKind.ClearOnlyUiResetUnavailable : fields.decisionKind;
		this.resetInvoked = fields.resetInvoked;
		this.overlayCleared = fields.overlayCleared;
		this.transcriptCleared = fields.transcriptCleared;
		this.deferredHistoryCleared = fields.deferredHistoryCleared;
		this.historyEmittedFlagReset = fields.historyEmittedFlagReset;
		this.transcriptReflowCleared = fields.transcriptReflowCleared;
		this.initialHistoryReplayBufferCleared = fields.initialHistoryReplayBufferCleared;
		this.backtrackPrimedCleared = fields.backtrackPrimedCleared;
		this.backtrackPreviewCleared = fields.backtrackPreviewCleared;
		this.backtrackPendingRollbackCleared = fields.backtrackPendingRollbackCleared;
		this.backtrackRenderPendingCleared = fields.backtrackRenderPendingCleared;
		this.skillWarningsCleared = fields.skillWarningsCleared;
		this.chatSessionThreadPreserved = fields.chatSessionThreadPreserved;
		this.composerDraftPreserved = fields.composerDraftPreserved;
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
			+ ";resetInvoked=" + boolText(resetInvoked)
			+ ";overlayCleared=" + boolText(overlayCleared)
			+ ";transcriptCleared=" + boolText(transcriptCleared)
			+ ";deferredHistoryCleared=" + boolText(deferredHistoryCleared)
			+ ";historyEmittedFlagReset=" + boolText(historyEmittedFlagReset)
			+ ";transcriptReflowCleared=" + boolText(transcriptReflowCleared)
			+ ";initialHistoryReplayBufferCleared=" + boolText(initialHistoryReplayBufferCleared)
			+ ";backtrackPrimedCleared=" + boolText(backtrackPrimedCleared)
			+ ";backtrackPreviewCleared=" + boolText(backtrackPreviewCleared)
			+ ";backtrackPendingRollbackCleared=" + boolText(backtrackPendingRollbackCleared)
			+ ";backtrackRenderPendingCleared=" + boolText(backtrackRenderPendingCleared)
			+ ";skillWarningsCleared=" + boolText(skillWarningsCleared)
			+ ";chatSessionThreadPreserved=" + boolText(chatSessionThreadPreserved)
			+ ";composerDraftPreserved=" + boolText(composerDraftPreserved)
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
