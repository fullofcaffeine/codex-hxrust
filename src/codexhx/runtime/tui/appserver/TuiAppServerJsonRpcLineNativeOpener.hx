package codexhx.runtime.tui.appserver;

/**
	Boundary that opens app-server JSON-RPC line connections from typed intents.
**/
interface TuiAppServerJsonRpcLineNativeOpener {
	function open(intent:TuiAppServerJsonRpcLineOpenIntent):TuiAppServerJsonRpcLineOpenOutcome;
}
