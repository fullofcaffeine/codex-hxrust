package codexhx.runtime.asyncruntime;

class DeterministicAsyncTask<T> implements AsyncTask<T> {
	var ready:Bool;
	var failedError:Null<AsyncError>;
	var cancelled:Bool;
	var reason:AsyncCancelReason;
	var value:Null<T>;

	public function new() {
		this.ready = false;
		this.failedError = null;
		this.cancelled = false;
		this.reason = AsyncCancelReason.TestFixture;
		this.value = null;
	}

	public function complete(value:T):Void {
		if (cancelled || failedError != null) return;
		this.ready = true;
		this.value = value;
	}

	public function fail(code:String, message:String, recoverable:Bool):Void {
		if (cancelled || ready) return;
		this.failedError = new AsyncError(code, message, recoverable);
	}

	public function poll(context:AsyncContext):AsyncPoll<T> {
		if (context.isCancelled()) return AsyncPoll.Cancelled(context.cancellation.cancelReason(), 0, 0);
		if (cancelled) return AsyncPoll.Cancelled(reason, 0, 0);
		if (failedError != null) return AsyncPoll.Failed(failedError, 0, 0);
		if (ready) return AsyncPoll.Ready(value, 0, 0);
		return AsyncPoll.Pending(0, 0);
	}

	public function cancel(reason:AsyncCancelReason):AsyncPoll<T> {
		this.cancelled = true;
		this.reason = reason;
		return AsyncPoll.Cancelled(reason, 0, 0);
	}
}
