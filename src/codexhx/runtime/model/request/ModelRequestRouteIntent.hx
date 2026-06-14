package codexhx.runtime.model.request;

enum abstract ModelRequestRouteIntent(String) to String {
	public var PlanOnly = "plan_only";
	public var ResponsesHttp = "responses_http";
	public var ResponsesWebsocket = "responses_websocket";
}
