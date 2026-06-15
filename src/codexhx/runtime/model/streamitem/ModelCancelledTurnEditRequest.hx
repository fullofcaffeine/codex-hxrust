package codexhx.runtime.model.streamitem;

typedef ModelCancelledTurnEditRequestFields = {
	final requestId:String;
	final pendingRollback:Bool;
	final promptText:String;
	final promptTextElementCount:Int;
	final promptLocalImageCount:Int;
	final promptRemoteImageCount:Int;
	final promptRemoteImageUrl:String;
	final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelCancelledTurnEditRequest {
	public final requestId:String;
	public final pendingRollback:Bool;
	public final promptText:String;
	public final promptTextElementCount:Int;
	public final promptLocalImageCount:Int;
	public final promptRemoteImageCount:Int;
	public final promptRemoteImageUrl:String;
	public final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelCancelledTurnEditRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.pendingRollback = fields.pendingRollback;
		this.promptText = fields.promptText == null ? "" : fields.promptText;
		this.promptTextElementCount = fields.promptTextElementCount;
		this.promptLocalImageCount = fields.promptLocalImageCount;
		this.promptRemoteImageCount = fields.promptRemoteImageCount;
		this.promptRemoteImageUrl = fields.promptRemoteImageUrl == null ? "" : fields.promptRemoteImageUrl;
		this.transcriptCells = fields.transcriptCells == null ? [] : fields.transcriptCells;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
