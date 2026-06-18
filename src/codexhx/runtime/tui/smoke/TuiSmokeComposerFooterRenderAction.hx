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
	final noLiveTerminal:Bool;
	final noRatatuiRender:Bool;
	final unsupportedRejected:Bool;
}

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
	public final noLiveTerminal:Bool;
	public final noRatatuiRender:Bool;
	public final unsupportedRejected:Bool;

	public function new(fields:TuiSmokeComposerFooterRenderActionFields) {
		this.kind = fields.kind == null ? TuiSmokeComposerFooterRenderActionKind.Unknown : fields.kind;
		this.modeBefore = fields.modeBefore == null ? TuiSmokeComposerFooterModeKind.Unknown : fields.modeBefore;
		this.modeAfter = fields.modeAfter == null ? TuiSmokeComposerFooterModeKind.Unknown : fields.modeAfter;
		this.baseMode = fields.baseMode == null ? TuiSmokeComposerFooterModeKind.Unknown : fields.baseMode;
		this.keyName = fields.keyName == null ? "" : fields.keyName;
		this.statusText = fields.statusText == null ? "" : fields.statusText;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.footerHeight = fields.footerHeight;
		this.spacing = fields.spacing;
		this.totalHeight = fields.totalHeight;
		this.lineCount = fields.lineCount;
		this.hintCount = fields.hintCount;
		this.width = fields.width;
		this.hasInputFocus = fields.hasInputFocus;
		this.taskRunning = fields.taskRunning;
		this.inputEmpty = fields.inputEmpty;
		this.historySearchActive = fields.historySearchActive;
		this.quitHintVisible = fields.quitHintVisible;
		this.quitHintExpired = fields.quitHintExpired;
		this.shortcutOverlayActive = fields.shortcutOverlayActive;
		this.collaborationModesEnabled = fields.collaborationModesEnabled;
		this.collaborationIndicatorVisible = fields.collaborationIndicatorVisible;
		this.showCycleHint = fields.showCycleHint;
		this.showShortcutsHint = fields.showShortcutsHint;
		this.showQueueHint = fields.showQueueHint;
		this.pasteBurstActive = fields.pasteBurstActive;
		this.statusLineEnabled = fields.statusLineEnabled;
		this.passiveStatusActive = fields.passiveStatusActive;
		this.statusHyperlinkActive = fields.statusHyperlinkActive;
		this.escBacktrackHint = fields.escBacktrackHint;
		this.ctrlCQuitHint = fields.ctrlCQuitHint;
		this.noLiveTerminal = fields.noLiveTerminal;
		this.noRatatuiRender = fields.noRatatuiRender;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

	public function modeTransitionText():String {
		return modeBefore + "->" + modeAfter;
	}

	public function heightText():String {
		return "lines=" + footerHeight + ":spacing=" + spacing + ":total=" + totalHeight;
	}
}
