package codexhx.runtime.tui.turn;

enum abstract TurnMessageSource(String) from String to String {
	var None = "none";
	var Completion = "completion";
	var Item = "item";
}
