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
	final textElementBefore:Int;
	final textElementAfter:Int;
	final localImageBefore:Int;
	final localImageAfter:Int;
	final remoteImageBefore:Int;
	final remoteImageAfter:Int;
	final queueBefore:Int;
	final queueAfter:Int;
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
	final blockedRestored:Bool;
	final appEventSent:Bool;
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
	public final textElementBefore:Int;
	public final textElementAfter:Int;
	public final localImageBefore:Int;
	public final localImageAfter:Int;
	public final remoteImageBefore:Int;
	public final remoteImageAfter:Int;
	public final queueBefore:Int;
	public final queueAfter:Int;
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
	public final blockedRestored:Bool;
	public final appEventSent:Bool;
	public final noLiveDispatch:Bool;
	public final unsupportedRejected:Bool;


	public function pendingTransitionText():String {
		return pendingBefore + "->" + pendingAfter;
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
}
