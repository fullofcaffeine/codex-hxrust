package codexhx.runtime.model.streamitem;

enum abstract ModelTerminalResizeReflowDecisionKind(String) to String {
	final CappedRecentSuffix = "capped_recent_suffix";
	final UncappedAllCells = "uncapped_all_cells";
	final PetWrappedEarlier = "pet_wrapped_earlier";
	final UnderLimitAllCells = "under_limit_all_cells";
	final InitialReplayBufferTail = "initial_replay_buffer_tail";
	final ThreadSwitchTailMode = "thread_switch_tail_mode";
	final ThreadSwitchBufferDisabled = "thread_switch_buffer_disabled";
}
