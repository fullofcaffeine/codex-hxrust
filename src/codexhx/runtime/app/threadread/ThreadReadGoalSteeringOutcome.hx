package codexhx.runtime.app.threadread;

class ThreadReadGoalSteeringOutcome {
	public final ok:Bool;
	public final code:String;
	public final kind:ThreadReadGoalSteeringItemKind;
	public final emitted:Bool;
	public final skipped:Bool;
	public final item:ThreadReadGoalSteeringItem;
	public final message:String;

	function new(ok:Bool, code:String, kind:ThreadReadGoalSteeringItemKind, emitted:Bool, skipped:Bool, item:ThreadReadGoalSteeringItem, message:String) {
		this.ok = ok;
		this.code = code;
		this.kind = kind;
		this.emitted = emitted;
		this.skipped = skipped;
		this.item = item;
		this.message = message;
	}

	public static function makeEmitted(kind:ThreadReadGoalSteeringItemKind, item:ThreadReadGoalSteeringItem):ThreadReadGoalSteeringOutcome {
		return new ThreadReadGoalSteeringOutcome(true, "steering_item_emitted", kind, true, false, item, "goal steering contextual user fragment emitted");
	}

	public static function makeSkipped(kind:ThreadReadGoalSteeringItemKind, code:String, message:String):ThreadReadGoalSteeringOutcome {
		return new ThreadReadGoalSteeringOutcome(true, code, kind, false, true, null, message);
	}

	public static function failure(kind:ThreadReadGoalSteeringItemKind, code:String, message:String):ThreadReadGoalSteeringOutcome {
		return new ThreadReadGoalSteeringOutcome(false, code, kind, false, false, null, message);
	}

	public function itemSummary():String {
		return item == null ? "item=none" : "item={" + item.summary() + "}";
	}

	public function summary():String {
		return "kind=" + kind + ";ok=" + (ok ? "true" : "false") + ";code=" + code + ";emitted=" + (emitted ? "true" : "false") + ";skipped="
			+ (skipped ? "true" : "false") + ";" + itemSummary() + ";message=" + message;
	}
}
