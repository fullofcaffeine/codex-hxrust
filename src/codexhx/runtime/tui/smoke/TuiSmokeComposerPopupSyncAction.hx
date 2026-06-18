package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerPopupSyncActionFields = {
	final kind:TuiSmokeComposerPopupSyncActionKind;
	final popupBefore:TuiSmokeComposerPopupKind;
	final popupAfter:TuiSmokeComposerPopupKind;
	final inputText:String;
	final token:String;
	final query:String;
	final failureCode:String;
	final candidateCount:Int;
	final fileCandidateCount:Int;
	final skillCandidateCount:Int;
	final pluginCandidateCount:Int;
	final appCandidateCount:Int;
	final popupsEnabled:Bool;
	final slashCommandsEnabled:Bool;
	final bashMode:Bool;
	final mentionsV2Enabled:Bool;
	final historySearchActive:Bool;
	final browsingHistory:Bool;
	final commandAllowed:Bool;
	final commandPopupUpdated:Bool;
	final commandPopupCreated:Bool;
	final commandPopupDismissed:Bool;
	final fileTokenPresent:Bool;
	final mentionTokenPresent:Bool;
	final mentionsV2TokenPresent:Bool;
	final fileSearchStarted:Bool;
	final fileSearchCleared:Bool;
	final currentFileQueryBefore:Bool;
	final currentFileQueryAfter:Bool;
	final dismissedFileTokenMatched:Bool;
	final dismissedMentionTokenMatched:Bool;
	final dismissedFileTokenCleared:Bool;
	final dismissedMentionTokenCleared:Bool;
	final popupCleared:Bool;
	final noLiveFileSearch:Bool;
	final unsupportedRejected:Bool;
}

class TuiSmokeComposerPopupSyncAction {
	public final kind:TuiSmokeComposerPopupSyncActionKind;
	public final popupBefore:TuiSmokeComposerPopupKind;
	public final popupAfter:TuiSmokeComposerPopupKind;
	public final inputText:String;
	public final token:String;
	public final query:String;
	public final failureCode:String;
	public final candidateCount:Int;
	public final fileCandidateCount:Int;
	public final skillCandidateCount:Int;
	public final pluginCandidateCount:Int;
	public final appCandidateCount:Int;
	public final popupsEnabled:Bool;
	public final slashCommandsEnabled:Bool;
	public final bashMode:Bool;
	public final mentionsV2Enabled:Bool;
	public final historySearchActive:Bool;
	public final browsingHistory:Bool;
	public final commandAllowed:Bool;
	public final commandPopupUpdated:Bool;
	public final commandPopupCreated:Bool;
	public final commandPopupDismissed:Bool;
	public final fileTokenPresent:Bool;
	public final mentionTokenPresent:Bool;
	public final mentionsV2TokenPresent:Bool;
	public final fileSearchStarted:Bool;
	public final fileSearchCleared:Bool;
	public final currentFileQueryBefore:Bool;
	public final currentFileQueryAfter:Bool;
	public final dismissedFileTokenMatched:Bool;
	public final dismissedMentionTokenMatched:Bool;
	public final dismissedFileTokenCleared:Bool;
	public final dismissedMentionTokenCleared:Bool;
	public final popupCleared:Bool;
	public final noLiveFileSearch:Bool;
	public final unsupportedRejected:Bool;

	public function new(fields:TuiSmokeComposerPopupSyncActionFields) {
		this.kind = fields.kind == null ? TuiSmokeComposerPopupSyncActionKind.Unknown : fields.kind;
		this.popupBefore = fields.popupBefore == null ? TuiSmokeComposerPopupKind.Unknown : fields.popupBefore;
		this.popupAfter = fields.popupAfter == null ? TuiSmokeComposerPopupKind.Unknown : fields.popupAfter;
		this.inputText = fields.inputText == null ? "" : fields.inputText;
		this.token = fields.token == null ? "" : fields.token;
		this.query = fields.query == null ? "" : fields.query;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.candidateCount = fields.candidateCount;
		this.fileCandidateCount = fields.fileCandidateCount;
		this.skillCandidateCount = fields.skillCandidateCount;
		this.pluginCandidateCount = fields.pluginCandidateCount;
		this.appCandidateCount = fields.appCandidateCount;
		this.popupsEnabled = fields.popupsEnabled;
		this.slashCommandsEnabled = fields.slashCommandsEnabled;
		this.bashMode = fields.bashMode;
		this.mentionsV2Enabled = fields.mentionsV2Enabled;
		this.historySearchActive = fields.historySearchActive;
		this.browsingHistory = fields.browsingHistory;
		this.commandAllowed = fields.commandAllowed;
		this.commandPopupUpdated = fields.commandPopupUpdated;
		this.commandPopupCreated = fields.commandPopupCreated;
		this.commandPopupDismissed = fields.commandPopupDismissed;
		this.fileTokenPresent = fields.fileTokenPresent;
		this.mentionTokenPresent = fields.mentionTokenPresent;
		this.mentionsV2TokenPresent = fields.mentionsV2TokenPresent;
		this.fileSearchStarted = fields.fileSearchStarted;
		this.fileSearchCleared = fields.fileSearchCleared;
		this.currentFileQueryBefore = fields.currentFileQueryBefore;
		this.currentFileQueryAfter = fields.currentFileQueryAfter;
		this.dismissedFileTokenMatched = fields.dismissedFileTokenMatched;
		this.dismissedMentionTokenMatched = fields.dismissedMentionTokenMatched;
		this.dismissedFileTokenCleared = fields.dismissedFileTokenCleared;
		this.dismissedMentionTokenCleared = fields.dismissedMentionTokenCleared;
		this.popupCleared = fields.popupCleared;
		this.noLiveFileSearch = fields.noLiveFileSearch;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

	public function popupTransitionText():String {
		return popupBefore + "->" + popupAfter;
	}

	public function currentFileQueryTransitionText():String {
		return currentFileQueryBefore + "->" + currentFileQueryAfter;
	}
}
