package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerRequestDispatchCommandKind(String) to String {
	final ResolveServerRequest = "resolve_server_request";
	final RejectServerRequest = "reject_server_request";
	final SerializationRefused = "serialization_refused";
	final MissingSessionNoop = "missing_session_noop";
	final SendFailed = "send_failed";
	final Unknown = "unknown";
}
