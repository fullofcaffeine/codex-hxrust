package codexhx.adapters.cafex;

class CafBridgeProcessOutcome {
	public final ok:Bool;
	public final processed:Int;
	public final skipped:Int;
	public final errorCode:String;
	public final errorMessage:String;

	function new(ok:Bool, processed:Int, skipped:Int, errorCode:String, errorMessage:String) {
		this.ok = ok;
		this.processed = processed;
		this.skipped = skipped;
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public static function success(processed:Int, skipped:Int):CafBridgeProcessOutcome {
		return new CafBridgeProcessOutcome(true, processed, skipped, "", "");
	}

	public static function failure(code:String, message:String):CafBridgeProcessOutcome {
		return new CafBridgeProcessOutcome(false, 0, 0, code, message);
	}
}
