package codexhx.runtime.model.streamitem;

enum abstract ModelPendingInteractiveReplayEventKind(String) to String {
	final SetTurns = "set_turns";
	final ServerRequest = "server_request";
	final TurnCompleted = "turn_completed";
	final ServerRequestResolved = "server_request_resolved";
	final EvictedServerRequest = "evicted_server_request";
	final OutboundOp = "outbound_op";
	final Snapshot = "snapshot";
	final ThreadClosed = "thread_closed";
	final Rollback = "rollback";
}
