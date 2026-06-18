package codexhx.runtime.tui.smoke;

class TuiSmokeAppEventQueue {
	final events:Array<TuiSmokeAppEvent>;
	var loggedCount:Int;

	public function new() {
		this.events = [];
		this.loggedCount = 0;
	}

	public function send(event:TuiSmokeAppEvent):Bool {
		if (event == null || event.kind == TuiSmokeAppEventKind.Unknown) return false;
		events.push(event);
		loggedCount = loggedCount + 1;
		return true;
	}

	public function hasNext():Bool {
		return events.length > 0;
	}

	public function next():Null<TuiSmokeAppEvent> {
		if (events.length == 0) return null;
		final event = events[0];
		events.splice(0, 1);
		return event;
	}

	public function logged():Int {
		return loggedCount;
	}
}
