package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;

/**
	Drain policy for the minimal app-server event pump.

	This is a synchronous stand-in for the later async/channel boundary: lossless
	drains process every queued event, while bounded drains leave remaining work
	queued and report backpressure without dropping events.
**/
class TuiAppServerPumpPolicy {
	public final maxEventsPerDrain:Int;
	public final cancellationRequested:Bool;
	public final lateJsonlDrainEnabled:Bool;
	public final lateJsonlMaxLinesPerBatch:Int;
	public final lateJsonlMaxBatches:Int;
	public final interruptBeforeLateJsonlDrainEnabled:Bool;

	final interruptBeforeLateJsonlDrainRequestIdValue:Null<RequestId>;

	public function new(maxEventsPerDrain:Int, cancellationRequested:Bool, lateJsonlDrainEnabled:Bool, lateJsonlMaxLinesPerBatch:Int, lateJsonlMaxBatches:Int,
			interruptBeforeLateJsonlDrainEnabled:Bool, interruptBeforeLateJsonlDrainRequestId:Null<RequestId>) {
		this.maxEventsPerDrain = maxEventsPerDrain < 0 ? 0 : maxEventsPerDrain;
		this.cancellationRequested = cancellationRequested;
		this.lateJsonlDrainEnabled = lateJsonlDrainEnabled;
		this.lateJsonlMaxLinesPerBatch = lateJsonlMaxLinesPerBatch;
		this.lateJsonlMaxBatches = lateJsonlMaxBatches;
		this.interruptBeforeLateJsonlDrainEnabled = interruptBeforeLateJsonlDrainEnabled;
		this.interruptBeforeLateJsonlDrainRequestIdValue = interruptBeforeLateJsonlDrainRequestId;
	}

	public static function lossless():TuiAppServerPumpPolicy {
		return withoutLateJsonlDrain(0, false);
	}

	public static function bounded(maxEventsPerDrain:Int):TuiAppServerPumpPolicy {
		return withoutLateJsonlDrain(maxEventsPerDrain, false);
	}

	public static function cancelled():TuiAppServerPumpPolicy {
		return withoutLateJsonlDrain(0, true);
	}

	public static function withSubmittedTurnLateJsonlDrain(maxLinesPerBatch:Int, maxBatches:Int):TuiAppServerPumpPolicy {
		return new TuiAppServerPumpPolicy(0, false, true, maxLinesPerBatch, maxBatches, false, null);
	}

	public static function boundedWithSubmittedTurnLateJsonlDrain(maxEventsPerDrain:Int, maxLinesPerBatch:Int, maxBatches:Int):TuiAppServerPumpPolicy {
		return new TuiAppServerPumpPolicy(maxEventsPerDrain, false, true, maxLinesPerBatch, maxBatches, false, null);
	}

	public static function withSubmittedTurnInterruptBeforeLateJsonlDrain(maxLinesPerBatch:Int, maxBatches:Int,
			interruptRequestId:RequestId):TuiAppServerPumpPolicy {
		return new TuiAppServerPumpPolicy(0, false, true, maxLinesPerBatch, maxBatches, true, interruptRequestId);
	}

	static function withoutLateJsonlDrain(maxEventsPerDrain:Int, cancellationRequested:Bool):TuiAppServerPumpPolicy {
		return new TuiAppServerPumpPolicy(maxEventsPerDrain, cancellationRequested, false, 0, 0, false, null);
	}

	public function allowsAnother(processed:Int):Bool {
		if (cancellationRequested)
			return false;
		return maxEventsPerDrain == 0 || processed < maxEventsPerDrain;
	}

	public function shouldDrainSubmittedTurnLateJsonl():Bool {
		return lateJsonlDrainEnabled && !cancellationRequested;
	}

	public function shouldInterruptSubmittedTurnBeforeLateJsonlDrain():Bool {
		return shouldDrainSubmittedTurnLateJsonl()
			&& interruptBeforeLateJsonlDrainEnabled
			&& interruptBeforeLateJsonlDrainRequestIdValue != null;
	}

	public function interruptBeforeLateJsonlDrainRequestId():Null<RequestId> {
		return interruptBeforeLateJsonlDrainRequestIdValue;
	}
}
