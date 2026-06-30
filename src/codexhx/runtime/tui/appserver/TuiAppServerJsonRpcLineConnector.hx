package codexhx.runtime.tui.appserver;

/**
	Endpoint-to-line-transport connector for app-server JSON-RPC sessions.
**/
interface TuiAppServerJsonRpcLineConnector {
	function connect(endpoint:TuiAppServerJsonRpcLineEndpoint):TuiAppServerJsonRpcLineConnectReport;
	function transportFor(report:TuiAppServerJsonRpcLineConnectReport):Null<TuiAppServerJsonRpcLineTransport>;
}
