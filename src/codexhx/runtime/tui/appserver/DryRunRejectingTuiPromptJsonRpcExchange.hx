package codexhx.runtime.tui.appserver;

/**
	Dry-run JSON-RPC exchange that rejects without producing frames or events.
**/
class DryRunRejectingTuiPromptJsonRpcExchange implements TuiPromptJsonRpcExchange {
	final rejectionCode:String;

	public function new(rejectionCode:String) {
		this.rejectionCode = normalize(rejectionCode);
	}

	public function send(_request:TuiPromptJsonRpcRequest, _envelope:TuiPromptSubmitEnvelope):TuiPromptJsonRpcExchangeOutcome {
		return TuiPromptJsonRpcExchangeOutcome.rejected(rejectionCode);
	}

	static function normalize(value:String):String {
		return value.length == 0 ? "rejected" : value;
	}
}
