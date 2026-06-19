package codexhx.runtime.app.threadread;

enum abstract RolloutSummaryItemKind(String) from String to String {
	var TurnStarted = "turn_started";
	var UserMessage = "user_message";
	var AgentMessage = "agent_message";
	var CommandExecution = "command_execution";
	var TurnComplete = "turn_complete";
	var TurnAborted = "turn_aborted";
	var Error = "error";
	var Compacted = "compacted";

	public static function isValid(value:String):Bool {
		return value == TurnStarted || value == UserMessage || value == AgentMessage || value == CommandExecution || value == TurnComplete
			|| value == TurnAborted || value == Error || value == Compacted;
	}
}
