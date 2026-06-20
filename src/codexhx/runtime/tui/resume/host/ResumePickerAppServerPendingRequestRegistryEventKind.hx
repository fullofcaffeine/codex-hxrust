package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerPendingRequestRegistryEventKind(String) to String {
	final Registered = "registered";
	final DuplicateRejected = "duplicate_rejected";
	final ResolvedRemoved = "resolved_removed";
	final RejectedRemoved = "rejected_removed";
	final LateResponseRefused = "late_response_refused";
	final AbandonedCleaned = "abandoned_cleaned";
	final InvalidRequestRefused = "invalid_request_refused";
	final Unknown = "unknown";
}
