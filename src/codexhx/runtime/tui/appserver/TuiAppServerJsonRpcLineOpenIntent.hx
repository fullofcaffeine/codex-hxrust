package codexhx.runtime.tui.appserver;

/**
	Typed native-open intent for app-server JSON-RPC line transports.
**/
enum TuiAppServerJsonRpcLineOpenIntent {
	SpawnStdio(plan:TuiAppServerJsonRpcProcessLaunchPlan);
	ConnectTcp(host:String, port:Int);
	Refuse(report:TuiAppServerJsonRpcLineEndpointReport);
}
