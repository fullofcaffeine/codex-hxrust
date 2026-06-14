package codexhx.runtime.model.streamitem;

enum abstract ModelPendingInteractivePromptKind(String) to String {
	final None = "none";
	final ExecApproval = "exec_approval";
	final PatchApproval = "patch_approval";
	final Elicitation = "elicitation";
	final RequestPermissions = "request_permissions";
	final RequestUserInput = "request_user_input";
}
