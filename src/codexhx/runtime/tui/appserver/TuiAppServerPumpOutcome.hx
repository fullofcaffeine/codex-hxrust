package codexhx.runtime.tui.appserver;

import codexhx.runtime.tui.terminal.TerminalOperation;
import codexhx.runtime.tui.terminal.TerminalOperationKind;
import codexhx.runtime.tui.terminal.TerminalSchedulerEffect;

/**
	Structured outcome from one app-server pump drain.
**/
class TuiAppServerPumpOutcome {
	final appServerEffectsValue:Array<TuiAppServerShellEffect>;
	final schedulerEffectsValue:Array<TerminalSchedulerEffect>;
	final terminalOperationsValue:Array<TerminalOperation>;
	var eventsDrainedValue:Int;
	var drawRequestsValue:Int;
	var backpressureValue:Bool;
	var cancelledValue:Bool;

	public function new() {
		this.appServerEffectsValue = [];
		this.schedulerEffectsValue = [];
		this.terminalOperationsValue = [];
		this.eventsDrainedValue = 0;
		this.drawRequestsValue = 0;
		this.backpressureValue = false;
		this.cancelledValue = false;
	}

	public function recordEvent(effects:Array<TuiAppServerShellEffect>):Void {
		eventsDrainedValue = eventsDrainedValue + 1;
		if (effects == null)
			return;
		for (effect in effects) {
			appServerEffectsValue.push(effect);
			switch effect {
				case TuiAppServerShellEffect.DrawRequested:
					drawRequestsValue = drawRequestsValue + 1;
				case _:
			}
		}
	}

	public function recordSchedulerEffects(effects:Array<TerminalSchedulerEffect>):Void {
		if (effects == null)
			return;
		for (effect in effects)
			schedulerEffectsValue.push(effect);
	}

	public function recordTerminalOperations(operations:Array<TerminalOperation>):Void {
		if (operations == null)
			return;
		for (operation in operations)
			terminalOperationsValue.push(operation);
	}

	public function markBackpressure():Void {
		backpressureValue = true;
	}

	public function markCancelled():Void {
		cancelledValue = true;
	}

	public function eventsDrained():Int {
		return eventsDrainedValue;
	}

	public function drawRequests():Int {
		return drawRequestsValue;
	}

	public function backpressureApplied():Bool {
		return backpressureValue;
	}

	public function cancelled():Bool {
		return cancelledValue;
	}

	public function appServerEffectCount():Int {
		return appServerEffectsValue.length;
	}

	public function schedulerEffectCount():Int {
		return schedulerEffectsValue.length;
	}

	public function terminalOperationCount():Int {
		return terminalOperationsValue.length;
	}

	public function appServerEffectAt(index:Int):Null<TuiAppServerShellEffect> {
		if (index < 0 || index >= appServerEffectsValue.length)
			return null;
		return appServerEffectsValue[index];
	}

	public function schedulerEffectAt(index:Int):Null<TerminalSchedulerEffect> {
		if (index < 0 || index >= schedulerEffectsValue.length)
			return null;
		return schedulerEffectsValue[index];
	}

	public function terminalOperationAt(index:Int):Null<TerminalOperation> {
		if (index < 0 || index >= terminalOperationsValue.length)
			return null;
		return terminalOperationsValue[index];
	}

	public function schedulerDrawFrameCount():Int {
		var count = 0;
		for (effect in schedulerEffectsValue) {
			switch effect {
				case TerminalSchedulerEffect.DrawFrame(_):
					count = count + 1;
				case _:
			}
		}
		return count;
	}

	public function terminalOperationKindAt(index:Int):Null<TerminalOperationKind> {
		if (index < 0 || index >= terminalOperationsValue.length)
			return null;
		return terminalOperationsValue[index].kind;
	}

	public function terminalOperationOkAt(index:Int):Bool {
		if (index < 0 || index >= terminalOperationsValue.length)
			return false;
		return terminalOperationsValue[index].ok;
	}
}
