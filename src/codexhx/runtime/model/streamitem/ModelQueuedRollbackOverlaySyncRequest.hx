package codexhx.runtime.model.streamitem;

typedef ModelQueuedRollbackOverlaySyncRequestFields = {
	final requestId:String;
	final numTurns:Int;
	final overlayActive:Bool;
	final overlayPreviewActive:Bool;
	final nthUserMessageBefore:Int;
	final deferredHistoryLineCountBefore:Int;
	final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelQueuedRollbackOverlaySyncRequest {
	public final requestId:String;
	public final numTurns:Int;
	public final overlayActive:Bool;
	public final overlayPreviewActive:Bool;
	public final nthUserMessageBefore:Int;
	public final deferredHistoryLineCountBefore:Int;
	public final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelQueuedRollbackOverlaySyncRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.numTurns = fields.numTurns;
		this.overlayActive = fields.overlayActive;
		this.overlayPreviewActive = fields.overlayPreviewActive;
		this.nthUserMessageBefore = fields.nthUserMessageBefore;
		this.deferredHistoryLineCountBefore = fields.deferredHistoryLineCountBefore;
		this.transcriptCells = fields.transcriptCells == null ? [] : fields.transcriptCells;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
