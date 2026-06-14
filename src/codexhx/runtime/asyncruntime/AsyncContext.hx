package codexhx.runtime.asyncruntime;

class AsyncContext {
	public final stepId:String;
	public final maxReadyItems:Int;
	public final cancellation:AsyncCancellationToken;

	public function new(stepId:String, maxReadyItems:Int, cancellation:AsyncCancellationToken) {
		this.stepId = stepId;
		this.maxReadyItems = maxReadyItems < 1 ? 1 : maxReadyItems;
		this.cancellation = cancellation;
	}

	public static function fixture(stepId:String):AsyncContext {
		return new AsyncContext(stepId, 1, new AsyncCancellationToken());
	}

	public function isCancelled():Bool {
		return cancellation.isCancelled();
	}
}
