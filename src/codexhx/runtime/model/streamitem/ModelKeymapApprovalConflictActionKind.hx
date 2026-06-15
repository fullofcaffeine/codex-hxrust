package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapApprovalConflictActionKind(String) to String {
	final ApprovalApprove = "approval_approve";
	final ApprovalDecline = "approval_decline";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapApprovalConflictActionKind {
		return switch value {
			case "approval_approve": ApprovalApprove;
			case "approval_decline": ApprovalDecline;
			case _: Unknown;
		}
	}
}
