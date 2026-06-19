package codexhx.runtime.tui.smoke;

typedef TuiSmokeFrameSchedulerActionFields = {
	final kind:TuiSmokeFrameSchedulerActionKind;
	final source:String;
	final requestMs:Int;
	final delayMs:Int;
	final previousDeadlineMs:Int;
	final nextDeadlineMs:Int;
	final clampedDeadlineMs:Int;
	final lastEmittedMs:Int;
	final minIntervalMs:Int;
	final requestCount:Int;
	final coalescedCount:Int;
	final emittedCount:Int;
	final broadcastCapacity:Int;
	final spawnedTask:Bool;
	final drawSent:Bool;
	final lagged:Bool;
	final closed:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeFrameSchedulerAction {
	public final kind:TuiSmokeFrameSchedulerActionKind;
	@:recordDefault("unknown")
	public final source:String;
	public final requestMs:Int;
	public final delayMs:Int;
	public final previousDeadlineMs:Int;
	public final nextDeadlineMs:Int;
	public final clampedDeadlineMs:Int;
	public final lastEmittedMs:Int;
	public final minIntervalMs:Int;
	public final requestCount:Int;
	public final coalescedCount:Int;
	public final emittedCount:Int;
	public final broadcastCapacity:Int;
	public final spawnedTask:Bool;
	public final drawSent:Bool;
	public final lagged:Bool;
	public final closed:Bool;
	public final failureCode:String;

	public function previousDeadlineText():String {
		return deadlineText(previousDeadlineMs);
	}

	public function nextDeadlineText():String {
		return deadlineText(nextDeadlineMs);
	}

	public function deadlineText(value:Int):String {
		return value < 0 ? "none" : value + "ms";
	}
}
