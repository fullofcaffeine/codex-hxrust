package codexhx.runtime.app.threadread;

enum abstract ThreadReadGoalAccountingDisposition(String) from String to String {
	var KeepActive = "keep_active";
	var ClearActive = "clear_active";
}
