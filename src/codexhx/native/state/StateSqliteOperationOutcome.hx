package codexhx.native.state;

class StateSqliteOperationOutcome {
	public final ok:Bool;
	public final operation:String;
	public final code:String;
	public final backend:String;
	public final message:String;
	public final rowCount:Int;
	public final row:Null<NativeStateRow>;

	function new(ok:Bool, operation:String, code:String, backend:String, message:String, rowCount:Int, row:Null<NativeStateRow>) {
		this.ok = ok;
		this.operation = operation;
		this.code = code;
		this.backend = backend;
		this.message = message;
		this.rowCount = rowCount;
		this.row = row;
	}

	public static function success(operation:String, code:String, backend:String, rowCount:Int, row:NativeStateRow):StateSqliteOperationOutcome {
		return new StateSqliteOperationOutcome(true, operation, code, backend, "", rowCount, row);
	}

	public static function failure(operation:String, code:String, backend:String, message:String, rowCount:Int):StateSqliteOperationOutcome {
		return new StateSqliteOperationOutcome(false, operation, code, backend, message, rowCount, null);
	}

	public static function fromReconcile(outcome:StateSqliteReconcileOutcome):StateSqliteOperationOutcome {
		if (outcome.ok) {
			if (outcome.row == null) {
				return failure("reconcile", "missing_reconciled_row", outcome.backend, "reconcile succeeded without a metadata row", outcome.rowCount);
			}
			return success("reconcile", outcome.code, outcome.backend, outcome.rowCount, outcome.row);
		}
		return failure("reconcile", outcome.code, outcome.backend, outcome.message, outcome.rowCount);
	}

	public function summary():String {
		return operation
			+ ":"
			+ code
			+ ";ok="
			+ (ok ? "true" : "false")
			+ ";rows="
			+ Std.string(rowCount)
			+ (row == null ? "" : ";" + row.summary());
	}
}
