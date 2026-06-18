package codexhx.runtime.tui.smoke;

typedef TuiSmokeResizeDrawActionFields = {
	final terminalWidth:Int;
	final terminalHeight:Int;
	final lastWidth:Int;
	final lastHeight:Int;
	final resizeReflowEnabled:Bool;
	final scheduleAccepted:Bool;
	final pendingReflow:Bool;
	final pendingDue:Bool;
	final overlayActive:Bool;
	final transcriptCells:Bool;
	final remainingMs:Int;
	final runReflow:Bool;
	final streamTime:Bool;
	final followUpDraw:Bool;
	final repaint:Null<TuiSmokeResizeRepaintPlan>;
	final viewport:Null<TuiSmokeViewportResizePlan>;
}

class TuiSmokeResizeDrawAction {
	public final terminalWidth:Int;
	public final terminalHeight:Int;
	public final lastWidth:Int;
	public final lastHeight:Int;
	public final resizeReflowEnabled:Bool;
	public final scheduleAccepted:Bool;
	public final pendingReflow:Bool;
	public final pendingDue:Bool;
	public final overlayActive:Bool;
	public final transcriptCells:Bool;
	public final remainingMs:Int;
	public final runReflow:Bool;
	public final streamTime:Bool;
	public final followUpDraw:Bool;
	public final repaint:Null<TuiSmokeResizeRepaintPlan>;
	public final viewport:Null<TuiSmokeViewportResizePlan>;

	public function new(fields:TuiSmokeResizeDrawActionFields) {
		this.terminalWidth = fields.terminalWidth;
		this.terminalHeight = fields.terminalHeight;
		this.lastWidth = fields.lastWidth;
		this.lastHeight = fields.lastHeight;
		this.resizeReflowEnabled = fields.resizeReflowEnabled;
		this.scheduleAccepted = fields.scheduleAccepted;
		this.pendingReflow = fields.pendingReflow;
		this.pendingDue = fields.pendingDue;
		this.overlayActive = fields.overlayActive;
		this.transcriptCells = fields.transcriptCells;
		this.remainingMs = fields.remainingMs;
		this.runReflow = fields.runReflow;
		this.streamTime = fields.streamTime;
		this.followUpDraw = fields.followUpDraw;
		this.repaint = fields.repaint;
		this.viewport = fields.viewport;
	}

	public function sizeText():String {
		return sizeLabel(terminalWidth, terminalHeight);
	}

	public function lastSizeText():String {
		return sizeLabel(lastWidth, lastHeight);
	}

	public function widthState():String {
		if (terminalWidth <= 0) return "unknown";
		if (lastWidth <= 0) return "initialized";
		return terminalWidth == lastWidth ? "unchanged" : "changed";
	}

	public function heightChanged():Bool {
		return terminalHeight > 0 && lastHeight > 0 && terminalHeight != lastHeight;
	}

	public function widthChanged():Bool {
		return terminalWidth > 0 && lastWidth > 0 && terminalWidth != lastWidth;
	}

	public function shouldRebuildTranscript():Bool {
		return resizeReflowEnabled && (widthChanged() || heightChanged());
	}

	public function targetWidthText():String {
		return widthChanged() ? Std.string(terminalWidth) : "none";
	}

	static function sizeLabel(width:Int, height:Int):String {
		if (width <= 0 || height <= 0) return "unknown";
		return Std.string(width) + "x" + Std.string(height);
	}
}
