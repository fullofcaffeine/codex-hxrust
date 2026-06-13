package codexhx.runtime.app.threadread;

class ThreadReadTurnItemSummary {
	public final kind:ThreadReadTurnItemKind;
	public final text:String;

	public function new(kind:ThreadReadTurnItemKind, text:String) {
		this.kind = kind;
		this.text = text;
	}

	public function summary():String {
		return kind + ":" + text;
	}
}
