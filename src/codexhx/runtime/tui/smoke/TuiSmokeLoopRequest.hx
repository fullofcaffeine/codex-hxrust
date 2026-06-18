package codexhx.runtime.tui.smoke;

class TuiSmokeLoopRequest {
	public final name:String;
	public final frame:Null<TuiSmokeFrameRequest>;
	public final events:Array<TuiSmokeEvent>;
	public final expectedExit:TuiSmokeExitKind;
	public final expectedTrace:String;
	public final expectedSnapshot:String;

	public function new(
		name:String,
		frame:Null<TuiSmokeFrameRequest>,
		events:Array<TuiSmokeEvent>,
		expectedExit:TuiSmokeExitKind,
		expectedTrace:String,
		expectedSnapshot:String
	) {
		this.name = name == null ? "" : name;
		this.frame = frame;
		this.events = events == null ? [] : events;
		this.expectedExit = expectedExit == null ? TuiSmokeExitKind.Unknown : expectedExit;
		this.expectedTrace = expectedTrace == null ? "" : expectedTrace;
		this.expectedSnapshot = expectedSnapshot == null ? "" : expectedSnapshot;
	}
}
