package codexhx.runtime.model.streamitem;

enum abstract ModelAppServerResponseDispatchKind(String) to String {
	final ResolveResponse = "resolve_response";
	final RejectUnsupported = "reject_unsupported";
	final SerializationRefusal = "serialization_refusal";
	final MissingSessionNoop = "missing_session_noop";
}
