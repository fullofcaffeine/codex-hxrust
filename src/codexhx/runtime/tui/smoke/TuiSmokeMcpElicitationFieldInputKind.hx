package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMcpElicitationFieldInputKind(String) to String {
	final Text = "text";
	final SecretText = "secret_text";
	final BooleanSelect = "boolean_select";
	final EnumSelect = "enum_select";
	final ApprovalSelect = "approval_select";
	final MessageOnly = "message_only";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeMcpElicitationFieldInputKind {
		return switch value {
			case "text": Text;
			case "secret_text": SecretText;
			case "boolean_select": BooleanSelect;
			case "enum_select": EnumSelect;
			case "approval_select": ApprovalSelect;
			case "message_only": MessageOnly;
			case _: Unknown;
		}
	}
}
