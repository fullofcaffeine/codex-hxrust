package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalVisualizationActionFields = {
	final kind:TuiSmokeTerminalVisualizationActionKind;
	final featureEnabled:Bool;
	final controlInstructions:String;
	final developerInstructions:String;
	final expectedInstructions:String;
	final usedControl:Bool;
	final usedDeveloperFallback:Bool;
	final appendedTerminalInstructions:Bool;
	final generatedFromEmpty:Bool;
	final failureCode:String;
	final noModelCall:Bool;
	final noAppServerMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalVisualizationAction {
	public static final TerminalInstructions:String = "- This surface is a terminal. When the formatting rules require a visual, include one in the final answer using compact ASCII diagrams, trees, timelines, or tables.\n"
		+ "- Use tables for exact mappings or comparisons rather than collapsing known mappings into prose.\n"
		+
		"- Use trees for hierarchy or one-to-many relationships, and diagrams or timelines for sequence, change, or state transferred between records across event order.\n"
		+ "- Use only ASCII characters in visuals.";

	@:recordDefault(TuiSmokeTerminalVisualizationActionKind.Unknown)
	public final kind:TuiSmokeTerminalVisualizationActionKind;
	public final featureEnabled:Bool;
	public final controlInstructions:String;
	public final developerInstructions:String;
	public final expectedInstructions:String;
	public final usedControl:Bool;
	public final usedDeveloperFallback:Bool;
	public final appendedTerminalInstructions:Bool;
	public final generatedFromEmpty:Bool;
	public final failureCode:String;
	public final noModelCall:Bool;
	public final noAppServerMutation:Bool;
	public final unsupportedRejected:Bool;

	public function computedInstructions():String {
		if (!featureEnabled) {
			return controlInstructions;
		}
		final base = controlInstructions != "" ? controlInstructions : developerInstructions;
		if (StringTools.trim(base) != "") {
			return base + "\n\n" + TerminalInstructions;
		}
		return TerminalInstructions;
	}

	public function instructionsMatch():Bool {
		return expectedInstructions == "" || expectedInstructions == computedInstructions();
	}
}
