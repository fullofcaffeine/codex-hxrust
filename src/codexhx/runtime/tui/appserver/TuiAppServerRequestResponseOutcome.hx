package codexhx.runtime.tui.appserver;

/**
	Transport result for resolving or rejecting one app-server request.

	The JSON payload stays at the protocol boundary. App logic receives this
	narrow status instead of inspecting an open JSON value.
**/
class TuiAppServerRequestResponseOutcome {
	final statusValue:TuiAppServerRequestResponseStatus;
	final codeValue:String;

	function new(status:TuiAppServerRequestResponseStatus, code:String) {
		this.statusValue = status;
		this.codeValue = normalize(code, status.text());
	}

	public static function sent():TuiAppServerRequestResponseOutcome {
		return new TuiAppServerRequestResponseOutcome(TuiAppServerRequestResponseStatus.Sent, "sent");
	}

	public static function rejected(code:String):TuiAppServerRequestResponseOutcome {
		return new TuiAppServerRequestResponseOutcome(TuiAppServerRequestResponseStatus.Rejected, code);
	}

	public static function disconnected(code:String):TuiAppServerRequestResponseOutcome {
		return new TuiAppServerRequestResponseOutcome(TuiAppServerRequestResponseStatus.Disconnected, code);
	}

	public function isAccepted():Bool {
		return statusValue == TuiAppServerRequestResponseStatus.Sent;
	}

	public function status():TuiAppServerRequestResponseStatus {
		return statusValue;
	}

	public function statusText():String {
		return statusValue.text();
	}

	public function code():String {
		return codeValue;
	}

	static function normalize(value:String, fallback:String):String {
		return value == null || value.length == 0 ? fallback : value;
	}
}
