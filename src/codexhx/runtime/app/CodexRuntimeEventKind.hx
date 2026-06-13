package codexhx.runtime.app;

enum abstract CodexRuntimeEventKind(String) from String to String {
    var ServerNotification = "serverNotification";
    var ClientResponse = "clientResponse";
    var ClientError = "clientError";
    var Lagged = "lagged";
    var Disconnected = "disconnected";
}
