package codexhx.runtime.app;

enum abstract CodexRuntimeCommandKind(String) from String to String {
	var AppRequest = "appRequest";
	var CompleteResponse = "completeResponse";
	var FailResponse = "failResponse";
}
