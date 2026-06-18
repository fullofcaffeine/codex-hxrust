package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHookSourceKind(String) to String {
	final System = "system";
	final User = "user";
	final Project = "project";
	final Plugin = "plugin";
	final CloudManagedConfig = "cloud_managed_config";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHookSourceKind {
		return switch value {
			case "system": System;
			case "user": User;
			case "project": Project;
			case "plugin": Plugin;
			case "cloud_managed_config": CloudManagedConfig;
			case _: Unknown;
		}
	}
}
