package codexhx.runtime.app.threadread;

enum abstract ThreadReadTokenUsageReplayDeliveryOperation(String) from String to String {
	var Resume = "resume";
	var Fork = "fork";
	var LoadedResume = "loaded_resume";
}
