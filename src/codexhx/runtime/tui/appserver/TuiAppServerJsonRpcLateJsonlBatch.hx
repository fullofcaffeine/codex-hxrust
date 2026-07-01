package codexhx.runtime.tui.appserver;

/**
	Raw late JSONL lines read from an already-open app-server line session.
**/
class TuiAppServerJsonRpcLateJsonlBatch {
	public final status:TuiAppServerJsonRpcTransportStatus;

	final codeValue:String;
	final linesValue:Array<String>;

	public function new(status:TuiAppServerJsonRpcTransportStatus, code:String, lines:Array<String>) {
		this.status = status;
		this.codeValue = code == null || code.length == 0 ? status.text() : code;
		this.linesValue = lines == null ? [] : lines.copy();
	}

	public static function accepted(lines:Array<String>):TuiAppServerJsonRpcLateJsonlBatch {
		return new TuiAppServerJsonRpcLateJsonlBatch(TuiAppServerJsonRpcTransportStatus.Accepted, "accepted", lines);
	}

	public static function rejected(code:String):TuiAppServerJsonRpcLateJsonlBatch {
		return new TuiAppServerJsonRpcLateJsonlBatch(TuiAppServerJsonRpcTransportStatus.Rejected, code, []);
	}

	public static function disconnected(code:String, lines:Array<String>):TuiAppServerJsonRpcLateJsonlBatch {
		return new TuiAppServerJsonRpcLateJsonlBatch(TuiAppServerJsonRpcTransportStatus.Disconnected, code, lines);
	}

	public static function notReady(code:String):TuiAppServerJsonRpcLateJsonlBatch {
		return new TuiAppServerJsonRpcLateJsonlBatch(TuiAppServerJsonRpcTransportStatus.NotReady, code, []);
	}

	public function isAccepted():Bool {
		return status == TuiAppServerJsonRpcTransportStatus.Accepted;
	}

	public function isNotReady():Bool {
		return status == TuiAppServerJsonRpcTransportStatus.NotReady;
	}

	public function statusText():String {
		return status.text();
	}

	public function code():String {
		return codeValue;
	}

	public function lineCount():Int {
		return linesValue.length;
	}

	public function lineAt(index:Int):String {
		if (index < 0 || index >= linesValue.length)
			return "";
		return linesValue[index];
	}

	public function lines():Array<String> {
		return linesValue.copy();
	}
}
