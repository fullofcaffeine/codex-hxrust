package codexhx.protocol.app;

class AppProtocolParseOutcome {
	public final ok:Bool;
	public final message:AppProtocolMessage;
	public final errorCode:String;
	public final errorPath:String;
	public final errorMessage:String;

	function new(ok:Bool, message:AppProtocolMessage, errorCode:String, errorPath:String, errorMessage:String) {
		this.ok = ok;
		this.message = message;
		this.errorCode = errorCode;
		this.errorPath = errorPath;
		this.errorMessage = errorMessage;
	}

	public static function success(message:AppProtocolMessage):AppProtocolParseOutcome {
		return new AppProtocolParseOutcome(true, message, "", "", "");
	}

	public static function failure(code:String, path:String, message:String):AppProtocolParseOutcome {
		return new AppProtocolParseOutcome(false, AppProtocolMessage.empty(), code, path, message);
	}
}
