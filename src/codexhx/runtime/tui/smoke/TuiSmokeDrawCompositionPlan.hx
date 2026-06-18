package codexhx.runtime.tui.smoke;

typedef TuiSmokeDrawCompositionPlanFields = {
	final allowLiveDraw:Bool;
	final mode:TuiSmokeDrawCompositionMode;
	final height:Int;
	final terminalWidth:Int;
	final terminalHeight:Int;
	final lastWidth:Int;
	final lastHeight:Int;
	final ensureVirtualTerminalProcessing:Bool;
	final syncUpdate:Bool;
	final preparedResume:Bool;
	final pendingViewportComputed:Bool;
	final cursorMoved:Bool;
	final lastCursorY:Int;
	final cursorY:Int;
	final previousViewportX:Int;
	final previousViewportY:Int;
	final previousViewportWidth:Int;
	final previousViewportHeight:Int;
	final pendingViewportX:Int;
	final pendingViewportY:Int;
	final pendingViewportWidth:Int;
	final pendingViewportHeight:Int;
	final appliedViewportX:Int;
	final appliedViewportY:Int;
	final appliedViewportWidth:Int;
	final appliedViewportHeight:Int;
	final clearForViewportChange:Bool;
	final terminalClear:Bool;
	final scrollRegionUp:Bool;
	final scrollRegionStart:Int;
	final scrollRegionEnd:Int;
	final scrollBy:Int;
	final pendingHistoryBatches:Int;
	final pendingHistoryRows:Int;
	final zellijRaw:Bool;
	final wrapPolicy:TuiSmokeHistoryWrapPolicy;
	final suspendCursorY:Int;
	final altScreenActive:Bool;
	final needsFullRepaint:Bool;
	final invalidateViewport:Bool;
	final renderCallback:Bool;
	final autoresize:Bool;
	final diffPutCount:Int;
	final diffClearToEndCount:Int;
	final cursorSet:Bool;
	final cursorX:Int;
	final cursorPositionY:Int;
	final cursorStyle:String;
	final swapBuffers:Bool;
	final backendFlush:Bool;
	final failureCode:String;
}

class TuiSmokeDrawCompositionPlan {
	public final allowLiveDraw:Bool;
	public final mode:TuiSmokeDrawCompositionMode;
	public final height:Int;
	public final terminalWidth:Int;
	public final terminalHeight:Int;
	public final lastWidth:Int;
	public final lastHeight:Int;
	public final ensureVirtualTerminalProcessing:Bool;
	public final syncUpdate:Bool;
	public final preparedResume:Bool;
	public final pendingViewportComputed:Bool;
	public final cursorMoved:Bool;
	public final lastCursorY:Int;
	public final cursorY:Int;
	public final previousViewportX:Int;
	public final previousViewportY:Int;
	public final previousViewportWidth:Int;
	public final previousViewportHeight:Int;
	public final pendingViewportX:Int;
	public final pendingViewportY:Int;
	public final pendingViewportWidth:Int;
	public final pendingViewportHeight:Int;
	public final appliedViewportX:Int;
	public final appliedViewportY:Int;
	public final appliedViewportWidth:Int;
	public final appliedViewportHeight:Int;
	public final clearForViewportChange:Bool;
	public final terminalClear:Bool;
	public final scrollRegionUp:Bool;
	public final scrollRegionStart:Int;
	public final scrollRegionEnd:Int;
	public final scrollBy:Int;
	public final pendingHistoryBatches:Int;
	public final pendingHistoryRows:Int;
	public final zellijRaw:Bool;
	public final wrapPolicy:TuiSmokeHistoryWrapPolicy;
	public final suspendCursorY:Int;
	public final altScreenActive:Bool;
	public final needsFullRepaint:Bool;
	public final invalidateViewport:Bool;
	public final renderCallback:Bool;
	public final autoresize:Bool;
	public final diffPutCount:Int;
	public final diffClearToEndCount:Int;
	public final cursorSet:Bool;
	public final cursorX:Int;
	public final cursorPositionY:Int;
	public final cursorStyle:String;
	public final swapBuffers:Bool;
	public final backendFlush:Bool;
	public final failureCode:String;

	public function new(fields:TuiSmokeDrawCompositionPlanFields) {
		this.allowLiveDraw = fields.allowLiveDraw;
		this.mode = fields.mode == null ? TuiSmokeDrawCompositionMode.Unknown : fields.mode;
		this.height = fields.height;
		this.terminalWidth = fields.terminalWidth;
		this.terminalHeight = fields.terminalHeight;
		this.lastWidth = fields.lastWidth;
		this.lastHeight = fields.lastHeight;
		this.ensureVirtualTerminalProcessing = fields.ensureVirtualTerminalProcessing;
		this.syncUpdate = fields.syncUpdate;
		this.preparedResume = fields.preparedResume;
		this.pendingViewportComputed = fields.pendingViewportComputed;
		this.cursorMoved = fields.cursorMoved;
		this.lastCursorY = fields.lastCursorY;
		this.cursorY = fields.cursorY;
		this.previousViewportX = fields.previousViewportX;
		this.previousViewportY = fields.previousViewportY;
		this.previousViewportWidth = fields.previousViewportWidth;
		this.previousViewportHeight = fields.previousViewportHeight;
		this.pendingViewportX = fields.pendingViewportX;
		this.pendingViewportY = fields.pendingViewportY;
		this.pendingViewportWidth = fields.pendingViewportWidth;
		this.pendingViewportHeight = fields.pendingViewportHeight;
		this.appliedViewportX = fields.appliedViewportX;
		this.appliedViewportY = fields.appliedViewportY;
		this.appliedViewportWidth = fields.appliedViewportWidth;
		this.appliedViewportHeight = fields.appliedViewportHeight;
		this.clearForViewportChange = fields.clearForViewportChange;
		this.terminalClear = fields.terminalClear;
		this.scrollRegionUp = fields.scrollRegionUp;
		this.scrollRegionStart = fields.scrollRegionStart;
		this.scrollRegionEnd = fields.scrollRegionEnd;
		this.scrollBy = fields.scrollBy;
		this.pendingHistoryBatches = fields.pendingHistoryBatches;
		this.pendingHistoryRows = fields.pendingHistoryRows;
		this.zellijRaw = fields.zellijRaw;
		this.wrapPolicy = fields.wrapPolicy == null ? TuiSmokeHistoryWrapPolicy.Unknown : fields.wrapPolicy;
		this.suspendCursorY = fields.suspendCursorY;
		this.altScreenActive = fields.altScreenActive;
		this.needsFullRepaint = fields.needsFullRepaint;
		this.invalidateViewport = fields.invalidateViewport;
		this.renderCallback = fields.renderCallback;
		this.autoresize = fields.autoresize;
		this.diffPutCount = fields.diffPutCount;
		this.diffClearToEndCount = fields.diffClearToEndCount;
		this.cursorSet = fields.cursorSet;
		this.cursorX = fields.cursorX;
		this.cursorPositionY = fields.cursorPositionY;
		this.cursorStyle = fields.cursorStyle == null ? "default" : fields.cursorStyle;
		this.swapBuffers = fields.swapBuffers;
		this.backendFlush = fields.backendFlush;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
	}

	public function enabled():Bool {
		return !allowLiveDraw && mode != TuiSmokeDrawCompositionMode.Unknown;
	}

	public function terminalSizeText():String {
		return sizeText(terminalWidth, terminalHeight);
	}

	public function lastSizeText():String {
		return sizeText(lastWidth, lastHeight);
	}

	public function previousViewportText():String {
		return areaText(previousViewportX, previousViewportY, previousViewportWidth, previousViewportHeight);
	}

	public function pendingViewportText():String {
		return areaText(pendingViewportX, pendingViewportY, pendingViewportWidth, pendingViewportHeight);
	}

	public function appliedViewportText():String {
		return areaText(appliedViewportX, appliedViewportY, appliedViewportWidth, appliedViewportHeight);
	}

	public function historyInsertMode():String {
		return zellijRaw && wrapPolicy == TuiSmokeHistoryWrapPolicy.Terminal ? "zellij_raw" : "standard";
	}

	public function scrollRegionText():String {
		return scrollRegionStart + ".." + scrollRegionEnd;
	}

	public function cursorText():String {
		return cursorSet ? cursorX + "," + cursorPositionY + ":" + cursorStyle : "hidden";
	}

	static function sizeText(width:Int, height:Int):String {
		if (width <= 0 || height <= 0) return "unknown";
		return width + "x" + height;
	}

	static function areaText(x:Int, y:Int, width:Int, height:Int):String {
		return x + "," + y + " " + width + "x" + height;
	}
}
