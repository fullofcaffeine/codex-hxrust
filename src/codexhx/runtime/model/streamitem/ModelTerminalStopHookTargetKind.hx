package codexhx.runtime.model.streamitem;

enum abstract ModelTerminalStopHookTargetKind(String) to String {
	final Stop = "stop";
	final SubagentStop = "subagent_stop";
	final InternalSubagentSkip = "internal_subagent_skip";
}
