package codexhx.runtime.tui;

enum abstract CodexStoryMessageType(String) from String to String {
    var SessionConfigured = "session_configured";
    var TaskStarted = "task_started";
    var AgentReasoningRawContentDelta = "agent_reasoning_raw_content_delta";
    var AgentMessageDelta = "agent_message_delta";
    var TaskComplete = "task_complete";
    var ShutdownComplete = "shutdown_complete";
    var Unsupported = "unsupported";
}
