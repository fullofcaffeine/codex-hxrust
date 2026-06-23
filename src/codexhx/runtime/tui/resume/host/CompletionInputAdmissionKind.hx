package codexhx.runtime.tui.resume.host;

enum abstract CompletionInputAdmissionKind(String) to String {
	final InputAdmitted = "input_admitted";
	final InputRejected = "input_rejected";
	final Unknown = "unknown";
}
