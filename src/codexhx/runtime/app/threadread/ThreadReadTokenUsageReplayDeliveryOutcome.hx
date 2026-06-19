package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageReplayDeliveryOutcome {
	public final ok:Bool;
	public final code:String;
	public final operation:ThreadReadTokenUsageReplayDeliveryOperation;
	public final delivered:Bool;
	public final skipped:Bool;
	public final connectionId:String;
	public final targetedConnectionCount:Int;
	public final broadcast:Bool;
	public final sequence:String;
	public final message:String;

	function new(ok:Bool, code:String, operation:ThreadReadTokenUsageReplayDeliveryOperation, delivered:Bool, skipped:Bool, connectionId:String,
			targetedConnectionCount:Int, broadcast:Bool, sequence:String, message:String) {
		this.ok = ok;
		this.code = code;
		this.operation = operation;
		this.delivered = delivered;
		this.skipped = skipped;
		this.connectionId = connectionId;
		this.targetedConnectionCount = targetedConnectionCount;
		this.broadcast = broadcast;
		this.sequence = sequence;
		this.message = message;
	}

	public static function makeDelivered(operation:ThreadReadTokenUsageReplayDeliveryOperation, connectionId:String):ThreadReadTokenUsageReplayDeliveryOutcome {
		return new ThreadReadTokenUsageReplayDeliveryOutcome(true, "delivered", operation, true, false, connectionId, 1, false,
			"response->thread/tokenUsage/updated", "restored token usage notification delivered to requesting connection");
	}

	public static function makeSkipped(operation:ThreadReadTokenUsageReplayDeliveryOperation, code:String,
			message:String):ThreadReadTokenUsageReplayDeliveryOutcome {
		return new ThreadReadTokenUsageReplayDeliveryOutcome(true, code, operation, false, true, "", 0, false, "response", message);
	}

	public static function failure(operation:ThreadReadTokenUsageReplayDeliveryOperation, code:String,
			message:String):ThreadReadTokenUsageReplayDeliveryOutcome {
		return new ThreadReadTokenUsageReplayDeliveryOutcome(false, code, operation, false, false, "", 0, false, "none", message);
	}

	public function recipientSummary():String {
		return delivered ? "targeted=" + Std.string(targetedConnectionCount) + ";connection=" + connectionId + ";broadcast=" +
			(broadcast ? "true" : "false") : "targeted=0;connection=none;broadcast=false";
	}

	public function summary():String {
		return "operation=" + operation + ";ok=" + (ok ? "true" : "false") + ";code=" + code + ";delivered=" + (delivered ? "true" : "false") + ";skipped="
			+ (skipped ? "true" : "false") + ";sequence=" + sequence + ";" + recipientSummary() + ";message=" + message;
	}
}
