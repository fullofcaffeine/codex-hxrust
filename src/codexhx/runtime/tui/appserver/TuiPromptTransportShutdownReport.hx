package codexhx.runtime.tui.appserver;

/**
	Structured shutdown evidence for the live-shell prompt transport.

	Line-close details are optional because fake/in-process transports have no
	line handle, while persistent stdio must prove the child/session boundary was
	closed with aggregate line counts.
**/
class TuiPromptTransportShutdownReport {
	public final closed:Bool;
	public final code:String;
	public final lineCloseRecorded:Bool;
	public final lineState:TuiAppServerJsonRpcLineTransportState;
	public final outboundLineCount:Int;
	public final inboundLineCount:Int;

	public function new(closed:Bool, code:String, lineCloseRecorded:Bool, lineState:TuiAppServerJsonRpcLineTransportState, outboundLineCount:Int,
			inboundLineCount:Int) {
		this.closed = closed;
		this.code = normalize(code, "prompt_transport_shutdown");
		this.lineCloseRecorded = lineCloseRecorded;
		this.lineState = lineState;
		this.outboundLineCount = outboundLineCount;
		this.inboundLineCount = inboundLineCount;
	}

	public static function noLineClose(code:String):TuiPromptTransportShutdownReport {
		return new TuiPromptTransportShutdownReport(true, code, false, TuiAppServerJsonRpcLineTransportState.Closed, 0, 0);
	}

	public static function fromLineCloseReport(report:TuiAppServerJsonRpcLineCloseReport):TuiPromptTransportShutdownReport {
		if (report == null)
			return noLineClose("missing_line_close_report");
		return new TuiPromptTransportShutdownReport(true, report.code, true, report.state, report.outboundLineCount, report.inboundLineCount);
	}

	public function lineStateText():String {
		return lineState.text();
	}

	static function normalize(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
