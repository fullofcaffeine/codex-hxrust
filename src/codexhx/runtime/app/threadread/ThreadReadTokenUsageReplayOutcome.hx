package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageReplayOutcome {
	public final ok:Bool;
	public final code:String;
	public final message:String;
	public final notification:Null<ThreadReadTokenUsageReplayNotification>;

	function new(ok:Bool, code:String, message:String, notification:Null<ThreadReadTokenUsageReplayNotification>) {
		this.ok = ok;
		this.code = code;
		this.message = message;
		this.notification = notification;
	}

	public static function emitted(notification:ThreadReadTokenUsageReplayNotification):ThreadReadTokenUsageReplayOutcome {
		return new ThreadReadTokenUsageReplayOutcome(true, "notification_ready", "restored token usage notification ready", notification);
	}

	public static function failure(code:String, message:String):ThreadReadTokenUsageReplayOutcome {
		return new ThreadReadTokenUsageReplayOutcome(false, code, message, null);
	}

	public function totalTokens():Int {
		return notification == null ? 0 : notification.tokenUsage.total.totalTokens;
	}

	public function lastTokens():Int {
		return notification == null ? 0 : notification.tokenUsage.last.totalTokens;
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false") + ";code=" + code + ";message=" + message + ";notification="
			+ (notification == null ? "none" : notification.summary());
	}
}
