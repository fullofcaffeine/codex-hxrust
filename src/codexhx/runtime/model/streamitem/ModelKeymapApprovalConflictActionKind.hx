package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapApprovalConflictActionKind(String) to String {
	final ApprovalApprove = "approval_approve";
	final ApprovalDecline = "approval_decline";
	final ApprovalDeny = "approval_deny";
	final ApprovalCancel = "approval_cancel";
	final ListAccept = "list_accept";
	final ListCancel = "list_cancel";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapApprovalConflictActionKind {
		return switch value {
			case "approval_approve": ApprovalApprove;
			case "approval_decline": ApprovalDecline;
			case "approval_deny": ApprovalDeny;
			case "approval_cancel": ApprovalCancel;
			case "list_accept": ListAccept;
			case "list_cancel": ListCancel;
			case _: Unknown;
		}
	}
}
