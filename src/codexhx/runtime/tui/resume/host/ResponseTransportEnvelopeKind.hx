package codexhx.runtime.tui.resume.host;

enum abstract ResponseTransportEnvelopeKind(String) to String {
	final ResolveResult = "resolve_result";
	final RejectError = "reject_error";
	final LocalNoop = "local_noop";
	final LocalSerializationRefusal = "local_serialization_refusal";
	final SendFailure = "send_failure";
	final Unknown = "unknown";
}
