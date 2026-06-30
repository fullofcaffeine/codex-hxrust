package codexhx.runtime.tui.appserver;

/**
	Typed endpoint variants for app-server JSON-RPC line transports.
**/
enum TuiAppServerJsonRpcLineEndpoint {
	Stdio(plan:TuiAppServerJsonRpcProcessLaunchPlan);
	TcpSocket(host:String, port:Int);
	Unsupported(code:String);
}
