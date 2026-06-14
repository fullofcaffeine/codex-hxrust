package codexhx.runtime.asyncruntime;

enum AsyncPoll<T> {
	Pending(pendingCount:Int, skippedCount:Int);
	Ready(value:T, pendingCount:Int, skippedCount:Int);
	Failed(error:AsyncError, pendingCount:Int, skippedCount:Int);
	Cancelled(reason:AsyncCancelReason, pendingCount:Int, skippedCount:Int);
	Closed(pendingCount:Int, skippedCount:Int);
	Backpressured(error:AsyncError, pendingCount:Int, skippedCount:Int);
}
