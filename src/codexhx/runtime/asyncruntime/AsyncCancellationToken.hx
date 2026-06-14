package codexhx.runtime.asyncruntime;

class AsyncCancellationToken {
	var cancelled:Bool;
	var reason:AsyncCancelReason;

	public function new() {
		this.cancelled = false;
		this.reason = AsyncCancelReason.TestFixture;
	}

	public function requestCancel(reason:AsyncCancelReason):Void {
		this.cancelled = true;
		this.reason = reason;
	}

	public function isCancelled():Bool {
		return cancelled;
	}

	public function cancelReason():AsyncCancelReason {
		return reason;
	}
}
