package codexhx.runtime.tui.terminal;

/**
	Coalesces terminal resize and redraw requests before backend mutation.

	The scheduler owns only frame-timing state. Rendering remains the caller's
	responsibility, which keeps this reducer shared by live and headless
	backends and avoids coupling it to a fixture trace format.
**/
class TerminalRedrawScheduler {
	var size:TerminalSize;
	var pendingResize:Bool;
	var drawPending:Bool;
	var exitRequestedValue:Bool;
	var exitReasonValue:TerminalExitReason;
	var resizeEventCountValue:Int;
	var resizeApplyCountValue:Int;
	var drawRequestCountValue:Int;
	var drawApplyCountValue:Int;
	var tickCountValue:Int;

	public function new(initialSize:TerminalSize) {
		this.size = sanitizeSize(initialSize);
		this.pendingResize = false;
		this.drawPending = false;
		this.exitRequestedValue = false;
		this.exitReasonValue = TerminalExitReason.Requested;
		this.resizeEventCountValue = 0;
		this.resizeApplyCountValue = 0;
		this.drawRequestCountValue = 0;
		this.drawApplyCountValue = 0;
		this.tickCountValue = 0;
	}

	public function handle(event:TerminalSchedulerEvent):Array<TerminalSchedulerEffect> {
		return switch event {
			case Resize(nextSize):
				handleResize(nextSize);
			case DrawRequested:
				handleDrawRequest();
			case Tick:
				handleTick();
			case AppExit(reason):
				handleExit(reason);
		}
	}

	public function flush(frame:TerminalFrame):Array<TerminalSchedulerEffect> {
		final effects:Array<TerminalSchedulerEffect> = [];
		if (exitRequestedValue || frame == null || frame.size == null || !frame.size.valid())
			return effects;
		if (!pendingResize && !drawPending)
			return effects;
		if (pendingResize) {
			effects.push(ResizeBackend(size));
			pendingResize = false;
			resizeApplyCountValue = resizeApplyCountValue + 1;
		}
		if (drawPending) {
			effects.push(DrawFrame(frame));
			drawPending = false;
			drawApplyCountValue = drawApplyCountValue + 1;
		}
		return effects;
	}

	public function currentSize():TerminalSize {
		return size;
	}

	public function hasPendingResize():Bool {
		return pendingResize;
	}

	public function hasPendingDraw():Bool {
		return drawPending;
	}

	public function exitRequested():Bool {
		return exitRequestedValue;
	}

	public function exitReason():TerminalExitReason {
		return exitReasonValue;
	}

	public function resizeEventCount():Int {
		return resizeEventCountValue;
	}

	public function resizeApplyCount():Int {
		return resizeApplyCountValue;
	}

	public function drawRequestCount():Int {
		return drawRequestCountValue;
	}

	public function drawApplyCount():Int {
		return drawApplyCountValue;
	}

	public function tickCount():Int {
		return tickCountValue;
	}

	function handleResize(nextSize:TerminalSize):Array<TerminalSchedulerEffect> {
		if (exitRequestedValue || nextSize == null || !nextSize.valid())
			return [];
		size = nextSize;
		pendingResize = true;
		drawPending = true;
		resizeEventCountValue = resizeEventCountValue + 1;
		return [];
	}

	function handleDrawRequest():Array<TerminalSchedulerEffect> {
		if (exitRequestedValue)
			return [];
		drawPending = true;
		drawRequestCountValue = drawRequestCountValue + 1;
		return [];
	}

	function handleTick():Array<TerminalSchedulerEffect> {
		if (exitRequestedValue)
			return [];
		tickCountValue = tickCountValue + 1;
		drawPending = true;
		return [];
	}

	function handleExit(reason:TerminalExitReason):Array<TerminalSchedulerEffect> {
		exitRequestedValue = true;
		exitReasonValue = reason;
		pendingResize = false;
		drawPending = false;
		return [RequestExit(exitReasonValue)];
	}

	static function sanitizeSize(value:TerminalSize):TerminalSize {
		if (value == null || !value.valid())
			return TerminalSize.of(80, 24);
		return value;
	}
}
