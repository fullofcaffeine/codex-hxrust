package codexhx.runtime.model.streamitem;

enum abstract ModelTerminalResizeReflowRequestKind(String) to String {
	final RenderTranscript = "render_transcript";
	final InitialReplayBuffer = "initial_replay_buffer";
	final ThreadSwitchReplayBuffer = "thread_switch_replay_buffer";
}
