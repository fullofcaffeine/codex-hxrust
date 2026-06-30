package codexhx.runtime.tui.appserver;

/**
	Attaches ready stdio app-server line connections to a persistent stdio session.

	Why
	- The live TUI needs to keep one app-server line transport attached across
	  multiple prompt submissions instead of respawning for each turn.

	What
	- Preserves the existing typed attachment contract.
	- Materializes `TuiAppServerJsonRpcStdioSession` only for ready stdio launch
	  plans.
	- Leaves async pumps, sockets, credentials, and model work out of this slice.

	How
	- `attach` records opened/refused readiness without spawning.
	- `transportFor` creates the bounded synchronous session when the connector
	  asks for the line transport.
**/
class PersistentStdioTuiAppServerJsonRpcLineTransportAttacher implements TuiAppServerJsonRpcLineTransportAttacher {
	final maxInboundLinesPerPrompt:Int;

	public function new(maxInboundLinesPerPrompt:Int) {
		this.maxInboundLinesPerPrompt = maxInboundLinesPerPrompt <= 0 ? 64 : maxInboundLinesPerPrompt;
	}

	public static function promptStream():PersistentStdioTuiAppServerJsonRpcLineTransportAttacher {
		return new PersistentStdioTuiAppServerJsonRpcLineTransportAttacher(10);
	}

	public function attach(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment {
		final concrete = outcome == null ? TuiAppServerJsonRpcLineOpenOutcome.refused(null) : outcome;
		if (!concrete.isOpened())
			return TuiAppServerJsonRpcLineTransportAttachment.refused(concrete);
		return TuiAppServerJsonRpcLineTransportAttachment.ready(concrete);
	}

	public function transportFor(attachment:TuiAppServerJsonRpcLineTransportAttachment):Null<TuiAppServerJsonRpcLineTransport> {
		if (attachment == null || !attachment.isReady())
			return null;
		final plan = attachment.launchPlan();
		if (plan == null)
			return null;
		return TuiAppServerJsonRpcStdioSession.withDefaultDecoder(plan, maxInboundLinesPerPrompt);
	}
}
