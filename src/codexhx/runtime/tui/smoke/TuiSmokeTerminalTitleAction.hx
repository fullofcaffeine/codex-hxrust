package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalTitleActionFields = {
	final kind:TuiSmokeTerminalTitleActionKind;
	final rawTitle:String;
	final sanitizedTitle:String;
	final lastTitleBefore:String;
	final lastTitleAfter:String;
	final stdoutTerminal:Bool;
	final liveWriteAllowed:Bool;
	final applied:Bool;
	final noVisibleContent:Bool;
	final duplicateSkipped:Bool;
	final cleared:Bool;
	final maxChars:Int;
	final invalidItemCount:Int;
	final frameScheduled:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalTitleAction {
	public final kind:TuiSmokeTerminalTitleActionKind;
	public final rawTitle:String;
	public final sanitizedTitle:String;
	public final lastTitleBefore:String;
	public final lastTitleAfter:String;
	public final stdoutTerminal:Bool;
	public final liveWriteAllowed:Bool;
	public final applied:Bool;
	public final noVisibleContent:Bool;
	public final duplicateSkipped:Bool;
	public final cleared:Bool;
	public final maxChars:Int;
	public final invalidItemCount:Int;
	public final frameScheduled:Bool;
	public final failureCode:String;

	public function effectiveMaxChars():Int {
		return maxChars <= 0 ? TuiSmokeTerminalTitleSanitizer.defaultMaxChars() : maxChars;
	}

	public function computedSanitizedTitle():String {
		return TuiSmokeTerminalTitleSanitizer.sanitize(rawTitle, effectiveMaxChars());
	}

	public function sanitizedMatches():Bool {
		return computedSanitizedTitle() == sanitizedTitle;
	}
}
