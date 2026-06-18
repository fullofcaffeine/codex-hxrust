package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHookTrustKind(String) to String {
	final Managed = "managed";
	final Trusted = "trusted";
	final Untrusted = "untrusted";
	final Modified = "modified";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHookTrustKind {
		return switch value {
			case "managed": Managed;
			case "trusted": Trusted;
			case "untrusted": Untrusted;
			case "modified": Modified;
			case _: Unknown;
		}
	}
}
