package codexhx.runtime.tui.terminal;

#if reflaxe_rust_profile
import codexhx.native.terminal.NativeLiveTerminalProbe;
#end

/**
	Live terminal backend for the first generated Codex TUI shell gate.

	Why
	- The port needs an actual terminal ownership path before more smoke-only
	  behavior can say much about a runnable TUI.

	What
	- Implements `TerminalBackend` with a crossterm/ratatui native boundary in
	  generated Rust builds.
	- Keeps interpreter execution deterministic by simulating the CI no-TTY
	  fallback while preserving the same typed operation/report surface.

	How
	- `setup` asks the native probe to enter raw mode and alternate screen when
	  stdin/stdout are TTYs. In CI, the native probe returns `SkippedNoTty`.
	- `draw` renders one minimal frame through ratatui when live, or records the
	  frame in fallback mode.
	- `pollEvent` maps live crossterm key facts into typed `TerminalEvent.Key`
	  values for the minimal input backend.
	- `restore` must be called by normal and error paths; it always produces a
	  `TerminalRestoreReport` and exposes the latest native report for tests.
**/
class LiveTerminalBackend implements TerminalBackend {
	var active:Bool;
	var restored:Bool;
	var lastSetup:TerminalSetup;
	var lastFrame:TerminalFrame;
	var lastSize:TerminalSize;
	var requestedExit:Bool;
	var exitReason:TerminalExitReason;
	var setupCountValue:Int;
	var drawCountValue:Int;
	var exitCountValue:Int;
	var restoreCountValue:Int;
	var pollTimeoutMsValue:Int;
	var report:LiveTerminalProbeReport;

	public function new(?pollTimeoutMs:Int) {
		this.active = false;
		this.restored = false;
		this.lastSize = TerminalSize.of(80, 24);
		this.lastSetup = TerminalSetup.live(lastSize);
		this.lastFrame = TerminalFrame.empty(lastSize);
		this.requestedExit = false;
		this.exitReason = TerminalExitReason.Requested;
		this.setupCountValue = 0;
		this.drawCountValue = 0;
		this.exitCountValue = 0;
		this.restoreCountValue = 0;
		this.pollTimeoutMsValue = sanitizePollTimeout(pollTimeoutMs);
		this.report = simulatedReport(LiveTerminalProbeStatus.Inactive, false, false, false, false, false, false, "live terminal inactive");
	}

	public function setup(request:TerminalSetup):TerminalOperation {
		if (active)
			return TerminalOperation.alreadyActive("live terminal backend is already active");
		if (request == null)
			return TerminalOperation.rejected("missing live terminal setup request");
		if (request.mode != TerminalMode.Live)
			return TerminalOperation.rejected("live terminal backend requires live setup mode");
		if (request.size == null || !request.size.valid())
			return TerminalOperation.rejected("terminal size must be positive");

		setupCountValue = setupCountValue + 1;
		lastSetup = request;
		lastSize = request.size;
		restored = false;
		requestedExit = false;
		report = setupNative(request.size);
		if (!report.okForCi()) {
			active = false;
			return TerminalOperation.rejected("live terminal setup failed: " + report.summary());
		}
		active = true;
		return TerminalOperation.accepted(TerminalOperationKind.SetupComplete, "live terminal setup accepted: " + report.status.text());
	}

	public function draw(frame:TerminalFrame):TerminalOperation {
		if (!active)
			return TerminalOperation.inactive("live terminal backend is not active");
		if (frame == null)
			return TerminalOperation.rejected("missing terminal frame");
		if (frame.size == null || !frame.size.valid())
			return TerminalOperation.rejected("terminal frame size must be positive");

		drawCountValue = drawCountValue + 1;
		lastFrame = frame;
		lastSize = frame.size;
		report = drawNative(frame);
		if (!report.okForCi())
			return TerminalOperation.rejected("live terminal draw failed: " + report.summary());
		return TerminalOperation.accepted(TerminalOperationKind.DrawComplete, "live terminal frame accepted: " + report.status.text());
	}

	public function pollEvent():TerminalEvent {
		if (!active)
			return TerminalEvent.NoEvent;
		return pollNativeEvent();
	}

	public function withPollTimeoutMs(timeoutMs:Int):LiveTerminalBackend {
		pollTimeoutMsValue = sanitizePollTimeout(timeoutMs);
		return this;
	}

	public function resize(size:TerminalSize):TerminalOperation {
		if (!active)
			return TerminalOperation.inactive("live terminal backend is not active");
		if (size == null || !size.valid())
			return TerminalOperation.rejected("terminal size must be positive");
		lastSize = size;
		return TerminalOperation.accepted(TerminalOperationKind.ResizeComplete, "live terminal size recorded");
	}

	public function requestExit(reason:TerminalExitReason):TerminalOperation {
		if (!active)
			return TerminalOperation.inactive("live terminal backend is not active");
		requestedExit = true;
		exitReason = reason;
		exitCountValue = exitCountValue + 1;
		report = requestNativeExit(reason);
		if (!report.okForCi())
			return TerminalOperation.rejected("live terminal exit request failed: " + report.summary());
		return TerminalOperation.accepted(TerminalOperationKind.ExitRequested, "live terminal exit requested");
	}

	public function restore(reason:TerminalRestoreReason):TerminalRestoreReport {
		final wasActive = active;
		restoreCountValue = restoreCountValue + 1;
		report = restoreNative(reason);
		active = false;
		restored = report.restored || report.status.restored();
		return new TerminalRestoreReport(restored, wasActive, reason, restoreCountValue, report.summary());
	}

	public function isActive():Bool {
		return active;
	}

	public function wasRestored():Bool {
		return restored;
	}

	public function currentFrame():TerminalFrame {
		return lastFrame;
	}

	public function currentSize():TerminalSize {
		return lastSize;
	}

	public function exitWasRequested():Bool {
		return requestedExit;
	}

	public function requestedExitReason():TerminalExitReason {
		return exitReason;
	}

	public function setupCount():Int {
		return setupCountValue;
	}

	public function drawCount():Int {
		return drawCountValue;
	}

	public function exitCount():Int {
		return exitCountValue;
	}

	public function restoreCount():Int {
		return restoreCountValue;
	}

	public function pollTimeoutMs():Int {
		return pollTimeoutMsValue;
	}

	public function lastReport():LiveTerminalProbeReport {
		return report;
	}

	function setupNative(size:TerminalSize):LiveTerminalProbeReport {
		#if reflaxe_rust_profile
		return LiveTerminalProbeReport.fromNativeStatus(NativeLiveTerminalProbe.setupLive(size.columns, size.rows));
		#else
		return simulatedReport(LiveTerminalProbeStatus.SkippedNoTty, false, false, true, false, false, false, "interpreter skipped live terminal setup");
		#end
	}

	function drawNative(frame:TerminalFrame):LiveTerminalProbeReport {
		#if reflaxe_rust_profile
		return LiveTerminalProbeReport.fromNativeStatus(NativeLiveTerminalProbe.drawLive(frame.title, frame.text(), frame.cursorRow, frame.cursorColumn));
		#else
		return simulatedReport(LiveTerminalProbeStatus.SkippedNoTty, false, true, true, true, false, false, "interpreter skipped live terminal draw");
		#end
	}

	function pollNativeEvent():TerminalEvent {
		#if reflaxe_rust_profile
		final code = NativeLiveTerminalProbe.pollLive(pollTimeoutMsValue);
		return TerminalInputMapper.terminalEventFromNativePoll(code, NativeLiveTerminalProbe.lastInputText());
		#else
		return TerminalEvent.NoEvent;
		#end
	}

	function requestNativeExit(reason:TerminalExitReason):LiveTerminalProbeReport {
		#if reflaxe_rust_profile
		return LiveTerminalProbeReport.fromNativeStatus(NativeLiveTerminalProbe.requestExit(exitReasonCode(reason)));
		#else
		return simulatedReport(LiveTerminalProbeStatus.SkippedNoTty, false, true, true, true, false, false, "interpreter recorded live terminal exit request");
		#end
	}

	function restoreNative(reason:TerminalRestoreReason):LiveTerminalProbeReport {
		#if reflaxe_rust_profile
		return LiveTerminalProbeReport.fromNativeStatus(NativeLiveTerminalProbe.restoreLive(restoreReasonCode(reason)));
		#else
		return simulatedReport(LiveTerminalProbeStatus.SkippedNoTty, false, false, true, drawCountValue > 0, true, true,
			"interpreter skipped live terminal restore");
		#end
	}

	function simulatedReport(status:LiveTerminalProbeStatus, interactive:Bool, active:Bool, setupAttempted:Bool, drawAttempted:Bool, restoreAttempted:Bool,
			restored:Bool, message:String):LiveTerminalProbeReport {
		return LiveTerminalProbeReport.simulated({
			status: status,
			interactive: interactive,
			active: active,
			setupAttempted: setupAttempted,
			drawAttempted: drawAttempted,
			restoreAttempted: restoreAttempted,
			restored: restored,
			setupCount: setupCountValue,
			drawCount: drawCountValue,
			exitCount: exitCountValue,
			restoreCount: restoreCountValue,
			lastExitReasonCode: exitReasonCode(exitReason),
			message: message
		});
	}

	static function exitReasonCode(reason:TerminalExitReason):Int {
		if (reason == TerminalExitReason.Escape)
			return 2;
		if (reason == TerminalExitReason.CtrlC)
			return 3;
		if (reason == TerminalExitReason.Error)
			return 4;
		return 1;
	}

	static function restoreReasonCode(reason:TerminalRestoreReason):Int {
		if (reason == TerminalRestoreReason.ErrorExit)
			return 2;
		if (reason == TerminalRestoreReason.PanicFallback)
			return 3;
		return 1;
	}

	static function sanitizePollTimeout(value:Null<Int>):Int {
		if (value == null || value < 0)
			return 0;
		if (value > 1000)
			return 1000;
		return value;
	}
}
