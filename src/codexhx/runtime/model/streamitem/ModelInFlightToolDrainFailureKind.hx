package codexhx.runtime.model.streamitem;

enum abstract ModelInFlightToolDrainFailureKind(String) to String {
	final None = "none";
	final ConvertedToolFailure = "converted_tool_failure";
	final FatalToolFuture = "fatal_tool_future";
}
