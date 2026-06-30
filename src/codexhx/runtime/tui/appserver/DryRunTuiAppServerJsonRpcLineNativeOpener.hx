package codexhx.runtime.tui.appserver;

/**
	Dry-run opener for validating native-open outcomes without live I/O.
**/
class DryRunTuiAppServerJsonRpcLineNativeOpener implements TuiAppServerJsonRpcLineNativeOpener {
	var openedCount:Int;

	public function new() {
		this.openedCount = 0;
	}

	public function open(intent:TuiAppServerJsonRpcLineOpenIntent):TuiAppServerJsonRpcLineOpenOutcome {
		final report = TuiAppServerJsonRpcLineOpenIntentReport.fromIntent(intent);
		if (!report.isActionable())
			return TuiAppServerJsonRpcLineOpenOutcome.refused(report);
		openedCount = openedCount + 1;
		return TuiAppServerJsonRpcLineOpenOutcome.opened(labelFor(report), openedCount, report, intent);
	}

	public function openCount():Int {
		return openedCount;
	}

	static function labelFor(report:TuiAppServerJsonRpcLineOpenIntentReport):String {
		if (report.kind == TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio)
			return "stdio:" + report.command;
		if (report.kind == TuiAppServerJsonRpcLineOpenIntentKind.ConnectTcp)
			return "tcp:" + report.host;
		return "";
	}
}
