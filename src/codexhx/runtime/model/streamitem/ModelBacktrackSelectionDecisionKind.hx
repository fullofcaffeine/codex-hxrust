package codexhx.runtime.model.streamitem;

enum abstract ModelBacktrackSelectionDecisionKind(String) to String {
	final EditedDuplicateUserTurnSelected = "edited_duplicate_user_turn_selected";
	final SelectionUnavailable = "selection_unavailable";
}
