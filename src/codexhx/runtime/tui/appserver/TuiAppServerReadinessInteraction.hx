package codexhx.runtime.tui.appserver;

/**
	Outcome from handling an app-server readiness event through the TUI pump.
**/
class TuiAppServerReadinessInteraction {
	final statusValue:TuiAppServerReadinessInteractionStatus;
	final codeValue:String;
	final drainResultValue:Null<TuiPromptSubmittedTurnLateJsonlDrainResult>;
	final pumpOutcomeValue:TuiAppServerPumpOutcome;

	public function new(status:TuiAppServerReadinessInteractionStatus, code:String, drainResult:Null<TuiPromptSubmittedTurnLateJsonlDrainResult>,
			pumpOutcome:TuiAppServerPumpOutcome) {
		this.statusValue = status;
		this.codeValue = code == null || code.length == 0 ? status.text() : code;
		this.drainResultValue = drainResult;
		this.pumpOutcomeValue = pumpOutcome == null ? new TuiAppServerPumpOutcome() : pumpOutcome;
	}

	public static function drained(drainResult:TuiPromptSubmittedTurnLateJsonlDrainResult,
			pumpOutcome:TuiAppServerPumpOutcome):TuiAppServerReadinessInteraction {
		return new TuiAppServerReadinessInteraction(TuiAppServerReadinessInteractionStatus.Drained, "drained", drainResult, pumpOutcome);
	}

	public static function noPendingSubmittedTurn(pumpOutcome:TuiAppServerPumpOutcome):TuiAppServerReadinessInteraction {
		return new TuiAppServerReadinessInteraction(TuiAppServerReadinessInteractionStatus.NoPendingSubmittedTurn, "no_pending_submitted_turn", null,
			pumpOutcome);
	}

	public function status():TuiAppServerReadinessInteractionStatus {
		return statusValue;
	}

	public function statusText():String {
		return statusValue.text();
	}

	public function code():String {
		return codeValue;
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
