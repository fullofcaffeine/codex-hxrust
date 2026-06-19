package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeKeymapRawOutputActionKind(String) to String {
	final RawOutputDefault = "raw_output_default";
	final RawOutputRemap = "raw_output_remap";
	final ToggleRawOutput = "toggle_raw_output";
	final ExplicitUnbind = "explicit_unbind";
	final EditorAliases = "editor_aliases";
	final MainSurfaceAssignment = "main_surface_assignment";
	final MainSurfaceConflict = "main_surface_conflict";
	final FixedShortcutConflict = "fixed_shortcut_conflict";
	final FixedShortcutUnbindRemap = "fixed_shortcut_unbind_remap";
	final DefaultPruning = "default_pruning";
	final BindingInput = "binding_input";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeKeymapRawOutputActionKind {
		return switch value {
			case "raw_output_default": RawOutputDefault;
			case "raw_output_remap": RawOutputRemap;
			case "toggle_raw_output": ToggleRawOutput;
			case "explicit_unbind": ExplicitUnbind;
			case "editor_aliases": EditorAliases;
			case "main_surface_assignment": MainSurfaceAssignment;
			case "main_surface_conflict": MainSurfaceConflict;
			case "fixed_shortcut_conflict": FixedShortcutConflict;
			case "fixed_shortcut_unbind_remap": FixedShortcutUnbindRemap;
			case "default_pruning": DefaultPruning;
			case "binding_input": BindingInput;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
