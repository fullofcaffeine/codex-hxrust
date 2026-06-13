package codexhx.runtime.app.threadread;

enum abstract ThreadReadTurnItemKind(String) from String to String {
	var UserMessage = "userMessage";
	var AgentMessage = "agentMessage";
	var CommandExecution = "commandExecution";
	var Compacted = "compacted";
}
