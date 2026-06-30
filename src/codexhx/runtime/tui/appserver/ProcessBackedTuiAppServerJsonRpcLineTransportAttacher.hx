package codexhx.runtime.tui.appserver;

/**
	Attaches ready stdio app-server line connections to a process-backed transport.

	Why
	- The live TUI prompt path needs the connector-backed transport to cross the
	  real child-process JSONL boundary, not only the direct process transport
	  harness path.

	What
	- Preserves the existing typed attachment contract.
	- Materializes `ProcessBackedTuiAppServerJsonRpcLineTransport` only when the
	  ready attachment carries a stdio launch plan.
	- Leaves TCP/socket attachment materialization for a later transport slice.

	How
	- `attach` records opened/refused readiness without owning a process.
	- `transportFor` creates the process-backed line transport from the stored
	  launch plan at the moment the connector-backed prompt transport asks for it.
**/
class ProcessBackedTuiAppServerJsonRpcLineTransportAttacher implements TuiAppServerJsonRpcLineTransportAttacher {
	public function new() {}

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
		return new ProcessBackedTuiAppServerJsonRpcLineTransport(plan);
	}
}
