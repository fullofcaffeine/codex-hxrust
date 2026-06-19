package codexhx.runtime.tui.turn;

class TurnPlanItem {
	public final label:String;
	public final status:String;

	public function new(label:String, status:String) {
		this.label = label;
		this.status = status;
	}

	public function fingerprint():String {
		return status + ":" + label;
	}
}
