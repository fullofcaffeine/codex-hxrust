package codexhx.runtime.model.streamitem;

typedef ModelClearOnlyUiResetRequestFields = {
	final requestId:String;
	final threadId:String;
	final resetInvoked:Bool;
	final overlayPresentBefore:Bool;
	final transcriptCellCountBefore:Int;
	final deferredHistoryLineCountBefore:Int;
	final hasEmittedHistoryLinesBefore:Bool;
	final transcriptReflowEntryCountBefore:Int;
	final initialHistoryReplayBufferPresentBefore:Bool;
	final backtrackPrimedBefore:Bool;
	final backtrackOverlayPreviewActiveBefore:Bool;
	final backtrackPendingRollbackBefore:Bool;
	final backtrackRenderPendingBefore:Bool;
	final skillWarningCountBefore:Int;
	final chatSessionThreadPresentBefore:Bool;
	final composerDraftBefore:String;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelClearOnlyUiResetRequest {
	public final requestId:String;
	public final threadId:String;
	public final resetInvoked:Bool;
	public final overlayPresentBefore:Bool;
	public final transcriptCellCountBefore:Int;
	public final deferredHistoryLineCountBefore:Int;
	public final hasEmittedHistoryLinesBefore:Bool;
	public final transcriptReflowEntryCountBefore:Int;
	public final initialHistoryReplayBufferPresentBefore:Bool;
	public final backtrackPrimedBefore:Bool;
	public final backtrackOverlayPreviewActiveBefore:Bool;
	public final backtrackPendingRollbackBefore:Bool;
	public final backtrackRenderPendingBefore:Bool;
	public final skillWarningCountBefore:Int;
	public final chatSessionThreadPresentBefore:Bool;
	public final composerDraftBefore:String;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelClearOnlyUiResetRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.resetInvoked = fields.resetInvoked;
		this.overlayPresentBefore = fields.overlayPresentBefore;
		this.transcriptCellCountBefore = fields.transcriptCellCountBefore;
		this.deferredHistoryLineCountBefore = fields.deferredHistoryLineCountBefore;
		this.hasEmittedHistoryLinesBefore = fields.hasEmittedHistoryLinesBefore;
		this.transcriptReflowEntryCountBefore = fields.transcriptReflowEntryCountBefore;
		this.initialHistoryReplayBufferPresentBefore = fields.initialHistoryReplayBufferPresentBefore;
		this.backtrackPrimedBefore = fields.backtrackPrimedBefore;
		this.backtrackOverlayPreviewActiveBefore = fields.backtrackOverlayPreviewActiveBefore;
		this.backtrackPendingRollbackBefore = fields.backtrackPendingRollbackBefore;
		this.backtrackRenderPendingBefore = fields.backtrackRenderPendingBefore;
		this.skillWarningCountBefore = fields.skillWarningCountBefore;
		this.chatSessionThreadPresentBefore = fields.chatSessionThreadPresentBefore;
		this.composerDraftBefore = fields.composerDraftBefore == null ? "" : fields.composerDraftBefore;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
