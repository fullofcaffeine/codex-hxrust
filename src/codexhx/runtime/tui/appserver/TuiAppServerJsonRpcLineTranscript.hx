package codexhx.runtime.tui.appserver;

/**
	Raw JSONL transcript owned by the app-server line transport boundary.
**/
class TuiAppServerJsonRpcLineTranscript {
	final outboundLineValue:String;
	final inboundLinesValue:Array<String>;

	public function new(outboundLine:String, inboundLines:Array<String>) {
		this.outboundLineValue = outboundLine == null ? "" : outboundLine;
		this.inboundLinesValue = inboundLines == null ? [] : inboundLines.copy();
	}

	public static function empty():TuiAppServerJsonRpcLineTranscript {
		return new TuiAppServerJsonRpcLineTranscript("", []);
	}

	public static function outbound(outboundLine:String):TuiAppServerJsonRpcLineTranscript {
		return new TuiAppServerJsonRpcLineTranscript(outboundLine, []);
	}

	public static function accepted(outboundLine:String, inboundLines:Array<String>):TuiAppServerJsonRpcLineTranscript {
		return new TuiAppServerJsonRpcLineTranscript(outboundLine, inboundLines);
	}

	public function hasOutboundLine():Bool {
		return outboundLineValue.length > 0;
	}

	public function outboundLine():String {
		return outboundLineValue;
	}

	public function inboundLineCount():Int {
		return inboundLinesValue.length;
	}

	public function totalLineCount():Int {
		return (hasOutboundLine() ? 1 : 0) + inboundLinesValue.length;
	}

	public function lineAt(index:Int):String {
		if (index < 0)
			return "";
		var inboundIndex = index;
		if (hasOutboundLine()) {
			if (index == 0)
				return outboundLineValue;
			inboundIndex = index - 1;
		}
		if (inboundIndex >= inboundLinesValue.length)
			return "";
		return inboundLinesValue[inboundIndex];
	}

	public function inboundLineAt(index:Int):String {
		if (index < 0 || index >= inboundLinesValue.length)
			return "";
		return inboundLinesValue[index];
	}

	public function inboundLines():Array<String> {
		return inboundLinesValue.copy();
	}
}
