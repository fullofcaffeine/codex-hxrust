package codexhx.runtime.tui.smoke;

typedef TuiSmokeEventFields = {
	final kind:TuiSmokeEventKind;
	final key:TuiSmokeKeyKind;
	final status:String;
	final input:String;
	final exitMode:TuiSmokeExitMode;
	final appEvent:Null<TuiSmokeAppEvent>;
}

class TuiSmokeEvent {
	public final kind:TuiSmokeEventKind;
	public final key:TuiSmokeKeyKind;
	public final status:String;
	public final input:String;
	public final exitMode:TuiSmokeExitMode;
	public final appEvent:Null<TuiSmokeAppEvent>;

	public function new(fields:TuiSmokeEventFields) {
		this.kind = fields.kind == null ? TuiSmokeEventKind.Unknown : fields.kind;
		this.key = fields.key == null ? TuiSmokeKeyKind.Unknown : fields.key;
		this.status = fields.status == null ? "" : fields.status;
		this.input = fields.input == null ? "" : fields.input;
		this.exitMode = fields.exitMode == null ? TuiSmokeExitMode.Unknown : fields.exitMode;
		this.appEvent = fields.appEvent;
	}
}
