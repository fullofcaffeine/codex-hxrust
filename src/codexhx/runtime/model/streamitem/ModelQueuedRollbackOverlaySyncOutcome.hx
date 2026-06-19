package codexhx.runtime.model.streamitem;

typedef ModelQueuedRollbackOverlaySyncOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelQueuedRollbackOverlaySyncDecisionKind;
	final numTurns:Int;
	final transcriptCellCountBefore:Int;
	final transcriptCellCountAfter:Int;
	final userCountBefore:Int;
	final userCountAfter:Int;
	final userMessagesAfter:Array<String>;
	final overlayActive:Bool;
	final overlayCommittedCellCountBefore:Int;
	final overlayCommittedCellCountAfter:Int;
	final overlayCommittedCountSynced:Bool;
	final deferredHistoryLineCountBefore:Int;
	final deferredHistoryLineCountAfter:Int;
	final deferredHistoryCleared:Bool;
	final previewSelectionBefore:Int;
	final previewSelectionAfter:Int;
	final previewSelectionClamped:Bool;
	final agentCopyHistoryUserCountAfter:Int;
	final agentCopyHistoryTruncated:Bool;
	final backtrackRenderPending:Bool;
	final eventOrderingPreserved:Bool;
	final liveOnlyEffectsSuppressed:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelQueuedRollbackOverlaySyncOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelQueuedRollbackOverlaySyncDecisionKind;
	public final numTurns:Int;
	public final transcriptCellCountBefore:Int;
	public final transcriptCellCountAfter:Int;
	public final userCountBefore:Int;
	public final userCountAfter:Int;
	public final userMessagesAfter:Array<String>;
	public final overlayActive:Bool;
	public final overlayCommittedCellCountBefore:Int;
	public final overlayCommittedCellCountAfter:Int;
	public final overlayCommittedCountSynced:Bool;
	public final deferredHistoryLineCountBefore:Int;
	public final deferredHistoryLineCountAfter:Int;
	public final deferredHistoryCleared:Bool;
	public final previewSelectionBefore:Int;
	public final previewSelectionAfter:Int;
	public final previewSelectionClamped:Bool;
	public final agentCopyHistoryUserCountAfter:Int;
	public final agentCopyHistoryTruncated:Bool;
	public final backtrackRenderPending:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveOnlyEffectsSuppressed:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelQueuedRollbackOverlaySyncOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelQueuedRollbackOverlaySyncDecisionKind.RollbackUnchanged : fields.decisionKind;
		this.numTurns = fields.numTurns;
		this.transcriptCellCountBefore = fields.transcriptCellCountBefore;
		this.transcriptCellCountAfter = fields.transcriptCellCountAfter;
		this.userCountBefore = fields.userCountBefore;
		this.userCountAfter = fields.userCountAfter;
		this.userMessagesAfter = fields.userMessagesAfter == null ? [] : fields.userMessagesAfter;
		this.overlayActive = fields.overlayActive;
		this.overlayCommittedCellCountBefore = fields.overlayCommittedCellCountBefore;
		this.overlayCommittedCellCountAfter = fields.overlayCommittedCellCountAfter;
		this.overlayCommittedCountSynced = fields.overlayCommittedCountSynced;
		this.deferredHistoryLineCountBefore = fields.deferredHistoryLineCountBefore;
		this.deferredHistoryLineCountAfter = fields.deferredHistoryLineCountAfter;
		this.deferredHistoryCleared = fields.deferredHistoryCleared;
		this.previewSelectionBefore = fields.previewSelectionBefore;
		this.previewSelectionAfter = fields.previewSelectionAfter;
		this.previewSelectionClamped = fields.previewSelectionClamped;
		this.agentCopyHistoryUserCountAfter = fields.agentCopyHistoryUserCountAfter;
		this.agentCopyHistoryTruncated = fields.agentCopyHistoryTruncated;
		this.backtrackRenderPending = fields.backtrackRenderPending;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveOnlyEffectsSuppressed = fields.liveOnlyEffectsSuppressed;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";numTurns=" + numTurns
			+ ";transcriptCellCountBefore=" + transcriptCellCountBefore + ";transcriptCellCountAfter=" + transcriptCellCountAfter + ";userCountBefore="
			+ userCountBefore + ";userCountAfter=" + userCountAfter + ";overlayActive=" + boolText(overlayActive) + ";overlayCommittedCellCountAfter="
			+ overlayCommittedCellCountAfter + ";overlayCommittedCountSynced=" + boolText(overlayCommittedCountSynced) + ";deferredHistoryLineCountBefore="
			+ deferredHistoryLineCountBefore + ";deferredHistoryLineCountAfter=" + deferredHistoryLineCountAfter + ";deferredHistoryCleared="
			+ boolText(deferredHistoryCleared) + ";previewSelectionBefore=" + noneIfNegative(previewSelectionBefore) + ";previewSelectionAfter="
			+ noneIfNegative(previewSelectionAfter) + ";previewSelectionClamped=" + boolText(previewSelectionClamped) + ";agentCopyHistoryUserCountAfter="
			+ agentCopyHistoryUserCountAfter + ";agentCopyHistoryTruncated=" + boolText(agentCopyHistoryTruncated) + ";backtrackRenderPending="
			+ boolText(backtrackRenderPending) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveOnlyEffectsSuppressed="
			+ boolText(liveOnlyEffectsSuppressed) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfNegative(value:Int):String {
		return value < 0 ? "none" : Std.string(value);
	}
}
