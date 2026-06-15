package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideThreadStartupEventKind(String) to String {
	var Starting = "starting";
	var Failed = "failed";
	var Ready = "ready";
}
