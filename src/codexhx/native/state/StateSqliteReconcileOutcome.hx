package codexhx.native.state;

class StateSqliteReconcileOutcome {
	public final ok:Bool;
	public final code:String;
	public final backend:String;
	public final message:String;
	public final rowCount:Int;
	public final row:Null<NativeStateRow>;

	function new(ok:Bool, code:String, backend:String, message:String, rowCount:Int, row:Null<NativeStateRow>) {
		this.ok = ok;
		this.code = code;
		this.backend = backend;
		this.message = message;
		this.rowCount = rowCount;
		this.row = row;
	}

	public static function success(backend:String, rowCount:Int, row:NativeStateRow):StateSqliteReconcileOutcome {
		return new StateSqliteReconcileOutcome(true, "reconciled", backend, "", rowCount, row);
	}

	public static function failure(code:String, backend:String, message:String, rowCount:Int):StateSqliteReconcileOutcome {
		return new StateSqliteReconcileOutcome(false, code, backend, message, rowCount, null);
	}

	public function summary():String {
		return (row == null ? "" : row.summary());
	}
}
