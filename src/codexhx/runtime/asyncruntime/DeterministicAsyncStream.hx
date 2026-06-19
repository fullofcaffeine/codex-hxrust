package codexhx.runtime.asyncruntime;

class DeterministicAsyncStream<T> implements AsyncStream<T> {
	final capacity:Int;
	final items:Array<AsyncStreamItem<T>>;
	var nextSequence:Int;
	var skippedBestEffort:Int;
	var closed:Bool;
	var cancelled:Bool;
	var reason:AsyncCancelReason;
	var failedError:Null<AsyncError>;

	public function new(capacity:Int) {
		this.capacity = capacity < 1 ? 1 : capacity;
		this.items = [];
		this.nextSequence = 1;
		this.skippedBestEffort = 0;
		this.closed = false;
		this.cancelled = false;
		this.reason = AsyncCancelReason.TestFixture;
		this.failedError = null;
	}

	public function push(value:T, delivery:AsyncDeliveryKind):AsyncPoll<Bool> {
		if (cancelled)
			return AsyncPoll.Cancelled(reason, items.length, skippedBestEffort);
		if (closed)
			return AsyncPoll.Failed(new AsyncError("stream_closed", "cannot push after close", false), items.length, skippedBestEffort);
		if (failedError != null)
			return AsyncPoll.Failed(failedError, items.length, skippedBestEffort);
		if (items.length >= capacity) {
			if (delivery == AsyncDeliveryKind.BestEffort)
				skippedBestEffort = skippedBestEffort + 1;
			final code = delivery == AsyncDeliveryKind.BestEffort ? "best_effort_dropped" : "lossless_backpressure";
			return AsyncPoll.Backpressured(new AsyncError(code, "bounded async stream has no ready capacity", true), items.length, skippedBestEffort);
		}
		items.push(new AsyncStreamItem<T>(nextSeq(), delivery, value));
		return AsyncPoll.Ready(true, items.length, skippedBestEffort);
	}

	public function close():Void {
		this.closed = true;
	}

	public function fail(code:String, message:String, recoverable:Bool):Void {
		this.failedError = new AsyncError(code, message, recoverable);
	}

	public function pollNext(context:AsyncContext):AsyncPoll<AsyncStreamItem<T>> {
		if (context.isCancelled())
			return AsyncPoll.Cancelled(context.cancellation.cancelReason(), items.length, skippedBestEffort);
		if (cancelled)
			return AsyncPoll.Cancelled(reason, items.length, skippedBestEffort);
		if (items.length > 0) {
			final item = items[0];
			items.splice(0, 1);
			return AsyncPoll.Ready(item, items.length, skippedBestEffort);
		}
		if (failedError != null)
			return AsyncPoll.Failed(failedError, items.length, skippedBestEffort);
		if (closed)
			return AsyncPoll.Closed(items.length, skippedBestEffort);
		return AsyncPoll.Pending(items.length, skippedBestEffort);
	}

	public function cancel(reason:AsyncCancelReason):AsyncPoll<AsyncStreamItem<T>> {
		this.cancelled = true;
		this.reason = reason;
		return AsyncPoll.Cancelled(reason, items.length, skippedBestEffort);
	}

	public function pendingCount():Int {
		return items.length;
	}

	public function skippedCount():Int {
		return skippedBestEffort;
	}

	function nextSeq():Int {
		final value = nextSequence;
		nextSequence = nextSequence + 1;
		return value;
	}
}
