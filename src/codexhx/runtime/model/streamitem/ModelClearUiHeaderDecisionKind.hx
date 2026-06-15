package codexhx.runtime.model.streamitem;

enum abstract ModelClearUiHeaderDecisionKind(String) to String {
	var RenderedFreshHeader = "rendered_fresh_header";
	var ReusedClearHeaderForCtrlL = "reused_clear_header_for_ctrl_l";
	var RenderedFastStatusHeader = "rendered_fast_status_header";
	var SkippedNoRedraw = "skipped_no_redraw";
}
