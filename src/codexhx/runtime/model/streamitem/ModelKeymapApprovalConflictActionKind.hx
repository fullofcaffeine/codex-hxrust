package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapApprovalConflictActionKind(String) to String {
	final ApprovalApprove = "approval_approve";
	final ApprovalDecline = "approval_decline";
	final ApprovalDeny = "approval_deny";
	final ListAccept = "list_accept";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapApprovalConflictActionKind {
		return switch value {
			case "approval_approve": ApprovalApprove;
			case "approval_decline": ApprovalDecline;
			case "approval_deny": ApprovalDeny;
			case "list_accept": ListAccept;
			case _: Unknown;
		}
	}
}
