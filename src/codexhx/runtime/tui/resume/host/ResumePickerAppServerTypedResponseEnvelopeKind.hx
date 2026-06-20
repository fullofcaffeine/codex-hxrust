package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerTypedResponseEnvelopeKind(String) to String {
	final ResolvePayload = "resolve_payload";
	final RejectError = "reject_error";
	final MissingPendingNoop = "missing_pending_noop";
	final SerializationRefused = "serialization_refused";
	final Unknown = "unknown";
}
