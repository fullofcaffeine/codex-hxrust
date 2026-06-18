package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerAttachmentActionFields = {
	final kind:TuiSmokeComposerAttachmentActionKind;
	final pasteKind:TuiSmokeComposerPasteKind;
	final attachmentKind:TuiSmokeComposerAttachmentKind;
	final burstBefore:TuiSmokeComposerPasteBurstStateKind;
	final burstAfter:TuiSmokeComposerPasteBurstStateKind;
	final inputText:String;
	final normalizedText:String;
	final placeholder:String;
	final path:String;
	final remoteUrl:String;
	final keyName:String;
	final failureCode:String;
	final charCount:Int;
	final threshold:Int;
	final pendingBefore:Int;
	final pendingAfter:Int;
	final textElementBefore:Int;
	final textElementAfter:Int;
	final localImageBefore:Int;
	final localImageAfter:Int;
	final remoteImageBefore:Int;
	final remoteImageAfter:Int;
	final selectedRemoteBefore:Int;
	final selectedRemoteAfter:Int;
	final cursorBefore:Int;
	final cursorAfter:Int;
	final needsRedraw:Bool;
	final frameScheduled:Bool;
	final pasteBurstDisabled:Bool;
	final buffered:Bool;
	final flushed:Bool;
	final newlineCaptured:Bool;
	final placeholderInserted:Bool;
	final pendingStored:Bool;
	final pendingExpanded:Bool;
	final pendingCleared:Bool;
	final imagePasteEnabled:Bool;
	final imageDimensionsChecked:Bool;
	final imageAttached:Bool;
	final pathInsertedFallback:Bool;
	final textInserted:Bool;
	final selectionCleared:Bool;
	final remoteRelabeledLocals:Bool;
	final draftSnapshotStored:Bool;
	final draftRestored:Bool;
	final historyEntryApplied:Bool;
	final submissionSuppressed:Bool;
	final submissionPrepared:Bool;
	final localImagesPruned:Bool;
	final remoteImagesTaken:Bool;
	final noLiveFilesystem:Bool;
	final unsupportedRejected:Bool;
}

class TuiSmokeComposerAttachmentAction {
	public final kind:TuiSmokeComposerAttachmentActionKind;
	public final pasteKind:TuiSmokeComposerPasteKind;
	public final attachmentKind:TuiSmokeComposerAttachmentKind;
	public final burstBefore:TuiSmokeComposerPasteBurstStateKind;
	public final burstAfter:TuiSmokeComposerPasteBurstStateKind;
	public final inputText:String;
	public final normalizedText:String;
	public final placeholder:String;
	public final path:String;
	public final remoteUrl:String;
	public final keyName:String;
	public final failureCode:String;
	public final charCount:Int;
	public final threshold:Int;
	public final pendingBefore:Int;
	public final pendingAfter:Int;
	public final textElementBefore:Int;
	public final textElementAfter:Int;
	public final localImageBefore:Int;
	public final localImageAfter:Int;
	public final remoteImageBefore:Int;
	public final remoteImageAfter:Int;
	public final selectedRemoteBefore:Int;
	public final selectedRemoteAfter:Int;
	public final cursorBefore:Int;
	public final cursorAfter:Int;
	public final needsRedraw:Bool;
	public final frameScheduled:Bool;
	public final pasteBurstDisabled:Bool;
	public final buffered:Bool;
	public final flushed:Bool;
	public final newlineCaptured:Bool;
	public final placeholderInserted:Bool;
	public final pendingStored:Bool;
	public final pendingExpanded:Bool;
	public final pendingCleared:Bool;
	public final imagePasteEnabled:Bool;
	public final imageDimensionsChecked:Bool;
	public final imageAttached:Bool;
	public final pathInsertedFallback:Bool;
	public final textInserted:Bool;
	public final selectionCleared:Bool;
	public final remoteRelabeledLocals:Bool;
	public final draftSnapshotStored:Bool;
	public final draftRestored:Bool;
	public final historyEntryApplied:Bool;
	public final submissionSuppressed:Bool;
	public final submissionPrepared:Bool;
	public final localImagesPruned:Bool;
	public final remoteImagesTaken:Bool;
	public final noLiveFilesystem:Bool;
	public final unsupportedRejected:Bool;

	public function new(fields:TuiSmokeComposerAttachmentActionFields) {
		this.kind = fields.kind == null ? TuiSmokeComposerAttachmentActionKind.Unknown : fields.kind;
		this.pasteKind = fields.pasteKind == null ? TuiSmokeComposerPasteKind.Unknown : fields.pasteKind;
		this.attachmentKind = fields.attachmentKind == null ? TuiSmokeComposerAttachmentKind.Unknown : fields.attachmentKind;
		this.burstBefore = fields.burstBefore == null ? TuiSmokeComposerPasteBurstStateKind.Unknown : fields.burstBefore;
		this.burstAfter = fields.burstAfter == null ? TuiSmokeComposerPasteBurstStateKind.Unknown : fields.burstAfter;
		this.inputText = fields.inputText == null ? "" : fields.inputText;
		this.normalizedText = fields.normalizedText == null ? "" : fields.normalizedText;
		this.placeholder = fields.placeholder == null ? "" : fields.placeholder;
		this.path = fields.path == null ? "" : fields.path;
		this.remoteUrl = fields.remoteUrl == null ? "" : fields.remoteUrl;
		this.keyName = fields.keyName == null ? "" : fields.keyName;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.charCount = fields.charCount;
		this.threshold = fields.threshold;
		this.pendingBefore = fields.pendingBefore;
		this.pendingAfter = fields.pendingAfter;
		this.textElementBefore = fields.textElementBefore;
		this.textElementAfter = fields.textElementAfter;
		this.localImageBefore = fields.localImageBefore;
		this.localImageAfter = fields.localImageAfter;
		this.remoteImageBefore = fields.remoteImageBefore;
		this.remoteImageAfter = fields.remoteImageAfter;
		this.selectedRemoteBefore = fields.selectedRemoteBefore;
		this.selectedRemoteAfter = fields.selectedRemoteAfter;
		this.cursorBefore = fields.cursorBefore;
		this.cursorAfter = fields.cursorAfter;
		this.needsRedraw = fields.needsRedraw;
		this.frameScheduled = fields.frameScheduled;
		this.pasteBurstDisabled = fields.pasteBurstDisabled;
		this.buffered = fields.buffered;
		this.flushed = fields.flushed;
		this.newlineCaptured = fields.newlineCaptured;
		this.placeholderInserted = fields.placeholderInserted;
		this.pendingStored = fields.pendingStored;
		this.pendingExpanded = fields.pendingExpanded;
		this.pendingCleared = fields.pendingCleared;
		this.imagePasteEnabled = fields.imagePasteEnabled;
		this.imageDimensionsChecked = fields.imageDimensionsChecked;
		this.imageAttached = fields.imageAttached;
		this.pathInsertedFallback = fields.pathInsertedFallback;
		this.textInserted = fields.textInserted;
		this.selectionCleared = fields.selectionCleared;
		this.remoteRelabeledLocals = fields.remoteRelabeledLocals;
		this.draftSnapshotStored = fields.draftSnapshotStored;
		this.draftRestored = fields.draftRestored;
		this.historyEntryApplied = fields.historyEntryApplied;
		this.submissionSuppressed = fields.submissionSuppressed;
		this.submissionPrepared = fields.submissionPrepared;
		this.localImagesPruned = fields.localImagesPruned;
		this.remoteImagesTaken = fields.remoteImagesTaken;
		this.noLiveFilesystem = fields.noLiveFilesystem;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

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

	public function selectedRemoteTransitionText():String {
		return selectedRemoteBefore + "->" + selectedRemoteAfter;
	}

	public function cursorTransitionText():String {
		return cursorBefore + "->" + cursorAfter;
	}
}
