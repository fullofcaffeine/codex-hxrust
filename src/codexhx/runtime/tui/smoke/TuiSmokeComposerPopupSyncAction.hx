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

@:build(codexhx.macros.FieldRecordConstructor.build())
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

	public function popupTransitionText():String {
		return popupBefore + "->" + popupAfter;
	}

	public function currentFileQueryTransitionText():String {
		return currentFileQueryBefore + "->" + currentFileQueryAfter;
	}
}
