package codexhx.runtime.asyncruntime;

interface AsyncStream<T> {
	function pollNext(context:AsyncContext):AsyncPoll<AsyncStreamItem<T>>;
	function cancel(reason:AsyncCancelReason):AsyncPoll<AsyncStreamItem<T>>;
}
