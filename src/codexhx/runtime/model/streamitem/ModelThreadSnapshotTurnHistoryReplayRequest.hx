package codexhx.runtime.model.streamitem;

typedef ModelThreadSnapshotTurnHistoryReplayRequestFields = {
	final requestId:String;
	final replayKind:ModelTurnReplayKind;
	final sessionAvailable:Bool;
	final resumeRestoredQueue:Bool;
	final turns:Array<ModelThreadSnapshotTurnHistoryTurn>;
	final expectedUserMessages:Array<String>;
	final expectedAgentMessages:Array<String>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelThreadSnapshotTurnHistoryReplayRequest {
	public final requestId:String;
	public final replayKind:ModelTurnReplayKind;
	public final sessionAvailable:Bool;
	public final resumeRestoredQueue:Bool;
	public final turns:Array<ModelThreadSnapshotTurnHistoryTurn>;
	public final expectedUserMessages:Array<String>;
	public final expectedAgentMessages:Array<String>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelThreadSnapshotTurnHistoryReplayRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.replayKind = fields.replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : fields.replayKind;
		this.sessionAvailable = fields.sessionAvailable;
		this.resumeRestoredQueue = fields.resumeRestoredQueue;
		this.turns = fields.turns == null ? [] : fields.turns;
		this.expectedUserMessages = fields.expectedUserMessages == null ? [] : fields.expectedUserMessages;
		this.expectedAgentMessages = fields.expectedAgentMessages == null ? [] : fields.expectedAgentMessages;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
