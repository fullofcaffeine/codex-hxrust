package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideThreadStartupRoutingDecisionKind(String) to String {
	var BufferedForChildThread = "buffered_for_child_thread";
	var AppScopedIgnored = "app_scoped_ignored";
	var RenderedActiveSideThread = "rendered_active_side_thread";
	var ReplayedBufferedChildThread = "replayed_buffered_child_thread";
	var SideSessionConfigured = "side_session_configured";
	var MisroutedVisibleThreadIgnored = "misrouted_visible_thread_ignored";
}
