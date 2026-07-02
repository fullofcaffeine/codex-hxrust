package codexhx.runtime.tui.live;

import codexhx.runtime.tui.appserver.TuiAppServerReadinessEvent;

/**
	Deterministic source of app-server readiness events for the live shell loop.

	This is the runner-owned bridge between request-prequeued readiness fixtures
	and a future live app-server readiness producer. The current implementation is
	a typed in-memory source so interpreter and generated-Rust gates can prove the
	loop polls a source without opening sockets or spawning async tasks.
**/
class TuiLiveShellReadinessSource {
	final events:Array<TuiAppServerReadinessEvent>;
	var nextIndex:Int;

	public function new(events:Array<TuiAppServerReadinessEvent>) {
		this.events = events == null ? [] : events.copy();
		this.nextIndex = 0;
	}

	public static function empty():TuiLiveShellReadinessSource {
		return new TuiLiveShellReadinessSource([]);
	}

	public static function queued(events:Array<TuiAppServerReadinessEvent>):TuiLiveShellReadinessSource {
		return new TuiLiveShellReadinessSource(events);
	}

	public function nextEvent():Null<TuiAppServerReadinessEvent> {
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
}
