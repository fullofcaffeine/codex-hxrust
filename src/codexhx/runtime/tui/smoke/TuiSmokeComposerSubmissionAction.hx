package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerSubmissionActionFields = {
	final kind:TuiSmokeComposerSubmissionActionKind;
	final result:TuiSmokeComposerSubmissionResultKind;
	final queuedAction:TuiSmokeComposerQueuedActionKind;
	final slashValidation:TuiSmokeComposerSlashValidationKind;
	final inputText:String;
	final preparedText:String;
	final argsText:String;
	final commandName:String;
	final failureCode:String;
	final charCount:Int;
	final maxChars:Int;
	final pendingBefore:Int;
	final pendingAfter:Int;
	final cursorBefore:Int;
	final cursorAfter:Int;
	final textElementBefore:Int;
	final textElementAfter:Int;
	final localImageBefore:Int;
	final localImageAfter:Int;
	final remoteImageBefore:Int;
	final remoteImageAfter:Int;
	final textItemCount:Int;
	final remoteImageItemCount:Int;
	final localImageItemCount:Int;
	final skillItemCount:Int;
	final mentionItemCount:Int;
	final itemCount:Int;
	final mentionBindingCount:Int;
	final mentionBindingBefore:Int;
	final mentionBindingAfter:Int;
	final recentMentionBindingBefore:Int;
	final recentMentionBindingAfter:Int;
	final queueBefore:Int;
	final queueAfter:Int;
	final itemOrder:String;
	final mentionBindingSummary:String;
	final modelName:String;
	final shouldQueue:Bool;
	final recordHistory:Bool;
	final pasteBurstFlushed:Bool;
	final pendingExpanded:Bool;
	final pendingRestored:Bool;
	final pendingCleared:Bool;
	final textTrimmed:Bool;
	final slashValidationDeferred:Bool;
	final slashValidationFailed:Bool;
	final tooLargeRejected:Bool;
	final emptySuppressed:Bool;
	final imagesPruned:Bool;
	final localImagesDrained:Bool;
	final remoteImagesDrained:Bool;
	final messageBuilt:Bool;
	final submittedNow:Bool;
	final queued:Bool;
	final statusWorking:Bool;
	final reasoningCleared:Bool;
	final historyStaged:Bool;
	final historyRecorded:Bool;
	final vimNormalEntered:Bool;
	final modelSupportsImages:Bool;
	final sessionConfigured:Bool;
	final modelAvailable:Bool;
	final blockedRestored:Bool;
	final userTurnSubmitted:Bool;
	final shellEscapeAllowed:Bool;
	final shellCommandSubmitted:Bool;
	final renderInHistory:Bool;
	final pendingSteerQueued:Bool;
	final displayRecorded:Bool;
	final cancelEditRecorded:Bool;
	final ideContextApplied:Bool;
	final collaborationModeAttached:Bool;
	final emptySuppressedBeforeDispatch:Bool;
	final appEventSent:Bool;
	final draftCleared:Bool;
	final mentionBindingsRestored:Bool;
	final recentMentionBindingsDrained:Bool;
	final invalidBindingsDropped:Bool;
	final pathlessBindingsIgnored:Bool;
	final mentionBindingsSubmitted:Bool;
	final pluginAccentApplied:Bool;
	final popupSuppressed:Bool;
	final arrowNavigationPassed:Bool;
	final sigilMatched:Bool;
	final boundaryMatched:Bool;
	final emailSubstringSkipped:Bool;
	final punctuationBoundaryAccepted:Bool;
	final noLiveDispatch:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerSubmissionAction {
	public final kind:TuiSmokeComposerSubmissionActionKind;
	public final result:TuiSmokeComposerSubmissionResultKind;
	public final queuedAction:TuiSmokeComposerQueuedActionKind;
	public final slashValidation:TuiSmokeComposerSlashValidationKind;
	public final inputText:String;
	public final preparedText:String;
	public final argsText:String;
	public final commandName:String;
	public final failureCode:String;
	public final charCount:Int;
	public final maxChars:Int;
	public final pendingBefore:Int;
	public final pendingAfter:Int;
	public final cursorBefore:Int;
	public final cursorAfter:Int;
	public final textElementBefore:Int;
	public final textElementAfter:Int;
	public final localImageBefore:Int;
	public final localImageAfter:Int;
	public final remoteImageBefore:Int;
	public final remoteImageAfter:Int;
	@:recordMin(0)
	public final textItemCount:Int;
	@:recordMin(0)
	public final remoteImageItemCount:Int;
	@:recordMin(0)
	public final localImageItemCount:Int;
	@:recordMin(0)
	public final skillItemCount:Int;
	@:recordMin(0)
	public final mentionItemCount:Int;
	@:recordMin(0)
	public final itemCount:Int;
	@:recordMin(0)
	public final mentionBindingCount:Int;
	@:recordMin(0)
	public final mentionBindingBefore:Int;
	@:recordMin(0)
	public final mentionBindingAfter:Int;
	@:recordMin(0)
	public final recentMentionBindingBefore:Int;
	@:recordMin(0)
	public final recentMentionBindingAfter:Int;
	public final queueBefore:Int;
	public final queueAfter:Int;
	public final itemOrder:String;
	public final mentionBindingSummary:String;
	public final modelName:String;
	public final shouldQueue:Bool;
	public final recordHistory:Bool;
	public final pasteBurstFlushed:Bool;
	public final pendingExpanded:Bool;
	public final pendingRestored:Bool;
	public final pendingCleared:Bool;
	public final textTrimmed:Bool;
	public final slashValidationDeferred:Bool;
	public final slashValidationFailed:Bool;
	public final tooLargeRejected:Bool;
	public final emptySuppressed:Bool;
	public final imagesPruned:Bool;
	public final localImagesDrained:Bool;
	public final remoteImagesDrained:Bool;
	public final messageBuilt:Bool;
	public final submittedNow:Bool;
	public final queued:Bool;
	public final statusWorking:Bool;
	public final reasoningCleared:Bool;
	public final historyStaged:Bool;
	public final historyRecorded:Bool;
	public final vimNormalEntered:Bool;
	public final modelSupportsImages:Bool;
	public final sessionConfigured:Bool;
	public final modelAvailable:Bool;
	public final blockedRestored:Bool;
	public final userTurnSubmitted:Bool;
	public final shellEscapeAllowed:Bool;
	public final shellCommandSubmitted:Bool;
	public final renderInHistory:Bool;
	public final pendingSteerQueued:Bool;
	public final displayRecorded:Bool;
	public final cancelEditRecorded:Bool;
	public final ideContextApplied:Bool;
	public final collaborationModeAttached:Bool;
	public final emptySuppressedBeforeDispatch:Bool;
	public final appEventSent:Bool;
	public final draftCleared:Bool;
	public final mentionBindingsRestored:Bool;
	public final recentMentionBindingsDrained:Bool;
	public final invalidBindingsDropped:Bool;
	public final pathlessBindingsIgnored:Bool;
	public final mentionBindingsSubmitted:Bool;
	public final pluginAccentApplied:Bool;
	public final popupSuppressed:Bool;
	public final arrowNavigationPassed:Bool;
	public final sigilMatched:Bool;
	public final boundaryMatched:Bool;
	public final emailSubstringSkipped:Bool;
	public final punctuationBoundaryAccepted:Bool;
	public final noLiveDispatch:Bool;
	public final unsupportedRejected:Bool;

	public function pendingTransitionText():String {
		return pendingBefore + "->" + pendingAfter;
	}

	public function cursorTransitionText():String {
		return cursorBefore + "->" + cursorAfter;
	}

	public function elementTransitionText():String {
		return textElementBefore + "->" + textElementAfter;
	}

	public function localImageTransitionText():String {
		return localImageBefore + "->" + localImageAfter;
	}

	public function remoteImageTransitionText():String {
		return remoteImageBefore + "->" + remoteImageAfter;
	}

	public function queueTransitionText():String {
		return queueBefore + "->" + queueAfter;
	}

	public function mentionBindingTransitionText():String {
		return mentionBindingBefore + "->" + mentionBindingAfter;
	}

	public function recentMentionBindingTransitionText():String {
		return recentMentionBindingBefore + "->" + recentMentionBindingAfter;
	}
}
