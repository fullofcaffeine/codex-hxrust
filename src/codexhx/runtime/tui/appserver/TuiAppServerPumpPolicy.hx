package codexhx.runtime.tui.appserver;

/**
	Drain policy for the minimal app-server event pump.

	This is a synchronous stand-in for the later async/channel boundary: lossless
	drains process every queued event, while bounded drains leave remaining work
	queued and report backpressure without dropping events.
**/
class TuiAppServerPumpPolicy {
	public final maxEventsPerDrain:Int;
	public final cancellationRequested:Bool;

	public function new(maxEventsPerDrain:Int, cancellationRequested:Bool) {
		this.maxEventsPerDrain = maxEventsPerDrain < 0 ? 0 : maxEventsPerDrain;
		this.cancellationRequested = cancellationRequested;
	}

	public static function lossless():TuiAppServerPumpPolicy {
		return new TuiAppServerPumpPolicy(0, false);
	}

	public static function bounded(maxEventsPerDrain:Int):TuiAppServerPumpPolicy {
		return new TuiAppServerPumpPolicy(maxEventsPerDrain, false);
	}

	public static function cancelled():TuiAppServerPumpPolicy {
		return new TuiAppServerPumpPolicy(0, true);
	}

	public function allowsAnother(processed:Int):Bool {
		if (cancellationRequested)
			return false;
		return maxEventsPerDrain == 0 || processed < maxEventsPerDrain;
	}
}
