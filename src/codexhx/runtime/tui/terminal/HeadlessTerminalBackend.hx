package codexhx.runtime.tui.terminal;

/**
	CI-safe terminal backend that exercises the production terminal contract
	without taking over a real terminal.
**/
class HeadlessTerminalBackend implements TerminalBackend {
	final events:Array<TerminalEvent>;
	var eventIndex:Int;
	var active:Bool;
	var restored:Bool;
	var lastSetup:TerminalSetup;
	var lastFrame:TerminalFrame;
	var lastSize:TerminalSize;
	var requestedExit:Bool;
	var exitReason:TerminalExitReason;
	var setupCountValue:Int;
	var drawCountValue:Int;
	var resizeCountValue:Int;
	var exitCountValue:Int;
	var restoreCountValue:Int;

	public function new(events:Array<TerminalEvent>) {
		this.events = events == null ? [] : events.copy();
		this.eventIndex = 0;
		this.active = false;
		this.restored = false;
		this.lastSize = TerminalSize.of(80, 24);
		this.lastSetup = TerminalSetup.headless(lastSize);
		this.lastFrame = TerminalFrame.empty(lastSize);
		this.requestedExit = false;
		this.exitReason = TerminalExitReason.Requested;
		this.setupCountValue = 0;
		this.drawCountValue = 0;
		this.resizeCountValue = 0;
		this.exitCountValue = 0;
		this.restoreCountValue = 0;
	}

	public function setup(request:TerminalSetup):TerminalOperation {
		if (active)
			return TerminalOperation.alreadyActive("terminal backend is already active");
		if (request == null)
			return TerminalOperation.rejected("missing terminal setup request");
		if (request.mode != TerminalMode.Headless)
			return TerminalOperation.rejected("headless backend cannot start live terminal mode");
		if (request.size == null || !request.size.valid())
			return TerminalOperation.rejected("terminal size must be positive");
		active = true;
		restored = false;
		requestedExit = false;
		lastSetup = request;
		lastSize = request.size;
		setupCountValue = setupCountValue + 1;
		return TerminalOperation.accepted(TerminalOperationKind.SetupComplete, "headless terminal setup complete");
	}

	public function draw(frame:TerminalFrame):TerminalOperation {
		if (!active)
			return TerminalOperation.inactive("terminal backend is not active");
		if (frame == null)
			return TerminalOperation.rejected("missing terminal frame");
		if (frame.size == null || !frame.size.valid())
			return TerminalOperation.rejected("terminal frame size must be positive");
		lastFrame = frame;
		drawCountValue = drawCountValue + 1;
		return TerminalOperation.accepted(TerminalOperationKind.DrawComplete, "headless frame recorded");
	}

	public function pollEvent():TerminalEvent {
		if (!active)
			return TerminalEvent.NoEvent;
		if (eventIndex >= events.length)
			return TerminalEvent.NoEvent;
		final event = events[eventIndex];
		eventIndex = eventIndex + 1;
		return event;
	}

	public function resize(size:TerminalSize):TerminalOperation {
		if (!active)
			return TerminalOperation.inactive("terminal backend is not active");
		if (size == null || !size.valid())
			return TerminalOperation.rejected("terminal size must be positive");
		lastSize = size;
		resizeCountValue = resizeCountValue + 1;
		return TerminalOperation.accepted(TerminalOperationKind.ResizeComplete, "headless terminal size updated");
	}

	public function requestExit(reason:TerminalExitReason):TerminalOperation {
		if (!active)
			return TerminalOperation.inactive("terminal backend is not active");
		requestedExit = true;
		exitReason = reason;
		exitCountValue = exitCountValue + 1;
		return TerminalOperation.accepted(TerminalOperationKind.ExitRequested, "terminal exit requested");
	}

	public function restore(reason:TerminalRestoreReason):TerminalRestoreReport {
		final wasActive = active;
		active = false;
		restored = true;
		restoreCountValue = restoreCountValue + 1;
		return new TerminalRestoreReport(true, wasActive, reason, restoreCountValue, "headless terminal restored");
	}

	public function isActive():Bool {
		return active;
	}

	public function wasRestored():Bool {
		return restored;
	}

	public function setupCount():Int {
		return setupCountValue;
	}

	public function drawCount():Int {
		return drawCountValue;
	}

	public function resizeCount():Int {
		return resizeCountValue;
	}

	public function exitCount():Int {
		return exitCountValue;
	}

	public function restoreCount():Int {
		return restoreCountValue;
	}

	public function currentSize():TerminalSize {
		return lastSize;
	}

	public function currentSetup():TerminalSetup {
		return lastSetup;
	}

	public function currentFrame():TerminalFrame {
		return lastFrame;
	}

	public function exitWasRequested():Bool {
		return requestedExit;
	}

	public function requestedExitReason():TerminalExitReason {
		return exitReason;
	}
}
