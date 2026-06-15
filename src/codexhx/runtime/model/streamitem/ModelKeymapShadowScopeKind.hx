package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapShadowScopeKind(String) to String {
	final Composer = "composer";
	final Editor = "editor";
	final Approval = "approval";
	final List = "list";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapShadowScopeKind {
		return switch value {
			case "composer": Composer;
			case "editor": Editor;
			case "approval": Approval;
			case "list": List;
			case _: Unknown;
		}
	}
}
