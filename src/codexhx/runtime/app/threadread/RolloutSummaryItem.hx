package codexhx.runtime.app.threadread;

class RolloutSummaryItem {
	public final kind:RolloutSummaryItemKind;
	public final turnId:String;
	public final text:String;
	public final affectsTurnStatus:Bool;
	public final status:String;

	public function new(kind:RolloutSummaryItemKind, turnId:String, text:String, affectsTurnStatus:Bool, status:String) {
		this.kind = kind;
		this.turnId = turnId;
		this.text = text;
		this.affectsTurnStatus = affectsTurnStatus;
		this.status = status;
	}
}
