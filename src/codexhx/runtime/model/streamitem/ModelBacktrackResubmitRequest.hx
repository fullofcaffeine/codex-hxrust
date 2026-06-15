package codexhx.runtime.model.streamitem;

typedef ModelBacktrackResubmitRequestFields = {
	final requestId:String;
	final sessionConfigured:Bool;
	final modelSupportsImages:Bool;
	final nthUserMessage:Int;
	final selectionPrefill:String;
	final selectedRemoteImageCount:Int;
	final selectedRemoteImageUrl:String;
	final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelBacktrackResubmitRequest {
	public final requestId:String;
	public final sessionConfigured:Bool;
	public final modelSupportsImages:Bool;
	public final nthUserMessage:Int;
	public final selectionPrefill:String;
	public final selectedRemoteImageCount:Int;
	public final selectedRemoteImageUrl:String;
	public final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelBacktrackResubmitRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.sessionConfigured = fields.sessionConfigured;
		this.modelSupportsImages = fields.modelSupportsImages;
		this.nthUserMessage = fields.nthUserMessage;
		this.selectionPrefill = fields.selectionPrefill == null ? "" : fields.selectionPrefill;
		this.selectedRemoteImageCount = fields.selectedRemoteImageCount;
		this.selectedRemoteImageUrl = fields.selectedRemoteImageUrl == null ? "" : fields.selectedRemoteImageUrl;
		this.transcriptCells = fields.transcriptCells == null ? [] : fields.transcriptCells;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
