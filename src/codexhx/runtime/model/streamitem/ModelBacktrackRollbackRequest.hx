package codexhx.runtime.model.streamitem;

typedef ModelBacktrackRollbackRequestFields = {
	final requestId:String;
	final pendingRollback:Bool;
	final nthUserMessage:Int;
	final selectionPrefill:String;
	final selectedTextElementCount:Int;
	final selectedLocalImageCount:Int;
	final selectedRemoteImageCount:Int;
	final selectedRemoteImageUrl:String;
	final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	final composerDraftBefore:String;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelBacktrackRollbackRequest {
	public final requestId:String;
	public final pendingRollback:Bool;
	public final nthUserMessage:Int;
	public final selectionPrefill:String;
	public final selectedTextElementCount:Int;
	public final selectedLocalImageCount:Int;
	public final selectedRemoteImageCount:Int;
	public final selectedRemoteImageUrl:String;
	public final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	public final composerDraftBefore:String;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelBacktrackRollbackRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.pendingRollback = fields.pendingRollback;
		this.nthUserMessage = fields.nthUserMessage;
		this.selectionPrefill = fields.selectionPrefill == null ? "" : fields.selectionPrefill;
		this.selectedTextElementCount = fields.selectedTextElementCount;
		this.selectedLocalImageCount = fields.selectedLocalImageCount;
		this.selectedRemoteImageCount = fields.selectedRemoteImageCount;
		this.selectedRemoteImageUrl = fields.selectedRemoteImageUrl == null ? "" : fields.selectedRemoteImageUrl;
		this.transcriptCells = fields.transcriptCells == null ? [] : fields.transcriptCells;
		this.composerDraftBefore = fields.composerDraftBefore == null ? "" : fields.composerDraftBefore;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
