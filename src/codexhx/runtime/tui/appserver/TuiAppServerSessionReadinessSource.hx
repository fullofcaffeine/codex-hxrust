package codexhx.runtime.tui.appserver;

/**
	Deterministic app-server session boundary for readiness notifications.

	This models the session-facing side that will eventually be driven by live
	JSON-RPC transport readiness. For now it is a typed in-memory source so the
	live shell runner can prove the boundary shape without sockets, async tasks,
	provider traffic, persistence, or tool execution.
**/
class TuiAppServerSessionReadinessSource {
	final events:Array<TuiAppServerReadinessEvent>;
	var nextIndex:Int;

	public function new(events:Array<TuiAppServerReadinessEvent>) {
		this.events = events == null ? [] : events.copy();
		this.nextIndex = 0;
	}

	public static function queued(events:Array<TuiAppServerReadinessEvent>):TuiAppServerSessionReadinessSource {
		return new TuiAppServerSessionReadinessSource(events);
	}

	public static function submittedTurnLateJsonlReady(maxLinesPerBatch:Int, maxBatches:Int):TuiAppServerSessionReadinessSource {
		return queued([
			TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(maxLinesPerBatch, maxBatches)
		]);
	}

	public function nextReadinessEvent():Null<TuiAppServerReadinessEvent> {
		if (nextIndex >= events.length)
			return null;
		final event = events[nextIndex];
		nextIndex = nextIndex + 1;
		return event;
	}

	public function remaining():Int {
		final count = events.length - nextIndex;
		return count < 0 ? 0 : count;
	}

	public function sourceKindText():String {
		return "app_server_session";
	}
}
