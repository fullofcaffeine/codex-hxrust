package codexhx.runtime.app.threadread;

class ThreadReadTurnsPageOutcome {
	public final ok:Bool;
	public final code:String;
	public final message:String;
	public final page:Null<ThreadReadTurnsPage>;

	function new(ok:Bool, code:String, message:String, page:Null<ThreadReadTurnsPage>) {
		this.ok = ok;
		this.code = code;
		this.message = message;
		this.page = page;
	}

	public static function success(page:ThreadReadTurnsPage):ThreadReadTurnsPageOutcome {
		return new ThreadReadTurnsPageOutcome(true, "turns_page_built", "", page);
	}

	public static function failure(code:String, message:String):ThreadReadTurnsPageOutcome {
		return new ThreadReadTurnsPageOutcome(false, code, message, null);
	}

	public function summary():String {
		return "turns-page:" + code + ";ok=" + (ok ? "true" : "false") + (page == null ? "" : ";" + page.summary());
	}
}
