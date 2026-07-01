package codexhx.runtime.tui.appserver;

/**
	Typed app-server readiness events consumed by the TUI event pump.
**/
enum TuiAppServerReadinessEvent {
	SubmittedTurnLateJsonlReady(maxLinesPerBatch:Int, maxBatches:Int);
}
