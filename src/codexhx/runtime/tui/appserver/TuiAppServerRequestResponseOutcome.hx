package codexhx.runtime.tui.appserver;

/**
	Transport result for resolving or rejecting one app-server request.

	The JSON payload stays at the protocol boundary. App logic receives this
	narrow status instead of inspecting an open JSON value.
**/
class TuiAppServerRequestResponseOutcome {
	final acceptedValue:Bool;
	final codeValue:String;

	function new(accepted:Bool, code:String) {
		this.acceptedValue = accepted;
		this.codeValue = normalize(code, accepted ? "sent" : "rejected");
	}

	public static function sent():TuiAppServerRequestResponseOutcome {
		return new TuiAppServerRequestResponseOutcome(true, "sent");
	}

	public static function rejected(code:String):TuiAppServerRequestResponseOutcome {
		return new TuiAppServerRequestResponseOutcome(false, code);
	}

	public static function unsupported():TuiAppServerRequestResponseOutcome {
		return rejected("server_request_response_unsupported");
	}

	public function isAccepted():Bool {
		return acceptedValue;
	}

	public function code():String {
		return codeValue;
	}

	static function normalize(value:String, fallback:String):String {
		return value == null || value.length == 0 ? fallback : value;
	}
}
