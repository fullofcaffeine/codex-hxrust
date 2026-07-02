package codexhx.runtime.tui.live;

import codexhx.runtime.tui.appserver.TuiAppServerReadinessEvent;
import codexhx.runtime.tui.appserver.TuiAppServerSessionReadinessSource;

/**
	Deterministic source of app-server readiness events for the live shell loop.

	This is the runner-owned bridge between request-prequeued readiness fixtures
	and a future live app-server readiness producer. The current implementation is
	a typed in-memory source so interpreter and generated-Rust gates can prove the
	loop polls a source without opening sockets or spawning async tasks.
**/
class TuiLiveShellReadinessSource {
	final events:Array<TuiAppServerReadinessEvent>;
	final appServerSessionSource:TuiAppServerSessionReadinessSource;
	var nextIndex:Int;

	public function new(events:Array<TuiAppServerReadinessEvent>, ?appServerSessionSource:TuiAppServerSessionReadinessSource) {
		this.events = events == null ? [] : events.copy();
		this.appServerSessionSource = appServerSessionSource;
		this.nextIndex = 0;
	}

	public static function empty():TuiLiveShellReadinessSource {
		return new TuiLiveShellReadinessSource([]);
	}

	public static function queued(events:Array<TuiAppServerReadinessEvent>):TuiLiveShellReadinessSource {
		return new TuiLiveShellReadinessSource(events);
	}

	public static function fromAppServerSession(source:TuiAppServerSessionReadinessSource):TuiLiveShellReadinessSource {
		return new TuiLiveShellReadinessSource([], source);
	}

	public function nextEvent():Null<TuiAppServerReadinessEvent> {
		if (nextIndex < events.length) {
			final event = events[nextIndex];
			nextIndex = nextIndex + 1;
			return event;
		}
		if (appServerSessionSource == null)
			return null;
		return appServerSessionSource.nextReadinessEvent();
	}

	public function remaining():Int {
		final eventCount = events.length - nextIndex;
		final queuedCount = eventCount < 0 ? 0 : eventCount;
		final sessionCount = appServerSessionSource == null ? 0 : appServerSessionSource.remaining();
		return queuedCount + sessionCount;
	}
}
