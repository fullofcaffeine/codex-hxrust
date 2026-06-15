package codexhx.runtime.model.streamitem;

typedef ModelSideBacktrackUnavailableMessageRequestFields = {
	final requestId:String;
	final backtrackPrimedBefore:Bool;
	final rejectInvoked:Bool;
	final unavailableMessage:String;
	final renderedWidth:Int;
	final expectedSnapshotName:String;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelSideBacktrackUnavailableMessageRequest {
	public final requestId:String;
	public final backtrackPrimedBefore:Bool;
	public final rejectInvoked:Bool;
	public final unavailableMessage:String;
	public final renderedWidth:Int;
	public final expectedSnapshotName:String;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelSideBacktrackUnavailableMessageRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.backtrackPrimedBefore = fields.backtrackPrimedBefore;
		this.rejectInvoked = fields.rejectInvoked;
		this.unavailableMessage = fields.unavailableMessage == null ? "" : fields.unavailableMessage;
		this.renderedWidth = fields.renderedWidth;
		this.expectedSnapshotName = fields.expectedSnapshotName == null ? "" : fields.expectedSnapshotName;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
