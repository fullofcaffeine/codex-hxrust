package codexhx.runtime.asyncruntime;

class AsyncPollSummary {
	public static function summary<T>(poll:AsyncPoll<T>):String {
		return switch poll {
			case Pending(pendingCount, skippedCount):
				format(AsyncPollKind.Pending, AsyncCancelReason.TestFixture, pendingCount, skippedCount, null);
			case Ready(_, pendingCount, skippedCount):
				format(AsyncPollKind.Ready, AsyncCancelReason.TestFixture, pendingCount, skippedCount, null);
			case Failed(error, pendingCount, skippedCount):
				format(AsyncPollKind.Failed, AsyncCancelReason.TestFixture, pendingCount, skippedCount, error);
			case Cancelled(reason, pendingCount, skippedCount):
				format(AsyncPollKind.Cancelled, reason, pendingCount, skippedCount, null);
			case Closed(pendingCount, skippedCount):
				format(AsyncPollKind.Closed, AsyncCancelReason.TestFixture, pendingCount, skippedCount, null);
			case Backpressured(error, pendingCount, skippedCount):
				format(AsyncPollKind.Backpressured, AsyncCancelReason.TestFixture, pendingCount, skippedCount, error);
		}
	}

	public static function stringValue(poll:AsyncPoll<String>):String {
		return switch poll {
			case Ready(value, _, _): value;
			case _: "none";
		}
	}

	static function format(kind:AsyncPollKind, reason:AsyncCancelReason, pendingCount:Int, skippedCount:Int, error:Null<AsyncError>):String {
		final errorSummary = error == null ? "none" : error.summary();
		return "kind=" + kind + ";cancelReason=" + reason + ";pending=" + Std.string(pendingCount) + ";skipped=" + Std.string(skippedCount) + ";error="
			+ errorSummary;
	}
}
