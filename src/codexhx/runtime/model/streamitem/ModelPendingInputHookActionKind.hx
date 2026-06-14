package codexhx.runtime.model.streamitem;

enum abstract ModelPendingInputHookActionKind(String) to String {
	final ContinueInput = "continue_input";
	final StopInput = "stop_input";
}
