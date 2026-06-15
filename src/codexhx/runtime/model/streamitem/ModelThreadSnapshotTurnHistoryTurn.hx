package codexhx.runtime.model.streamitem;

typedef ModelThreadSnapshotTurnHistoryTurnFields = {
	final turnId:String;
	final statusKind:ModelThreadSnapshotTurnStatusKind;
	final items:Array<ModelThreadSnapshotTurnHistoryItem>;
}

class ModelThreadSnapshotTurnHistoryTurn {
	public final turnId:String;
	public final statusKind:ModelThreadSnapshotTurnStatusKind;
	public final items:Array<ModelThreadSnapshotTurnHistoryItem>;

	public function new(fields:ModelThreadSnapshotTurnHistoryTurnFields) {
		this.turnId = fields.turnId == null ? "" : fields.turnId;
		this.statusKind = fields.statusKind == null ? ModelThreadSnapshotTurnStatusKind.Completed : fields.statusKind;
		this.items = fields.items == null ? [] : fields.items;
	}
}
