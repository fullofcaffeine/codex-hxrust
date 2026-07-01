package codexhx.runtime.tui.appserver;

/**
	Typed result codes for pumping late JSONL lines into submitted-turn state.
**/
enum abstract TuiPromptSubmittedTurnLateJsonlPumpStatus(String) to String {
	final Accepted = "accepted";
	final LineReadRejected = "line_read_rejected";
	final BatchRejected = "batch_rejected";

	public function text():String {
		return this;
	}
}
