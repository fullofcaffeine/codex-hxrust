package codexhx.runtime.tui.appserver;

/**
	Dry-run connector that composes endpoint validation, open intent, and attachment.
**/
class DryRunTuiAppServerJsonRpcLineConnector implements TuiAppServerJsonRpcLineConnector {
	final opener:TuiAppServerJsonRpcLineNativeOpener;
	final attacher:TuiAppServerJsonRpcLineTransportAttacher;
	var lastAttachmentValue:TuiAppServerJsonRpcLineTransportAttachment;

	public function new(opener:TuiAppServerJsonRpcLineNativeOpener, attacher:TuiAppServerJsonRpcLineTransportAttacher) {
		this.opener = opener;
		this.attacher = attacher;
		this.lastAttachmentValue = null;
	}

	public static function dryRun():DryRunTuiAppServerJsonRpcLineConnector {
		return new DryRunTuiAppServerJsonRpcLineConnector(defaultOpener(), defaultAttacher());
	}

	public function connect(endpoint:TuiAppServerJsonRpcLineEndpoint):TuiAppServerJsonRpcLineConnectReport {
		final endpointReport = TuiAppServerJsonRpcLineEndpointReport.inspect(endpoint);
		final intent = TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(endpoint);
		final openOutcome = opener.open(intent);
		final attachment = attacher.attach(openOutcome);
		lastAttachmentValue = attachment;
		final attachmentReport = TuiAppServerJsonRpcLineTransportAttachmentReport.fromAttachment(attachment);
		return TuiAppServerJsonRpcLineConnectReport.fromParts(endpointReport, openOutcome, attachmentReport);
	}

	public function transportFor(report:TuiAppServerJsonRpcLineConnectReport):Null<TuiAppServerJsonRpcLineTransport> {
		if (report == null || !report.isReady())
			return null;
		return attacher.transportFor(lastAttachmentValue);
	}

	static function defaultOpener():TuiAppServerJsonRpcLineNativeOpener {
		return new DryRunTuiAppServerJsonRpcLineNativeOpener();
	}

	static function defaultAttacher():TuiAppServerJsonRpcLineTransportAttacher {
		return new DryRunTuiAppServerJsonRpcLineTransportAttacher();
	}
}
