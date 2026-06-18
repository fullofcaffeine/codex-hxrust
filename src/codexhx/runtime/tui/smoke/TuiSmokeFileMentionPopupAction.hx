package codexhx.runtime.tui.smoke;

typedef TuiSmokeFileMentionPopupActionFields = {
	final kind:TuiSmokeFileMentionPopupActionKind;
	final popupBefore:TuiSmokeFileMentionPopupKind;
	final popupAfter:TuiSmokeFileMentionPopupKind;
	final candidateKind:TuiSmokeMentionCandidateKind;
	final searchModeBefore:TuiSmokeMentionSearchModeKind;
	final searchModeAfter:TuiSmokeMentionSearchModeKind;
	final inputText:String;
	final token:String;
	final query:String;
	final selectedPath:String;
	final insertText:String;
	final failureCode:String;
	final matchCount:Int;
	final visibleCount:Int;
	final rowCount:Int;
	final selectedBefore:Int;
	final selectedAfter:Int;
	final scrollBefore:Int;
	final scrollAfter:Int;
	final maxRows:Int;
	final fileCandidateCount:Int;
	final directoryCandidateCount:Int;
	final skillCandidateCount:Int;
	final pluginCandidateCount:Int;
	final toolCandidateCount:Int;
	final mentionsV2Enabled:Bool;
	final slashPopupSuppressed:Bool;
	final queryStartSent:Bool;
	final queryClearSent:Bool;
	final sameQuerySkipped:Bool;
	final resultAccepted:Bool;
	final resultStale:Bool;
	final popupCreated:Bool;
	final popupDismissed:Bool;
	final dismissedTokenStored:Bool;
	final bindingStored:Bool;
	final draftUpdated:Bool;
	final frameScheduled:Bool;
	final redrawRequested:Bool;
	final liveSearchRejected:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeFileMentionPopupAction {
	public final kind:TuiSmokeFileMentionPopupActionKind;
	public final popupBefore:TuiSmokeFileMentionPopupKind;
	public final popupAfter:TuiSmokeFileMentionPopupKind;
	public final candidateKind:TuiSmokeMentionCandidateKind;
	public final searchModeBefore:TuiSmokeMentionSearchModeKind;
	public final searchModeAfter:TuiSmokeMentionSearchModeKind;
	public final inputText:String;
	public final token:String;
	public final query:String;
	public final selectedPath:String;
	public final insertText:String;
	public final failureCode:String;
	public final matchCount:Int;
	public final visibleCount:Int;
	public final rowCount:Int;
	public final selectedBefore:Int;
	public final selectedAfter:Int;
	public final scrollBefore:Int;
	public final scrollAfter:Int;
	public final maxRows:Int;
	public final fileCandidateCount:Int;
	public final directoryCandidateCount:Int;
	public final skillCandidateCount:Int;
	public final pluginCandidateCount:Int;
	public final toolCandidateCount:Int;
	public final mentionsV2Enabled:Bool;
	public final slashPopupSuppressed:Bool;
	public final queryStartSent:Bool;
	public final queryClearSent:Bool;
	public final sameQuerySkipped:Bool;
	public final resultAccepted:Bool;
	public final resultStale:Bool;
	public final popupCreated:Bool;
	public final popupDismissed:Bool;
	public final dismissedTokenStored:Bool;
	public final bindingStored:Bool;
	public final draftUpdated:Bool;
	public final frameScheduled:Bool;
	public final redrawRequested:Bool;
	public final liveSearchRejected:Bool;
	public final unsupportedRejected:Bool;


	public function popupTransitionText():String {
		return popupBefore + "->" + popupAfter;
	}

	public function searchModeTransitionText():String {
		return searchModeBefore + "->" + searchModeAfter;
	}

	public function selectionTransitionText():String {
		return selectedBefore + "->" + selectedAfter;
	}

	public function scrollTransitionText():String {
		return scrollBefore + "->" + scrollAfter;
	}
}
