package codexhx.runtime.tui.smoke;

typedef TuiSmokeSlashPopupActionFields = {
	final kind:TuiSmokeSlashPopupActionKind;
	final commandKind:TuiSmokeSlashPopupCommandKind;
	final matchKind:TuiSmokeSlashPopupMatchKind;
	final completionKind:TuiSmokeSlashPopupCompletionKind;
	final inputText:String;
	final filterText:String;
	final commandName:String;
	final totalCommands:Int;
	final visibleCount:Int;
	final matchedCount:Int;
	final rowCount:Int;
	final hiddenAliasCount:Int;
	final serviceTierCount:Int;
	final disabledCount:Int;
	final selectedBefore:Int;
	final selectedAfter:Int;
	final scrollBefore:Int;
	final scrollAfter:Int;
	final activeBefore:Bool;
	final activeAfter:Bool;
	final popupCreated:Bool;
	final popupDismissed:Bool;
	final textCleared:Bool;
	final draftPreserved:Bool;
	final historyStaged:Bool;
	final historyRecorded:Bool;
	final commandDispatched:Bool;
	final serviceTierDispatched:Bool;
	final currentFileQueryCleared:Bool;
	final frameScheduled:Bool;
	final redrawRequested:Bool;
	final interruptSuppressed:Bool;
	final taskRunning:Bool;
	final unsupportedRejected:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSlashPopupAction {
	public final kind:TuiSmokeSlashPopupActionKind;
	public final commandKind:TuiSmokeSlashPopupCommandKind;
	public final matchKind:TuiSmokeSlashPopupMatchKind;
	public final completionKind:TuiSmokeSlashPopupCompletionKind;
	public final inputText:String;
	public final filterText:String;
	public final commandName:String;
	public final totalCommands:Int;
	public final visibleCount:Int;
	public final matchedCount:Int;
	public final rowCount:Int;
	public final hiddenAliasCount:Int;
	public final serviceTierCount:Int;
	public final disabledCount:Int;
	public final selectedBefore:Int;
	public final selectedAfter:Int;
	public final scrollBefore:Int;
	public final scrollAfter:Int;
	public final activeBefore:Bool;
	public final activeAfter:Bool;
	public final popupCreated:Bool;
	public final popupDismissed:Bool;
	public final textCleared:Bool;
	public final draftPreserved:Bool;
	public final historyStaged:Bool;
	public final historyRecorded:Bool;
	public final commandDispatched:Bool;
	public final serviceTierDispatched:Bool;
	public final currentFileQueryCleared:Bool;
	public final frameScheduled:Bool;
	public final redrawRequested:Bool;
	public final interruptSuppressed:Bool;
	public final taskRunning:Bool;
	public final unsupportedRejected:Bool;
	public final failureCode:String;


	public function activeTransitionText():String {
		return activeBefore + "->" + activeAfter;
	}

	public function selectionTransitionText():String {
		return selectedBefore + "->" + selectedAfter;
	}

	public function scrollTransitionText():String {
		return scrollBefore + "->" + scrollAfter;
	}
}
