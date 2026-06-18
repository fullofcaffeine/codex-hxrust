package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerPopupKeyActionFields = {
	final kind:TuiSmokeComposerPopupKeyActionKind;
	final popupBefore:TuiSmokeComposerPopupKind;
	final popupAfter:TuiSmokeComposerPopupKind;
	final candidateKind:TuiSmokeMentionCandidateKind;
	final searchModeBefore:TuiSmokeMentionSearchModeKind;
	final searchModeAfter:TuiSmokeMentionSearchModeKind;
	final keyName:String;
	final commandName:String;
	final token:String;
	final selectedPath:String;
	final insertText:String;
	final failureCode:String;
	final selectedBefore:Int;
	final selectedAfter:Int;
	final scrollBefore:Int;
	final scrollAfter:Int;
	final matchCount:Int;
	final selectedAvailable:Bool;
	final dismissedTokenStored:Bool;
	final draftUpdated:Bool;
	final textCleared:Bool;
	final commandCompleted:Bool;
	final commandDispatched:Bool;
	final serviceTierDispatched:Bool;
	final historyStaged:Bool;
	final inlineArgsPreserved:Bool;
	final imagePath:Bool;
	final imageDimensionsAvailable:Bool;
	final imageAttached:Bool;
	final pathInserted:Bool;
	final mentionBindingStored:Bool;
	final modeSwitchAllowed:Bool;
	final fallbackWithoutPopup:Bool;
	final submitWithoutPopup:Bool;
	final inputForwarded:Bool;
	final shortcutOverlayHandled:Bool;
	final footerModeChanged:Bool;
	final keyConsumed:Bool;
	final syncAfterKey:Bool;
	final redrawRequested:Bool;
	final liveProbeRejected:Bool;
	final unsupportedRejected:Bool;
}

class TuiSmokeComposerPopupKeyAction {
	public final kind:TuiSmokeComposerPopupKeyActionKind;
	public final popupBefore:TuiSmokeComposerPopupKind;
	public final popupAfter:TuiSmokeComposerPopupKind;
	public final candidateKind:TuiSmokeMentionCandidateKind;
	public final searchModeBefore:TuiSmokeMentionSearchModeKind;
	public final searchModeAfter:TuiSmokeMentionSearchModeKind;
	public final keyName:String;
	public final commandName:String;
	public final token:String;
	public final selectedPath:String;
	public final insertText:String;
	public final failureCode:String;
	public final selectedBefore:Int;
	public final selectedAfter:Int;
	public final scrollBefore:Int;
	public final scrollAfter:Int;
	public final matchCount:Int;
	public final selectedAvailable:Bool;
	public final dismissedTokenStored:Bool;
	public final draftUpdated:Bool;
	public final textCleared:Bool;
	public final commandCompleted:Bool;
	public final commandDispatched:Bool;
	public final serviceTierDispatched:Bool;
	public final historyStaged:Bool;
	public final inlineArgsPreserved:Bool;
	public final imagePath:Bool;
	public final imageDimensionsAvailable:Bool;
	public final imageAttached:Bool;
	public final pathInserted:Bool;
	public final mentionBindingStored:Bool;
	public final modeSwitchAllowed:Bool;
	public final fallbackWithoutPopup:Bool;
	public final submitWithoutPopup:Bool;
	public final inputForwarded:Bool;
	public final shortcutOverlayHandled:Bool;
	public final footerModeChanged:Bool;
	public final keyConsumed:Bool;
	public final syncAfterKey:Bool;
	public final redrawRequested:Bool;
	public final liveProbeRejected:Bool;
	public final unsupportedRejected:Bool;

	public function new(fields:TuiSmokeComposerPopupKeyActionFields) {
		this.kind = fields.kind == null ? TuiSmokeComposerPopupKeyActionKind.Unknown : fields.kind;
		this.popupBefore = fields.popupBefore == null ? TuiSmokeComposerPopupKind.Unknown : fields.popupBefore;
		this.popupAfter = fields.popupAfter == null ? TuiSmokeComposerPopupKind.Unknown : fields.popupAfter;
		this.candidateKind = fields.candidateKind == null ? TuiSmokeMentionCandidateKind.Unknown : fields.candidateKind;
		this.searchModeBefore = fields.searchModeBefore == null ? TuiSmokeMentionSearchModeKind.Unknown : fields.searchModeBefore;
		this.searchModeAfter = fields.searchModeAfter == null ? TuiSmokeMentionSearchModeKind.Unknown : fields.searchModeAfter;
		this.keyName = fields.keyName == null ? "" : fields.keyName;
		this.commandName = fields.commandName == null ? "" : fields.commandName;
		this.token = fields.token == null ? "" : fields.token;
		this.selectedPath = fields.selectedPath == null ? "" : fields.selectedPath;
		this.insertText = fields.insertText == null ? "" : fields.insertText;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.selectedBefore = fields.selectedBefore;
		this.selectedAfter = fields.selectedAfter;
		this.scrollBefore = fields.scrollBefore;
		this.scrollAfter = fields.scrollAfter;
		this.matchCount = fields.matchCount;
		this.selectedAvailable = fields.selectedAvailable;
		this.dismissedTokenStored = fields.dismissedTokenStored;
		this.draftUpdated = fields.draftUpdated;
		this.textCleared = fields.textCleared;
		this.commandCompleted = fields.commandCompleted;
		this.commandDispatched = fields.commandDispatched;
		this.serviceTierDispatched = fields.serviceTierDispatched;
		this.historyStaged = fields.historyStaged;
		this.inlineArgsPreserved = fields.inlineArgsPreserved;
		this.imagePath = fields.imagePath;
		this.imageDimensionsAvailable = fields.imageDimensionsAvailable;
		this.imageAttached = fields.imageAttached;
		this.pathInserted = fields.pathInserted;
		this.mentionBindingStored = fields.mentionBindingStored;
		this.modeSwitchAllowed = fields.modeSwitchAllowed;
		this.fallbackWithoutPopup = fields.fallbackWithoutPopup;
		this.submitWithoutPopup = fields.submitWithoutPopup;
		this.inputForwarded = fields.inputForwarded;
		this.shortcutOverlayHandled = fields.shortcutOverlayHandled;
		this.footerModeChanged = fields.footerModeChanged;
		this.keyConsumed = fields.keyConsumed;
		this.syncAfterKey = fields.syncAfterKey;
		this.redrawRequested = fields.redrawRequested;
		this.liveProbeRejected = fields.liveProbeRejected;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

	public function popupTransitionText():String {
		return popupBefore + "->" + popupAfter;
	}

	public function selectionTransitionText():String {
		return selectedBefore + "->" + selectedAfter;
	}

	public function scrollTransitionText():String {
		return scrollBefore + "->" + scrollAfter;
	}

	public function searchModeTransitionText():String {
		return searchModeBefore + "->" + searchModeAfter;
	}
}
