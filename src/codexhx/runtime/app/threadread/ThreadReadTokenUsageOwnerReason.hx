package codexhx.runtime.app.threadread;

enum abstract ThreadReadTokenUsageOwnerReason(String) from String to String {
	var ExplicitOwner = "explicit_owner";
	var RebuiltPosition = "rebuilt_position";
	var LatestCompletedOrFailed = "latest_completed_or_failed";
	var LatestTurn = "latest_turn";
	var EmptyThread = "empty_thread";
}
