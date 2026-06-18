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

	public function new(fields:TuiSmokeFileMentionPopupActionFields) {
		this.kind = fields.kind == null ? TuiSmokeFileMentionPopupActionKind.Unknown : fields.kind;
		this.popupBefore = fields.popupBefore == null ? TuiSmokeFileMentionPopupKind.Unknown : fields.popupBefore;
		this.popupAfter = fields.popupAfter == null ? TuiSmokeFileMentionPopupKind.Unknown : fields.popupAfter;
		this.candidateKind = fields.candidateKind == null ? TuiSmokeMentionCandidateKind.Unknown : fields.candidateKind;
		this.searchModeBefore = fields.searchModeBefore == null ? TuiSmokeMentionSearchModeKind.Unknown : fields.searchModeBefore;
		this.searchModeAfter = fields.searchModeAfter == null ? TuiSmokeMentionSearchModeKind.Unknown : fields.searchModeAfter;
		this.inputText = fields.inputText == null ? "" : fields.inputText;
		this.token = fields.token == null ? "" : fields.token;
		this.query = fields.query == null ? "" : fields.query;
		this.selectedPath = fields.selectedPath == null ? "" : fields.selectedPath;
		this.insertText = fields.insertText == null ? "" : fields.insertText;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.matchCount = fields.matchCount;
		this.visibleCount = fields.visibleCount;
		this.rowCount = fields.rowCount;
		this.selectedBefore = fields.selectedBefore;
		this.selectedAfter = fields.selectedAfter;
		this.scrollBefore = fields.scrollBefore;
		this.scrollAfter = fields.scrollAfter;
		this.maxRows = fields.maxRows;
		this.fileCandidateCount = fields.fileCandidateCount;
		this.directoryCandidateCount = fields.directoryCandidateCount;
		this.skillCandidateCount = fields.skillCandidateCount;
		this.pluginCandidateCount = fields.pluginCandidateCount;
		this.toolCandidateCount = fields.toolCandidateCount;
		this.mentionsV2Enabled = fields.mentionsV2Enabled;
		this.slashPopupSuppressed = fields.slashPopupSuppressed;
		this.queryStartSent = fields.queryStartSent;
		this.queryClearSent = fields.queryClearSent;
		this.sameQuerySkipped = fields.sameQuerySkipped;
		this.resultAccepted = fields.resultAccepted;
		this.resultStale = fields.resultStale;
		this.popupCreated = fields.popupCreated;
		this.popupDismissed = fields.popupDismissed;
		this.dismissedTokenStored = fields.dismissedTokenStored;
		this.bindingStored = fields.bindingStored;
		this.draftUpdated = fields.draftUpdated;
		this.frameScheduled = fields.frameScheduled;
		this.redrawRequested = fields.redrawRequested;
		this.liveSearchRejected = fields.liveSearchRejected;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

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
