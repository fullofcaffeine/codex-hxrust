package codexhx.runtime.model.streamitem;

typedef ModelThreadSnapshotCollabMetadataReplayRequestFields = {
	final requestId:String;
	final replayKind:ModelTurnReplayKind;
	final replacementCreatedBeforeReplay:Bool;
	final navigationEntries:Array<ModelCollabAgentMetadataEntry>;
	final waitItems:Array<ModelCollabReplayWaitItem>;
	final expectedAgentNickname:String;
	final expectedAgentRole:String;
	final secretProbe:String;
}

class ModelThreadSnapshotCollabMetadataReplayRequest {
	public final requestId:String;
	public final replayKind:ModelTurnReplayKind;
	public final replacementCreatedBeforeReplay:Bool;
	public final navigationEntries:Array<ModelCollabAgentMetadataEntry>;
	public final waitItems:Array<ModelCollabReplayWaitItem>;
	public final expectedAgentNickname:String;
	public final expectedAgentRole:String;
	public final secretProbe:String;

	public function new(fields:ModelThreadSnapshotCollabMetadataReplayRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.replayKind = fields.replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : fields.replayKind;
		this.replacementCreatedBeforeReplay = fields.replacementCreatedBeforeReplay;
		this.navigationEntries = fields.navigationEntries == null ? [] : fields.navigationEntries;
		this.waitItems = fields.waitItems == null ? [] : fields.waitItems;
		this.expectedAgentNickname = fields.expectedAgentNickname == null ? "" : fields.expectedAgentNickname;
		this.expectedAgentRole = fields.expectedAgentRole == null ? "" : fields.expectedAgentRole;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
