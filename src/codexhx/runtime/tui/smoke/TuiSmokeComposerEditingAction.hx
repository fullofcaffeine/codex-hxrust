package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerEditingActionFields = {
	final kind:TuiSmokeComposerEditingActionKind;
	final result:TuiSmokeComposerEditingResultKind;
	final modeBefore:TuiSmokeComposerEditingModeKind;
	final modeAfter:TuiSmokeComposerEditingModeKind;
	final keyName:String;
	final inputText:String;
	final outputText:String;
	final failureCode:String;
	final cursorBefore:Int;
	final cursorAfter:Int;
	final pendingPasteBefore:Int;
	final pendingPasteAfter:Int;
	final elementBefore:Int;
	final elementAfter:Int;
	final localImageBefore:Int;
	final localImageAfter:Int;
	final remoteImageBefore:Int;
	final remoteImageAfter:Int;
	final selectedRemoteBefore:Int;
	final selectedRemoteAfter:Int;
	final needsRedraw:Bool;
	final keyConsumed:Bool;
	final releaseIgnored:Bool;
	final queueSubmissions:Bool;
	final taskRunning:Bool;
	final shellCommand:Bool;
	final submissionQueued:Bool;
	final submissionSubmitted:Bool;
	final pasteBurstActiveBefore:Bool;
	final pasteBurstActiveAfter:Bool;
	final pasteBurstFlushed:Bool;
	final burstWindowCleared:Bool;
	final newlineCaptured:Bool;
	final remoteSelectionHandled:Bool;
	final remoteSelectionCleared:Bool;
	final shortcutOverlayHandled:Bool;
	final bashModeEnabled:Bool;
	final bashModeDisabled:Bool;
	final vimInsertEscapeHandled:Bool;
	final historyHandled:Bool;
	final historyApplied:Bool;
	final pendingPastePruned:Bool;
	final localImagesPruned:Bool;
	final noLiveInput:Bool;
	final unsupportedRejected:Bool;
}

class TuiSmokeComposerEditingAction {
	public final kind:TuiSmokeComposerEditingActionKind;
	public final result:TuiSmokeComposerEditingResultKind;
	public final modeBefore:TuiSmokeComposerEditingModeKind;
	public final modeAfter:TuiSmokeComposerEditingModeKind;
	public final keyName:String;
	public final inputText:String;
	public final outputText:String;
	public final failureCode:String;
	public final cursorBefore:Int;
	public final cursorAfter:Int;
	public final pendingPasteBefore:Int;
	public final pendingPasteAfter:Int;
	public final elementBefore:Int;
	public final elementAfter:Int;
	public final localImageBefore:Int;
	public final localImageAfter:Int;
	public final remoteImageBefore:Int;
	public final remoteImageAfter:Int;
	public final selectedRemoteBefore:Int;
	public final selectedRemoteAfter:Int;
	public final needsRedraw:Bool;
	public final keyConsumed:Bool;
	public final releaseIgnored:Bool;
	public final queueSubmissions:Bool;
	public final taskRunning:Bool;
	public final shellCommand:Bool;
	public final submissionQueued:Bool;
	public final submissionSubmitted:Bool;
	public final pasteBurstActiveBefore:Bool;
	public final pasteBurstActiveAfter:Bool;
	public final pasteBurstFlushed:Bool;
	public final burstWindowCleared:Bool;
	public final newlineCaptured:Bool;
	public final remoteSelectionHandled:Bool;
	public final remoteSelectionCleared:Bool;
	public final shortcutOverlayHandled:Bool;
	public final bashModeEnabled:Bool;
	public final bashModeDisabled:Bool;
	public final vimInsertEscapeHandled:Bool;
	public final historyHandled:Bool;
	public final historyApplied:Bool;
	public final pendingPastePruned:Bool;
	public final localImagesPruned:Bool;
	public final noLiveInput:Bool;
	public final unsupportedRejected:Bool;

	public function new(fields:TuiSmokeComposerEditingActionFields) {
		this.kind = fields.kind == null ? TuiSmokeComposerEditingActionKind.Unknown : fields.kind;
		this.result = fields.result == null ? TuiSmokeComposerEditingResultKind.Unknown : fields.result;
		this.modeBefore = fields.modeBefore == null ? TuiSmokeComposerEditingModeKind.Unknown : fields.modeBefore;
		this.modeAfter = fields.modeAfter == null ? TuiSmokeComposerEditingModeKind.Unknown : fields.modeAfter;
		this.keyName = fields.keyName == null ? "" : fields.keyName;
		this.inputText = fields.inputText == null ? "" : fields.inputText;
		this.outputText = fields.outputText == null ? "" : fields.outputText;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.cursorBefore = fields.cursorBefore;
		this.cursorAfter = fields.cursorAfter;
		this.pendingPasteBefore = fields.pendingPasteBefore;
		this.pendingPasteAfter = fields.pendingPasteAfter;
		this.elementBefore = fields.elementBefore;
		this.elementAfter = fields.elementAfter;
		this.localImageBefore = fields.localImageBefore;
		this.localImageAfter = fields.localImageAfter;
		this.remoteImageBefore = fields.remoteImageBefore;
		this.remoteImageAfter = fields.remoteImageAfter;
		this.selectedRemoteBefore = fields.selectedRemoteBefore;
		this.selectedRemoteAfter = fields.selectedRemoteAfter;
		this.needsRedraw = fields.needsRedraw;
		this.keyConsumed = fields.keyConsumed;
		this.releaseIgnored = fields.releaseIgnored;
		this.queueSubmissions = fields.queueSubmissions;
		this.taskRunning = fields.taskRunning;
		this.shellCommand = fields.shellCommand;
		this.submissionQueued = fields.submissionQueued;
		this.submissionSubmitted = fields.submissionSubmitted;
		this.pasteBurstActiveBefore = fields.pasteBurstActiveBefore;
		this.pasteBurstActiveAfter = fields.pasteBurstActiveAfter;
		this.pasteBurstFlushed = fields.pasteBurstFlushed;
		this.burstWindowCleared = fields.burstWindowCleared;
		this.newlineCaptured = fields.newlineCaptured;
		this.remoteSelectionHandled = fields.remoteSelectionHandled;
		this.remoteSelectionCleared = fields.remoteSelectionCleared;
		this.shortcutOverlayHandled = fields.shortcutOverlayHandled;
		this.bashModeEnabled = fields.bashModeEnabled;
		this.bashModeDisabled = fields.bashModeDisabled;
		this.vimInsertEscapeHandled = fields.vimInsertEscapeHandled;
		this.historyHandled = fields.historyHandled;
		this.historyApplied = fields.historyApplied;
		this.pendingPastePruned = fields.pendingPastePruned;
		this.localImagesPruned = fields.localImagesPruned;
		this.noLiveInput = fields.noLiveInput;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

	public function cursorTransitionText():String {
		return cursorBefore + "->" + cursorAfter;
	}

	public function pendingPasteTransitionText():String {
		return pendingPasteBefore + "->" + pendingPasteAfter;
	}

	public function elementTransitionText():String {
		return elementBefore + "->" + elementAfter;
	}

	public function localImageTransitionText():String {
		return localImageBefore + "->" + localImageAfter;
	}

	public function remoteImageTransitionText():String {
		return remoteImageBefore + "->" + remoteImageAfter;
	}

	public function selectedRemoteTransitionText():String {
		return selectedRemoteBefore + "->" + selectedRemoteAfter;
	}
}
