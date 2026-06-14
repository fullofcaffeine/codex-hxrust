package codexhx.runtime.asyncruntime;

interface AsyncTask<T> {
	function poll(context:AsyncContext):AsyncPoll<T>;
	function cancel(reason:AsyncCancelReason):AsyncPoll<T>;
}
