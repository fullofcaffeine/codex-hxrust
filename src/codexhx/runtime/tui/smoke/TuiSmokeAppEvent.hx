package codexhx.runtime.tui.smoke;

class TuiSmokeAppEvent {
	public final kind:TuiSmokeAppEventKind;
	public final status:String;
	public final exitMode:TuiSmokeExitMode;

	public function new(kind:TuiSmokeAppEventKind, status:String, exitMode:TuiSmokeExitMode) {
		this.kind = kind == null ? TuiSmokeAppEventKind.Unknown : kind;
		this.status = status == null ? "" : status;
		this.exitMode = exitMode == null ? TuiSmokeExitMode.Unknown : exitMode;
	}
}
