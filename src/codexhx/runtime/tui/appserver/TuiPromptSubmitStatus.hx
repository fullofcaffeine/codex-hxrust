package codexhx.runtime.tui.appserver;

/**
	Typed admission result for composer prompt submission.
**/
enum TuiPromptSubmitStatus {
	Accepted;
	EmptyPrompt;
	MissingSession;
	MissingThread;
}
