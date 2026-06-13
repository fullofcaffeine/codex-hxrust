package codexhx.runtime.app.persistence;

class PersistedThreadReadOutcome {
	public final ok:Bool;
	public final code:String;
	public final message:String;
	public final view:Null<PersistedThreadReadView>;

	function new(ok:Bool, code:String, message:String, view:Null<PersistedThreadReadView>) {
		this.ok = ok;
		this.code = code;
		this.message = message;
		this.view = view;
	}

	public static function success(view:PersistedThreadReadView):PersistedThreadReadOutcome {
		return new PersistedThreadReadOutcome(true, "read_view_found", "", view);
	}

	public static function failure(code:String, message:String):PersistedThreadReadOutcome {
		return new PersistedThreadReadOutcome(false, code, message, null);
	}

	public function summary():String {
		return "read:" + code
			+ ";ok=" + (ok ? "true" : "false")
			+ (view == null ? "" : ";" + view.summary());
	}
}
