package codexhx.runtime.tui.appserver;

/**
	Dry-run connector that composes endpoint validation, open intent, and attachment.
**/
class DryRunTuiAppServerJsonRpcLineConnector implements TuiAppServerJsonRpcLineConnector {
	public function new() {}

	public function connect(endpoint:TuiAppServerJsonRpcLineEndpoint):TuiAppServerJsonRpcLineConnectReport {
		final endpointReport = TuiAppServerJsonRpcLineEndpointReport.inspect(endpoint);
		final intent = TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(endpoint);
		final openOutcome = new DryRunTuiAppServerJsonRpcLineNativeOpener().open(intent);
		final attachment = new DryRunTuiAppServerJsonRpcLineTransportAttacher().attach(openOutcome);
		final attachmentReport = TuiAppServerJsonRpcLineTransportAttachmentReport.fromAttachment(attachment);
		return TuiAppServerJsonRpcLineConnectReport.fromParts(endpointReport, openOutcome, attachmentReport);
	}

	public function transportFor(report:TuiAppServerJsonRpcLineConnectReport):Null<TuiAppServerJsonRpcLineTransport> {
		if (report == null || !report.isReady())
			return null;
		return new FakeTuiAppServerJsonRpcLineTransport();
	}
}
