package codexhx.runtime.tui.smoke;

import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.agent.AgentNavigationDirection;
import codexhx.runtime.tui.agent.AgentNavigationState;

/**
	Validation adapter that preserves legacy smoke fixture string IDs while the
	production agent navigation behavior lives in `runtime.tui.agent`.
**/
class TuiSmokeAgentNavigationState {
	final state:AgentNavigationState;

	public function new() {
		state = new AgentNavigationState();
	}

	public function upsert(threadId:String, agentNickname:String, agentRole:String, isClosed:Bool):Void {
		state.upsert(thread(threadId), agentNickname, agentRole, isClosed);
	}

	public function recordActivity(threadId:String, agentPath:String, isRunning:Bool):Void {
		state.recordActivity(thread(threadId), agentPath, isRunning);
	}

	public function setRunning(threadId:String, isRunning:Bool):Void {
		state.setRunning(thread(threadId), isRunning);
	}

	public function setAgentPath(threadId:String, agentPath:String):Void {
		state.setAgentPath(thread(threadId), agentPath);
	}

	public function markClosed(threadId:String):Void {
		state.markClosed(thread(threadId));
	}

	public function remove(threadId:String):Void {
		state.remove(thread(threadId));
	}

	public function clear():Void {
		state.clear();
	}

	public function orderedThreadIds():Array<String> {
		final out:Array<String> = [];
		for (threadId in state.orderedThreadIds())
			out.push(threadId.toString());
		return out;
	}

	public function adjacentThreadId(currentThreadId:String, direction:TuiSmokeAgentNavigationDirectionKind):String {
		final runtimeDirection = directionFromSmoke(direction);
		if (currentThreadId == "" || runtimeDirection == null)
			return "";
		final adjacent = state.adjacentThreadId(thread(currentThreadId), runtimeDirection);
		return adjacent == null ? "" : adjacent.toString();
	}

	public function activeAgentLabel(currentThreadId:String, primaryThreadId:String):String {
		if (currentThreadId == "")
			return "";
		return state.activeAgentLabel(thread(currentThreadId), thread(primaryThreadId));
	}

	public function hasNonPrimaryThread(primaryThreadId:String):Bool {
		return state.hasNonPrimaryThread(thread(primaryThreadId));
	}

	public static function pickerSubtitle():String {
		return AgentNavigationState.pickerSubtitle();
	}

	public static function formatAgentPickerItemName(agentNickname:String, agentRole:String, isPrimary:Bool):String {
		return AgentNavigationState.formatAgentPickerItemName(agentNickname, agentRole, isPrimary);
	}

	static function thread(value:String):ThreadId {
		return ThreadId.unsafeAssumeValid(value);
	}

	static function directionFromSmoke(direction:TuiSmokeAgentNavigationDirectionKind):Null<AgentNavigationDirection> {
		return switch direction {
			case TuiSmokeAgentNavigationDirectionKind.Next:
				Next;
			case TuiSmokeAgentNavigationDirectionKind.Previous:
				Previous;
			case _:
				null;
		}
	}
}
