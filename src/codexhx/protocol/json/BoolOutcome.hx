package codexhx.protocol.json;

class BoolOutcome {
	public final ok:Bool;
	public final value:Bool;
	public final errorCode:String;
	public final errorPath:String;
	public final errorMessage:String;

	function new(ok:Bool, value:Bool, errorCode:String, errorPath:String, errorMessage:String) {
		this.ok = ok;
		this.value = value;
		this.errorCode = errorCode;
		this.errorPath = errorPath;
		this.errorMessage = errorMessage;
	}

	public static function success(value:Bool):BoolOutcome {
		return new BoolOutcome(true, value, "", "", "");
	}

	public static function failure(code:String, path:String, message:String):BoolOutcome {
		return new BoolOutcome(false, false, code, path, message);
	}
}
