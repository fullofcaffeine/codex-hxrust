package codexhx.runtime.tui.smoke;

typedef TuiSmokeOverlayRoutingActionFields = {
	final kind:TuiSmokeOverlayRoutingActionKind;
	final overlay:TuiSmokeOverlayKind;
	final title:String;
	final keyAction:TuiSmokeOverlayKeyActionKind;
	final committedCellsBefore:Int;
	final committedCellsAfter:Int;
	final insertedCells:Int;
	final lineCount:Int;
	final consolidateStart:Int;
	final consolidateEnd:Int;
	final liveTailWidth:Int;
	final liveTailRevision:Int;
	final liveTailContinuation:Bool;
	final liveTailAnimationTick:Int;
	final liveTailKeyChanged:Bool;
	final liveTailComputed:Bool;
	final liveTailLines:Int;
	final pinnedBefore:Bool;
	final pinnedAfter:Bool;
	final scrollBefore:Int;
	final scrollAfter:Int;
	final drawHeight:Int;
	final renderedWidth:Int;
	final renderedHeight:Int;
	final ownsTerminal:Bool;
	final doneBefore:Bool;
	final doneAfter:Bool;
	final enterAltScreen:Bool;
	final leaveAltScreen:Bool;
	final frameScheduled:Bool;
	final deferredHistoryLines:Int;
	final backtrackPreviewActiveBefore:Bool;
	final backtrackPreviewActiveAfter:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeOverlayRoutingAction {
	public final kind:TuiSmokeOverlayRoutingActionKind;
	public final overlay:TuiSmokeOverlayKind;
	public final title:String;
	public final keyAction:TuiSmokeOverlayKeyActionKind;
	public final committedCellsBefore:Int;
	public final committedCellsAfter:Int;
	public final insertedCells:Int;
	public final lineCount:Int;
	public final consolidateStart:Int;
	public final consolidateEnd:Int;
	public final liveTailWidth:Int;
	public final liveTailRevision:Int;
	public final liveTailContinuation:Bool;
	public final liveTailAnimationTick:Int;
	public final liveTailKeyChanged:Bool;
	public final liveTailComputed:Bool;
	public final liveTailLines:Int;
	public final pinnedBefore:Bool;
	public final pinnedAfter:Bool;
	public final scrollBefore:Int;
	public final scrollAfter:Int;
	public final drawHeight:Int;
	public final renderedWidth:Int;
	public final renderedHeight:Int;
	public final ownsTerminal:Bool;
	public final doneBefore:Bool;
	public final doneAfter:Bool;
	public final enterAltScreen:Bool;
	public final leaveAltScreen:Bool;
	public final frameScheduled:Bool;
	public final deferredHistoryLines:Int;
	public final backtrackPreviewActiveBefore:Bool;
	public final backtrackPreviewActiveAfter:Bool;
	public final failureCode:String;


	public function cellTransitionText():String {
		return committedCellsBefore + "->" + committedCellsAfter;
	}

	public function scrollTransitionText():String {
		return scrollBefore + "->" + scrollAfter;
	}

	public function pinnedTransitionText():String {
		return pinnedBefore + "->" + pinnedAfter;
	}

	public function drawHeightText():String {
		return drawHeight == 65535 ? "u16_max" : Std.string(drawHeight);
	}

	public function renderedAreaText():String {
		if (renderedWidth <= 0 || renderedHeight <= 0) return "none";
		return renderedWidth + "x" + renderedHeight;
	}

	public function liveTailTickText():String {
		return liveTailAnimationTick < 0 ? "none" : Std.string(liveTailAnimationTick);
	}

	public function backtrackPreviewText():String {
		return backtrackPreviewActiveBefore + "->" + backtrackPreviewActiveAfter;
	}
}
