package codexhx.runtime.tui.appserver;

/**
	Terminal status for a bounded submitted-turn late JSONL drain.
**/
enum abstract TuiPromptSubmittedTurnLateJsonlDrainStatus(String) to String {
	final Completed = "completed";
	final NoData = "no_data";
	final MaxBatchesReached = "max_batches_reached";
	final LineReadRejected = "line_read_rejected";
	final BatchRejected = "batch_rejected";
	final InvalidLimit = "invalid_limit";
	final Unsupported = "unsupported";

	public function text():String {
		return this;
	}
}
