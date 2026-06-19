package codexhx.runtime.tui.smoke;

typedef TuiSmokeHistorySearchActionFields = {
	final kind:TuiSmokeHistorySearchActionKind;
	final direction:TuiSmokeHistorySearchDirectionKind;
	final result:TuiSmokeHistorySearchResultKind;
	final statusBefore:TuiSmokeHistorySearchStatusKind;
	final statusAfter:TuiSmokeHistorySearchStatusKind;
	final keyName:String;
	final inputText:String;
	final queryBefore:String;
	final queryAfter:String;
	final originalDraft:String;
	final previewText:String;
	final acceptedText:String;
	final restoredText:String;
	final footerLine:String;
	final failureCode:String;
	final matchCount:Int;
	final selectedBefore:Int;
	final selectedAfter:Int;
	final persistentOffset:Int;
	final logId:Int;
	final highlightCount:Int;
	final cursorBefore:Int;
	final cursorAfter:Int;
	final activeBefore:Bool;
	final activeAfter:Bool;
	final pasteFlushed:Bool;
	final fileQueryCleared:Bool;
	final popupsCleared:Bool;
	final remoteImageSelectionCleared:Bool;
	final searchReset:Bool;
	final navigationReset:Bool;
	final lookupRequested:Bool;
	final pendingStored:Bool;
	final draftRestored:Bool;
	final draftPreviewed:Bool;
	final draftAccepted:Bool;
	final footerMode:Bool;
	final frameScheduled:Bool;
	final redrawRequested:Bool;
	final keyConsumed:Bool;
	final releaseIgnored:Bool;
	final ctrlCConsumed:Bool;
	final remapped:Bool;
	final fallbackSuppressed:Bool;
	final noLiveLookup:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeHistorySearchAction {
	public final kind:TuiSmokeHistorySearchActionKind;
	public final direction:TuiSmokeHistorySearchDirectionKind;
	public final result:TuiSmokeHistorySearchResultKind;
	public final statusBefore:TuiSmokeHistorySearchStatusKind;
	public final statusAfter:TuiSmokeHistorySearchStatusKind;
	public final keyName:String;
	public final inputText:String;
	public final queryBefore:String;
	public final queryAfter:String;
	public final originalDraft:String;
	public final previewText:String;
	public final acceptedText:String;
	public final restoredText:String;
	public final footerLine:String;
	public final failureCode:String;
	public final matchCount:Int;
	public final selectedBefore:Int;
	public final selectedAfter:Int;
	public final persistentOffset:Int;
	public final logId:Int;
	public final highlightCount:Int;
	public final cursorBefore:Int;
	public final cursorAfter:Int;
	public final activeBefore:Bool;
	public final activeAfter:Bool;
	public final pasteFlushed:Bool;
	public final fileQueryCleared:Bool;
	public final popupsCleared:Bool;
	public final remoteImageSelectionCleared:Bool;
	public final searchReset:Bool;
	public final navigationReset:Bool;
	public final lookupRequested:Bool;
	public final pendingStored:Bool;
	public final draftRestored:Bool;
	public final draftPreviewed:Bool;
	public final draftAccepted:Bool;
	public final footerMode:Bool;
	public final frameScheduled:Bool;
	public final redrawRequested:Bool;
	public final keyConsumed:Bool;
	public final releaseIgnored:Bool;
	public final ctrlCConsumed:Bool;
	public final remapped:Bool;
	public final fallbackSuppressed:Bool;
	public final noLiveLookup:Bool;
	public final unsupportedRejected:Bool;

	public function activeTransitionText():String {
		return activeBefore + "->" + activeAfter;
	}

	public function queryTransitionText():String {
		return queryBefore + "->" + queryAfter;
	}

	public function statusTransitionText():String {
		return statusBefore + "->" + statusAfter;
	}

	public function selectionTransitionText():String {
		return selectedBefore + "->" + selectedAfter;
	}

	public function cursorTransitionText():String {
		return cursorBefore + "->" + cursorAfter;
	}
}
