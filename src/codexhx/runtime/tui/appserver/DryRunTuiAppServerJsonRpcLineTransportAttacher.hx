package codexhx.runtime.tui.appserver;

/**
	Dry-run app-server line transport attacher for credential-free runtime gates.
**/
class DryRunTuiAppServerJsonRpcLineTransportAttacher implements TuiAppServerJsonRpcLineTransportAttacher {
	public function new() {}

	public function attach(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment {
		final concrete = outcome == null ? TuiAppServerJsonRpcLineOpenOutcome.refused(null) : outcome;
		if (!concrete.isOpened())
			return TuiAppServerJsonRpcLineTransportAttachment.refused(concrete);
		return TuiAppServerJsonRpcLineTransportAttachment.ready(concrete);
	}

	public function transportFor(attachment:TuiAppServerJsonRpcLineTransportAttachment):FakeTuiAppServerJsonRpcLineTransport {
		if (attachment == null || !attachment.isReady())
			return null;
		return new FakeTuiAppServerJsonRpcLineTransport();
	}
}
