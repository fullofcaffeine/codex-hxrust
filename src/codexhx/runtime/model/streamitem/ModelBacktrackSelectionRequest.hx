package codexhx.runtime.model.streamitem;

typedef ModelBacktrackSelectionRequestFields = {
	final requestId:String;
	final primed:Bool;
	final hasBaseThread:Bool;
	final pendingRollback:Bool;
	final nthUserMessage:Int;
	final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelBacktrackSelectionRequest {
	public final requestId:String;
	public final primed:Bool;
	public final hasBaseThread:Bool;
	public final pendingRollback:Bool;
	public final nthUserMessage:Int;
	public final transcriptCells:Array<ModelBacktrackTranscriptCell>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelBacktrackSelectionRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.primed = fields.primed;
		this.hasBaseThread = fields.hasBaseThread;
		this.pendingRollback = fields.pendingRollback;
		this.nthUserMessage = fields.nthUserMessage;
		this.transcriptCells = fields.transcriptCells == null ? [] : fields.transcriptCells;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
