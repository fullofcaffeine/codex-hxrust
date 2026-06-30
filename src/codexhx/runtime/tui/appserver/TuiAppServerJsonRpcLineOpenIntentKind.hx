package codexhx.runtime.tui.appserver;

/**
	Native boundary action selected for an app-server line endpoint.
**/
enum abstract TuiAppServerJsonRpcLineOpenIntentKind(String) to String {
	final SpawnStdio = "spawn_stdio";
	final ConnectTcp = "connect_tcp";
	final Refuse = "refuse";

	public function text():String {
		return this;
	}
}
