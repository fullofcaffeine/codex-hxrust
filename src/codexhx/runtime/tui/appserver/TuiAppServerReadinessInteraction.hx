package codexhx.runtime.tui.appserver;

/**
	Outcome from handling an app-server readiness event through the TUI pump.
**/
class TuiAppServerReadinessInteraction {
	final drainResultValue:Null<TuiPromptSubmittedTurnLateJsonlDrainResult>;
	final pumpOutcomeValue:TuiAppServerPumpOutcome;

	public function new(drainResult:Null<TuiPromptSubmittedTurnLateJsonlDrainResult>, pumpOutcome:TuiAppServerPumpOutcome) {
		this.drainResultValue = drainResult;
		this.pumpOutcomeValue = pumpOutcome == null ? new TuiAppServerPumpOutcome() : pumpOutcome;
	}

	public function hasLateJsonlDrainResult():Bool {
		return drainResultValue != null;
	}

	public function lateJsonlDrainResult():Null<TuiPromptSubmittedTurnLateJsonlDrainResult> {
		return drainResultValue;
	}

	public function lateJsonlDrainStatusText():String {
		return drainResultValue == null ? "none" : drainResultValue.statusText();
	}

	public function lateJsonlDrainCode():String {
		return drainResultValue == null ? "" : drainResultValue.code();
	}

	public function pumpOutcome():TuiAppServerPumpOutcome {
		return pumpOutcomeValue;
	}
}
