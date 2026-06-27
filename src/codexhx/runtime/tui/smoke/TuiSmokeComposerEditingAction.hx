package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerEditingActionFields = {
	final kind:TuiSmokeComposerEditingActionKind;
	final result:TuiSmokeComposerEditingResultKind;
	final modeBefore:TuiSmokeComposerEditingModeKind;
	final modeAfter:TuiSmokeComposerEditingModeKind;
	final popupBefore:TuiSmokeComposerPopupKind;
	final popupAfter:TuiSmokeComposerPopupKind;
	final keyName:String;
	final inputText:String;
	final outputText:String;
	final canonicalText:String;
	final textareaText:String;
	final submissionText:String;
	final selectedPath:String;
	final insertText:String;
	final bindingPath:String;
	final tokenBefore:String;
	final tokenAfter:String;
	final placeholderBefore:String;
	final placeholderAfter:String;
	final elementPayloads:String;
	final failureCode:String;
	final cursorBefore:Int;
	final cursorAfter:Int;
	final historyCursor:Int;
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
	final mentionBindingBefore:Int;
	final mentionBindingAfter:Int;
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
	final inputEnabled:Bool;
	final textareaDelegated:Bool;
	final pasteBurstDelegated:Bool;
	final popupSynced:Bool;
	final vimReset:Bool;
	final submissionReadyPreserved:Bool;
	final elementsShifted:Bool;
	final cursorClamped:Bool;
	final pendingExpanded:Bool;
	final textTrimmed:Bool;
	final attachmentsRetained:Bool;
	final attachmentsDropped:Bool;
	final placeholdersRenumbered:Bool;
	final duplicateLimited:Bool;
	final elementsRebuilt:Bool;
	final cursorAtEnd:Bool;
	final noLiveInput:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerEditingAction {
	public final kind:TuiSmokeComposerEditingActionKind;
	public final result:TuiSmokeComposerEditingResultKind;
	public final modeBefore:TuiSmokeComposerEditingModeKind;
	public final modeAfter:TuiSmokeComposerEditingModeKind;
	public final popupBefore:TuiSmokeComposerPopupKind;
	public final popupAfter:TuiSmokeComposerPopupKind;
	public final keyName:String;
	public final inputText:String;
	public final outputText:String;
	public final canonicalText:String;
	public final textareaText:String;
	public final submissionText:String;
	public final selectedPath:String;
	public final insertText:String;
	public final bindingPath:String;
	public final tokenBefore:String;
	public final tokenAfter:String;
	public final placeholderBefore:String;
	public final placeholderAfter:String;
	public final elementPayloads:String;
	public final failureCode:String;
	public final cursorBefore:Int;
	public final cursorAfter:Int;
	public final historyCursor:Int;
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
	public final mentionBindingBefore:Int;
	public final mentionBindingAfter:Int;
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
	public final inputEnabled:Bool;
	public final textareaDelegated:Bool;
	public final pasteBurstDelegated:Bool;
	public final popupSynced:Bool;
	public final vimReset:Bool;
	public final submissionReadyPreserved:Bool;
	public final elementsShifted:Bool;
	public final cursorClamped:Bool;
	public final pendingExpanded:Bool;
	public final textTrimmed:Bool;
	public final attachmentsRetained:Bool;
	public final attachmentsDropped:Bool;
	public final placeholdersRenumbered:Bool;
	public final duplicateLimited:Bool;
	public final elementsRebuilt:Bool;
	public final cursorAtEnd:Bool;
	public final noLiveInput:Bool;
	public final unsupportedRejected:Bool;

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

	public function mentionBindingTransitionText():String {
		return mentionBindingBefore + "->" + mentionBindingAfter;
	}

	public function popupTransitionText():String {
		return popupBefore + "->" + popupAfter;
	}
}
