package codexhx.runtime.tui.live;

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
	var drawFramesValue:Int;
	var terminalOperationsValue:Int;
	var exitRequestedValue:Bool;
	var exitReasonValue:TerminalExitReason;
	var promptTransportShutdownValue:Null<TuiPromptTransportShutdownReport>;
	var activeTurnIdValue:String;
	var lastStartedTurnIdValue:String;
	var lastCompletedTurnIdValue:String;
	var completedTurnsValue:Int;
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
		this.drawFramesValue = 0;
		this.terminalOperationsValue = 0;
		this.exitRequestedValue = false;
		this.exitReasonValue = TerminalExitReason.Requested;
		this.promptTransportShutdownValue = null;
		this.activeTurnIdValue = "";
		this.lastStartedTurnIdValue = "";
		this.lastCompletedTurnIdValue = "";
		this.completedTurnsValue = 0;
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
		drawFramesValue = drawFramesValue + outcome.schedulerDrawFrameCount();
		terminalOperationsValue = terminalOperationsValue + outcome.terminalOperationCount();
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

	public function recordTurnState(activeTurnId:String, lastStartedTurnId:String, lastCompletedTurnId:String, completedTurns:Int):Void {
		activeTurnIdValue = normalize(activeTurnId);
		lastStartedTurnIdValue = normalize(lastStartedTurnId);
		lastCompletedTurnIdValue = normalize(lastCompletedTurnId);
		completedTurnsValue = completedTurns < 0 ? 0 : completedTurns;
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

	public function completedTurns():Int {
		return completedTurnsValue;
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
