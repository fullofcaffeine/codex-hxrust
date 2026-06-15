package codexhx.runtime.model.streamitem;

typedef ModelThreadSnapshotSessionRefreshTurnFields = {
	final turnId:String;
	final statusKind:ModelThreadSnapshotTurnStatusKind;
	final userText:String;
}

class ModelThreadSnapshotSessionRefreshTurn {
	public final turnId:String;
	public final statusKind:ModelThreadSnapshotTurnStatusKind;
	public final userText:String;

	public function new(fields:ModelThreadSnapshotSessionRefreshTurnFields) {
		this.turnId = fields.turnId == null ? "" : fields.turnId;
		this.statusKind = fields.statusKind == null ? ModelThreadSnapshotTurnStatusKind.Completed : fields.statusKind;
		this.userText = fields.userText == null ? "" : fields.userText;
	}
}
