package codexhx.runtime.model.streamitem;

enum abstract ModelResizeReflowSchedulingDecisionKind(String) to String {
	final UnchangedSizeNoOp = "unchanged_size_no_op";
	final HeightChangeScheduled = "height_change_scheduled";
	final WidthChangeScheduled = "width_change_scheduled";
	final DisabledWidthChangeCleared = "disabled_width_change_cleared";
}
