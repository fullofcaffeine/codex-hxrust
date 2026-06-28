package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerFooterRenderActionFields = {
	final kind:TuiSmokeComposerFooterRenderActionKind;
	final modeBefore:TuiSmokeComposerFooterModeKind;
	final modeAfter:TuiSmokeComposerFooterModeKind;
	final baseMode:TuiSmokeComposerFooterModeKind;
	final keyName:String;
	final statusText:String;
	final failureCode:String;
	final footerHeight:Int;
	final spacing:Int;
	final totalHeight:Int;
	final lineCount:Int;
	final hintCount:Int;
	final width:Int;
	final hasInputFocus:Bool;
	final taskRunning:Bool;
	final inputEmpty:Bool;
	final historySearchActive:Bool;
	final quitHintVisible:Bool;
	final quitHintExpired:Bool;
	final shortcutOverlayActive:Bool;
	final collaborationModesEnabled:Bool;
	final collaborationIndicatorVisible:Bool;
	final showCycleHint:Bool;
	final showShortcutsHint:Bool;
	final showQueueHint:Bool;
	final pasteBurstActive:Bool;
	final statusLineEnabled:Bool;
	final passiveStatusActive:Bool;
	final statusHyperlinkActive:Bool;
	final escBacktrackHint:Bool;
	final ctrlCQuitHint:Bool;
	final ctrlDQuitHint:Bool;
	final quitShortcutKeyMatched:Bool;
	final quitShortcutHintCleared:Bool;
	final expiryRedrawScheduled:Bool;
	final activityClearsHint:Bool;
	final requestRedraw:Bool;
	final reminderText:String;
	final noLiveTerminal:Bool;
	final noRatatuiRender:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerFooterRenderAction {
	public final kind:TuiSmokeComposerFooterRenderActionKind;
	public final modeBefore:TuiSmokeComposerFooterModeKind;
	public final modeAfter:TuiSmokeComposerFooterModeKind;
	public final baseMode:TuiSmokeComposerFooterModeKind;
	public final keyName:String;
	public final statusText:String;
	public final failureCode:String;
	public final footerHeight:Int;
	public final spacing:Int;
	public final totalHeight:Int;
	public final lineCount:Int;
	public final hintCount:Int;
	public final width:Int;
	public final hasInputFocus:Bool;
	public final taskRunning:Bool;
	public final inputEmpty:Bool;
	public final historySearchActive:Bool;
	public final quitHintVisible:Bool;
	public final quitHintExpired:Bool;
	public final shortcutOverlayActive:Bool;
	public final collaborationModesEnabled:Bool;
	public final collaborationIndicatorVisible:Bool;
	public final showCycleHint:Bool;
	public final showShortcutsHint:Bool;
	public final showQueueHint:Bool;
	public final pasteBurstActive:Bool;
	public final statusLineEnabled:Bool;
	public final passiveStatusActive:Bool;
	public final statusHyperlinkActive:Bool;
	public final escBacktrackHint:Bool;
	public final ctrlCQuitHint:Bool;
	public final ctrlDQuitHint:Bool;
	public final quitShortcutKeyMatched:Bool;
	public final quitShortcutHintCleared:Bool;
	public final expiryRedrawScheduled:Bool;
	public final activityClearsHint:Bool;
	public final requestRedraw:Bool;
	public final reminderText:String;
	public final noLiveTerminal:Bool;
	public final noRatatuiRender:Bool;
	public final unsupportedRejected:Bool;

	public function modeTransitionText():String {
		return modeBefore + "->" + modeAfter;
	}

	public function heightText():String {
		return "lines=" + footerHeight + ":spacing=" + spacing + ":total=" + totalHeight;
	}
}
