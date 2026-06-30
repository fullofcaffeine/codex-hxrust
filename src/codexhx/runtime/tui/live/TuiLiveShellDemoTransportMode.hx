package codexhx.runtime.tui.live;

import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcProcessLaunchPlan;

/**
	Transport mode selected by the user-runnable live shell demo.
**/
enum TuiLiveShellDemoTransportMode {
	Fake;
	LineStdio(plan:TuiAppServerJsonRpcProcessLaunchPlan);
	ProcessStdio(plan:TuiAppServerJsonRpcProcessLaunchPlan);
}
