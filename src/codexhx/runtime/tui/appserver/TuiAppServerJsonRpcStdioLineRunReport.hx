package codexhx.runtime.tui.appserver;

/**
	Structured report from one stdio app-server JSON-RPC process line run.

	Why
	- Process IO failures need to be observable as typed state/evidence, not only as trace strings
	  or thrown exceptions.

	What
	- Captures run status, diagnostic code, concrete exit code, stderr text, and the line
	  transcript observed at the stdio boundary.

	How
	- Uses the existing line transcript model for outbound/inbound JSONL records.
	- Keeps `code` as a stable boundary diagnostic string because these values are harness/report
	  identifiers rather than application-domain variants.
**/
class TuiAppServerJsonRpcStdioLineRunReport {
	public final status:TuiAppServerJsonRpcStdioLineRunStatus;
	public final code:String;
	public final exitCode:Int;
	public final stderrText:String;

	final transcriptValue:TuiAppServerJsonRpcLineTranscript;

	public function new(status:TuiAppServerJsonRpcStdioLineRunStatus, code:String, exitCode:Int, stderrText:String,
			transcript:TuiAppServerJsonRpcLineTranscript) {
		this.status = status;
		this.code = normalize(code, status.text());
		this.exitCode = exitCode;
		this.stderrText = normalize(stderrText, "");
		this.transcriptValue = transcript == null ? TuiAppServerJsonRpcLineTranscript.empty() : transcript;
	}

	public static function succeeded(exitCode:Int, stderrText:String, outboundLine:String, inboundLines:Array<String>):TuiAppServerJsonRpcStdioLineRunReport {
		return new TuiAppServerJsonRpcStdioLineRunReport(TuiAppServerJsonRpcStdioLineRunStatus.Succeeded, "ok", exitCode, stderrText,
			TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inboundLines));
	}

	public static function failed(code:String, exitCode:Int, stderrText:String, outboundLine:String,
			inboundLines:Array<String>):TuiAppServerJsonRpcStdioLineRunReport {
		return new TuiAppServerJsonRpcStdioLineRunReport(TuiAppServerJsonRpcStdioLineRunStatus.Failed, code, exitCode, stderrText,
			TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inboundLines));
	}

	public static function rejected(code:String):TuiAppServerJsonRpcStdioLineRunReport {
		return new TuiAppServerJsonRpcStdioLineRunReport(TuiAppServerJsonRpcStdioLineRunStatus.Rejected, code, -1, "",
			TuiAppServerJsonRpcLineTranscript.empty());
	}

	public function isSucceeded():Bool {
		return status == TuiAppServerJsonRpcStdioLineRunStatus.Succeeded;
	}

	public function statusText():String {
		return status.text();
	}

	public function transcript():TuiAppServerJsonRpcLineTranscript {
		return transcriptValue;
	}

	public function outboundLineCount():Int {
		return transcriptValue.hasOutboundLine() ? 1 : 0;
	}

	public function inboundLineCount():Int {
		return transcriptValue.inboundLineCount();
	}

	public function inboundLineAt(index:Int):String {
		return transcriptValue.inboundLineAt(index);
	}

	static function normalize(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
