package codexhx.runtime.tui.live;

import codexhx.runtime.tui.appserver.TuiAppServerReadinessInteraction;
import codexhx.runtime.tui.appserver.TuiAppServerReadinessInteractionStatus;
import codexhx.runtime.tui.appserver.TuiAppServerPumpOutcome;
import codexhx.runtime.tui.appserver.TuiPromptSubmitInteraction;
import codexhx.runtime.tui.appserver.TuiPromptTransportShutdownReport;
import codexhx.runtime.tui.terminal.TerminalExitReason;
import codexhx.runtime.tui.terminal.TerminalFrame;
import codexhx.runtime.tui.terminal.TerminalOperation;
import codexhx.runtime.tui.terminal.TerminalRestoreReport;

/**
	Structured result from one bounded minimal live shell run.
**/
class TuiLiveShellRunOutcome {
	var setupOperationValue:Null<TerminalOperation>;
	var restoreReportValue:Null<TerminalRestoreReport>;
	var iterationsValue:Int;
	var terminalEventsValue:Int;
	var noEventsValue:Int;
	var keyEventsValue:Int;
	var resizeEventsValue:Int;
	var submittedPromptsValue:Int;
	var acceptedPromptsValue:Int;
	var appServerEventsValue:Int;
	var appServerPumpEventsValue:Int;
	var appServerBackpressureCountValue:Int;
	var appServerPumpEventBackpressureCountValue:Int;
	var appServerReadinessEventsValue:Int;
	var appServerReadinessDrainedValue:Int;
	var appServerReadinessNoPendingValue:Int;
	var appServerReadinessBackpressureCountValue:Int;
	var latestReadinessActiveTurnIdValue:String;
	var latestReadinessStatusValue:TuiAppServerReadinessInteractionStatus;
	var latestReadinessLateJsonlDrainStatusValue:String;
	var latestReadinessLateJsonlDrainCodeValue:String;
	var drawFramesValue:Int;
	var terminalOperationsValue:Int;
	var exitRequestedValue:Bool;
	var exitReasonValue:TerminalExitReason;
	var promptTransportShutdownValue:Null<TuiPromptTransportShutdownReport>;
	var activeTurnIdValue:String;
	var lastStartedTurnIdValue:String;
	var lastCompletedTurnIdValue:String;
	var lastInterruptedTurnIdValue:String;
	var completedTurnsValue:Int;
	var interruptedTurnsValue:Int;
	var lastInterruptCodeValue:String;
	final finalFrameLines:Array<String>;

	public function new() {
		this.setupOperationValue = null;
		this.restoreReportValue = null;
		this.iterationsValue = 0;
		this.terminalEventsValue = 0;
		this.noEventsValue = 0;
		this.keyEventsValue = 0;
		this.resizeEventsValue = 0;
		this.submittedPromptsValue = 0;
		this.acceptedPromptsValue = 0;
		this.appServerEventsValue = 0;
		this.appServerPumpEventsValue = 0;
		this.appServerBackpressureCountValue = 0;
		this.appServerPumpEventBackpressureCountValue = 0;
		this.appServerReadinessEventsValue = 0;
		this.appServerReadinessDrainedValue = 0;
		this.appServerReadinessNoPendingValue = 0;
		this.appServerReadinessBackpressureCountValue = 0;
		this.latestReadinessActiveTurnIdValue = "";
		this.latestReadinessStatusValue = TuiAppServerReadinessInteractionStatus.NoPendingSubmittedTurn;
		this.latestReadinessLateJsonlDrainStatusValue = "";
		this.latestReadinessLateJsonlDrainCodeValue = "";
		this.drawFramesValue = 0;
		this.terminalOperationsValue = 0;
		this.exitRequestedValue = false;
		this.exitReasonValue = TerminalExitReason.Requested;
		this.promptTransportShutdownValue = null;
		this.activeTurnIdValue = "";
		this.lastStartedTurnIdValue = "";
		this.lastCompletedTurnIdValue = "";
		this.lastInterruptedTurnIdValue = "";
		this.completedTurnsValue = 0;
		this.interruptedTurnsValue = 0;
		this.lastInterruptCodeValue = "";
		this.finalFrameLines = [];
	}

	public function recordSetup(operation:TerminalOperation):Void {
		setupOperationValue = operation;
		if (operation != null)
			terminalOperationsValue = terminalOperationsValue + 1;
	}

	public function recordIteration():Void {
		iterationsValue = iterationsValue + 1;
	}

	public function recordTerminalEvent():Void {
		terminalEventsValue = terminalEventsValue + 1;
	}

	public function recordNoEvent():Void {
		noEventsValue = noEventsValue + 1;
	}

	public function recordKeyEvent():Void {
		keyEventsValue = keyEventsValue + 1;
	}

	public function recordResizeEvent():Void {
		resizeEventsValue = resizeEventsValue + 1;
	}

	public function recordPromptInteraction(interaction:TuiPromptSubmitInteraction):Void {
		if (interaction == null)
			return;
		if (interaction.hasSubmitResult()) {
			submittedPromptsValue = submittedPromptsValue + 1;
			if (interaction.submitAccepted())
				acceptedPromptsValue = acceptedPromptsValue + 1;
		}
		recordPumpOutcome(interaction.pumpOutcome());
	}

	public function recordPumpOutcome(outcome:TuiAppServerPumpOutcome):Void {
		if (outcome == null)
			return;
		appServerEventsValue = appServerEventsValue + outcome.eventsDrained();
		if (outcome.backpressureApplied())
			appServerBackpressureCountValue = appServerBackpressureCountValue + 1;
		drawFramesValue = drawFramesValue + outcome.schedulerDrawFrameCount();
		terminalOperationsValue = terminalOperationsValue + outcome.terminalOperationCount();
	}

	public function recordPumpEventOutcome(outcome:TuiAppServerPumpOutcome):Void {
		if (outcome != null && outcome.backpressureApplied())
			appServerPumpEventBackpressureCountValue = appServerPumpEventBackpressureCountValue + 1;
		recordPumpOutcome(outcome);
	}

	public function recordPumpEvent():Void {
		appServerPumpEventsValue = appServerPumpEventsValue + 1;
	}

	public function recordReadinessEvent():Void {
		appServerReadinessEventsValue = appServerReadinessEventsValue + 1;
	}

	public function recordReadinessInteraction(interaction:TuiAppServerReadinessInteraction):Void {
		if (interaction == null)
			return;
		latestReadinessStatusValue = interaction.status();
		switch interaction.status() {
			case TuiAppServerReadinessInteractionStatus.Drained:
				appServerReadinessDrainedValue = appServerReadinessDrainedValue + 1;
			case TuiAppServerReadinessInteractionStatus.NoPendingSubmittedTurn:
				appServerReadinessNoPendingValue = appServerReadinessNoPendingValue + 1;
		}
		if (interaction.hasLateJsonlDrainResult()) {
			final drainResult = interaction.lateJsonlDrainResult();
			latestReadinessLateJsonlDrainStatusValue = drainResult == null ? "" : drainResult.statusText();
			latestReadinessLateJsonlDrainCodeValue = drainResult == null ? "" : drainResult.code();
		}
		if (interaction.pumpOutcome().backpressureApplied())
			appServerReadinessBackpressureCountValue = appServerReadinessBackpressureCountValue + 1;
		recordPumpOutcome(interaction.pumpOutcome());
	}

	public function recordReadinessActiveTurn(activeTurnId:String):Void {
		latestReadinessActiveTurnIdValue = normalize(activeTurnId);
	}

	public function recordTerminalOperations(operations:Array<TerminalOperation>):Void {
		if (operations == null)
			return;
		terminalOperationsValue = terminalOperationsValue + operations.length;
	}

	public function recordDrawFrames(count:Int):Void {
		if (count > 0)
			drawFramesValue = drawFramesValue + count;
	}

	public function recordFrame(frame:TerminalFrame):Void {
		finalFrameLines.resize(0);
		if (frame == null)
			return;
		var index = 0;
		while (index < frame.lineCount()) {
			finalFrameLines.push(frame.lineAt(index));
			index = index + 1;
		}
	}

	public function recordExit(reason:TerminalExitReason):Void {
		exitRequestedValue = true;
		exitReasonValue = reason;
	}

	public function recordRestore(report:TerminalRestoreReport):Void {
		restoreReportValue = report;
	}

	public function recordPromptTransportShutdown(report:TuiPromptTransportShutdownReport):Void {
		promptTransportShutdownValue = report;
	}

	public function recordTurnState(activeTurnId:String, lastStartedTurnId:String, lastCompletedTurnId:String, lastInterruptedTurnId:String,
			completedTurns:Int, interruptedTurns:Int, lastInterruptCode:String):Void {
		activeTurnIdValue = normalize(activeTurnId);
		lastStartedTurnIdValue = normalize(lastStartedTurnId);
		lastCompletedTurnIdValue = normalize(lastCompletedTurnId);
		lastInterruptedTurnIdValue = normalize(lastInterruptedTurnId);
		completedTurnsValue = completedTurns < 0 ? 0 : completedTurns;
		interruptedTurnsValue = interruptedTurns < 0 ? 0 : interruptedTurns;
		lastInterruptCodeValue = normalize(lastInterruptCode);
	}

	public function setupAccepted():Bool {
		return setupOperationValue != null && setupOperationValue.ok;
	}

	public function restored():Bool {
		return restoreReportValue != null && restoreReportValue.restored;
	}

	public function iterations():Int {
		return iterationsValue;
	}

	public function terminalEvents():Int {
		return terminalEventsValue;
	}

	public function noEvents():Int {
		return noEventsValue;
	}

	public function keyEvents():Int {
		return keyEventsValue;
	}

	public function resizeEvents():Int {
		return resizeEventsValue;
	}

	public function submittedPrompts():Int {
		return submittedPromptsValue;
	}

	public function acceptedPrompts():Int {
		return acceptedPromptsValue;
	}

	public function appServerEvents():Int {
		return appServerEventsValue;
	}

	public function appServerPumpEvents():Int {
		return appServerPumpEventsValue;
	}

	public function appServerBackpressureCount():Int {
		return appServerBackpressureCountValue;
	}

	public function appServerPumpEventBackpressureCount():Int {
		return appServerPumpEventBackpressureCountValue;
	}

	public function appServerReadinessEvents():Int {
		return appServerReadinessEventsValue;
	}

	public function appServerReadinessDrained():Int {
		return appServerReadinessDrainedValue;
	}

	public function appServerReadinessNoPending():Int {
		return appServerReadinessNoPendingValue;
	}

	public function appServerReadinessBackpressureCount():Int {
		return appServerReadinessBackpressureCountValue;
	}

	public function latestReadinessActiveTurnIdText():String {
		return latestReadinessActiveTurnIdValue;
	}

	public function latestReadinessStatus():TuiAppServerReadinessInteractionStatus {
		return latestReadinessStatusValue;
	}

	public function latestReadinessStatusText():String {
		return latestReadinessStatusValue.text();
	}

	public function latestReadinessLateJsonlDrainStatusText():String {
		return latestReadinessLateJsonlDrainStatusValue;
	}

	public function latestReadinessLateJsonlDrainCode():String {
		return latestReadinessLateJsonlDrainCodeValue;
	}

	public function drawFrames():Int {
		return drawFramesValue;
	}

	public function terminalOperations():Int {
		return terminalOperationsValue;
	}

	public function exitRequested():Bool {
		return exitRequestedValue;
	}

	public function exitReason():TerminalExitReason {
		return exitReasonValue;
	}

	public function promptTransportShutdownRecorded():Bool {
		return promptTransportShutdownValue != null;
	}

	public function promptTransportClosed():Bool {
		return promptTransportShutdownValue != null && promptTransportShutdownValue.closed;
	}

	public function promptTransportShutdownCode():String {
		return promptTransportShutdownValue == null ? "" : promptTransportShutdownValue.code;
	}

	public function promptTransportLineCloseRecorded():Bool {
		return promptTransportShutdownValue != null && promptTransportShutdownValue.lineCloseRecorded;
	}

	public function promptTransportOutboundLineCount():Int {
		return promptTransportShutdownValue == null ? 0 : promptTransportShutdownValue.outboundLineCount;
	}

	public function promptTransportInboundLineCount():Int {
		return promptTransportShutdownValue == null ? 0 : promptTransportShutdownValue.inboundLineCount;
	}

	public function activeTurnIdText():String {
		return activeTurnIdValue;
	}

	public function lastStartedTurnIdText():String {
		return lastStartedTurnIdValue;
	}

	public function lastCompletedTurnIdText():String {
		return lastCompletedTurnIdValue;
	}

	public function lastInterruptedTurnIdText():String {
		return lastInterruptedTurnIdValue;
	}

	public function completedTurns():Int {
		return completedTurnsValue;
	}

	public function interruptedTurns():Int {
		return interruptedTurnsValue;
	}

	public function lastInterruptCode():String {
		return lastInterruptCodeValue;
	}

	public function finalFrameLineAt(index:Int):String {
		if (index < 0 || index >= finalFrameLines.length)
			return "";
		return finalFrameLines[index];
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}
}
