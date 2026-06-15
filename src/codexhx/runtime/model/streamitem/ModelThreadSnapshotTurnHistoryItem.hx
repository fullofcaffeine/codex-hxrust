package codexhx.runtime.model.streamitem;

typedef ModelThreadSnapshotTurnHistoryItemFields = {
	final itemKind:ModelThreadSnapshotTurnHistoryItemKind;
	final itemId:String;
	final text:String;
}

class ModelThreadSnapshotTurnHistoryItem {
	public final itemKind:ModelThreadSnapshotTurnHistoryItemKind;
	public final itemId:String;
	public final text:String;

	public function new(fields:ModelThreadSnapshotTurnHistoryItemFields) {
		this.itemKind = fields.itemKind == null ? ModelThreadSnapshotTurnHistoryItemKind.Other : fields.itemKind;
		this.itemId = fields.itemId == null ? "" : fields.itemId;
		this.text = fields.text == null ? "" : fields.text;
	}
}
