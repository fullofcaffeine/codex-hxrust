package codexhx.runtime.model.streamitem;

typedef ModelCollabReplayWaitItemFields = {
	final itemId:String;
	final receiverThreadId:String;
	final statusKind:ModelCollabReplayWaitStatusKind;
}

class ModelCollabReplayWaitItem {
	public final itemId:String;
	public final receiverThreadId:String;
	public final statusKind:ModelCollabReplayWaitStatusKind;

	public function new(fields:ModelCollabReplayWaitItemFields) {
		this.itemId = fields.itemId == null ? "" : fields.itemId;
		this.receiverThreadId = fields.receiverThreadId == null ? "" : fields.receiverThreadId;
		this.statusKind = fields.statusKind == null ? ModelCollabReplayWaitStatusKind.InProgress : fields.statusKind;
	}
}
