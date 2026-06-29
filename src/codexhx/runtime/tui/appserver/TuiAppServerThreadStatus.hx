package codexhx.runtime.tui.appserver;

/**
	Thread status notifications accepted by the minimal live TUI shell.
**/
enum TuiAppServerThreadStatus {
	Ready(text:String);
	Working(text:String);
	Failed(text:String);
}
