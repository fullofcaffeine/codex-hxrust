package codexhx.runtime.app;

class RuntimeEventReadOutcome {
	public final ok:Bool;
	public final event:Null<CodexRuntimeEvent>;
	public final remainingCount:Int;

	function new(ok:Bool, event:Null<CodexRuntimeEvent>, remainingCount:Int) {
		this.ok = ok;
		this.event = event;
		this.remainingCount = remainingCount;
	}

	public static function found(event:CodexRuntimeEvent, remainingCount:Int):RuntimeEventReadOutcome {
		return new RuntimeEventReadOutcome(true, event, remainingCount);
	}

	public static function empty():RuntimeEventReadOutcome {
		return new RuntimeEventReadOutcome(false, null, 0);
	}
}
