package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingDispatchTransportKind(String) to String {
	var ResponsesHttp = "responses_http";
	var ResponsesWebsocket = "responses_websocket";
	var FixtureDisabled = "fixture_disabled";
}
