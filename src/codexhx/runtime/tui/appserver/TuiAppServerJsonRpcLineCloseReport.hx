package codexhx.runtime.tui.appserver;

/**
	Typed close report for an app-server JSON-RPC line transport.
**/
class TuiAppServerJsonRpcLineCloseReport {
	public final state:TuiAppServerJsonRpcLineTransportState;
	public final code:String;
	public final outboundLineCount:Int;
	public final inboundLineCount:Int;

	public function new(state:TuiAppServerJsonRpcLineTransportState, code:String, outboundLineCount:Int, inboundLineCount:Int) {
		this.state = state;
		this.code = normalize(code);
		this.outboundLineCount = outboundLineCount;
		this.inboundLineCount = inboundLineCount;
	}

	public static function closed(code:String, outboundLineCount:Int, inboundLineCount:Int):TuiAppServerJsonRpcLineCloseReport {
		return new TuiAppServerJsonRpcLineCloseReport(TuiAppServerJsonRpcLineTransportState.Closed, code, outboundLineCount, inboundLineCount);
	}

	public function stateText():String {
		return state.text();
	}

	static function normalize(value:String):String {
		if (value == null || value.length == 0)
			return "closed";
		return value;
	}
}
