package codexhx.runtime.tui.terminal;

#if reflaxe_rust_profile
import codexhx.native.terminal.NativeLiveTerminalProbe;
#end

typedef LiveTerminalProbeReportFields = {
	var status:LiveTerminalProbeStatus;
	var interactive:Bool;
	var active:Bool;
	var setupAttempted:Bool;
	var drawAttempted:Bool;
	var restoreAttempted:Bool;
	var restored:Bool;
	var setupCount:Int;
	var drawCount:Int;
	var exitCount:Int;
	var restoreCount:Int;
	var lastExitReasonCode:Int;
	var message:String;
};

/**
	Typed snapshot of the live terminal native boundary.

	Why
	- The native probe crosses into crossterm/ratatui ownership, where failures
	  and CI no-TTY fallback must be observable without exposing raw Rust details
	  to app-facing TUI code.

	What
	- Captures whether a real terminal was available, which operations were
	  attempted, whether restore succeeded, and the native operation counts.

	How
	- In generated Rust builds, `fromNativeStatus` reads scalar extern getters
	  immediately after each native operation.
	- In interpreter builds, `simulated` provides the same typed shape without
	  touching a terminal.
**/
class LiveTerminalProbeReport {
	public final status:LiveTerminalProbeStatus;
	public final interactive:Bool;
	public final active:Bool;
	public final setupAttempted:Bool;
	public final drawAttempted:Bool;
	public final restoreAttempted:Bool;
	public final restored:Bool;
	public final setupCount:Int;
	public final drawCount:Int;
	public final exitCount:Int;
	public final restoreCount:Int;
	public final lastExitReasonCode:Int;
	public final message:String;

	public function new(fields:LiveTerminalProbeReportFields) {
		this.status = fields.status;
		this.interactive = fields.interactive;
		this.active = fields.active;
		this.setupAttempted = fields.setupAttempted;
		this.drawAttempted = fields.drawAttempted;
		this.restoreAttempted = fields.restoreAttempted;
		this.restored = fields.restored;
		this.setupCount = fields.setupCount;
		this.drawCount = fields.drawCount;
		this.exitCount = fields.exitCount;
		this.restoreCount = fields.restoreCount;
		this.lastExitReasonCode = fields.lastExitReasonCode;
		this.message = fields.message;
	}

	public static function fromNativeStatus(statusCode:Int):LiveTerminalProbeReport {
		#if reflaxe_rust_profile
		return new LiveTerminalProbeReport({
			status: statusCode,
			interactive: NativeLiveTerminalProbe.isInteractive(),
			active: NativeLiveTerminalProbe.isActive(),
			setupAttempted: NativeLiveTerminalProbe.setupWasAttempted(),
			drawAttempted: NativeLiveTerminalProbe.drawWasAttempted(),
			restoreAttempted: NativeLiveTerminalProbe.restoreWasAttempted(),
			restored: NativeLiveTerminalProbe.wasRestored(),
			setupCount: NativeLiveTerminalProbe.setupCount(),
			drawCount: NativeLiveTerminalProbe.drawCount(),
			exitCount: NativeLiveTerminalProbe.exitCount(),
			restoreCount: NativeLiveTerminalProbe.restoreCount(),
			lastExitReasonCode: NativeLiveTerminalProbe.lastExitReason(),
			message: NativeLiveTerminalProbe.lastMessage()
		});
		#else
		return simulated({
			status: statusCode,
			interactive: false,
			active: false,
			setupAttempted: false,
			drawAttempted: false,
			restoreAttempted: false,
			restored: statusCode == LiveTerminalProbeStatus.SkippedNoTty,
			setupCount: 0,
			drawCount: 0,
			exitCount: 0,
			restoreCount: 0,
			lastExitReasonCode: 0,
			message: "interpreter live terminal probe simulation"
		});
		#end
	}

	public static function simulated(fields:LiveTerminalProbeReportFields):LiveTerminalProbeReport {
		return new LiveTerminalProbeReport(fields);
	}

	public function okForCi():Bool {
		return status.okForCi();
	}

	public function summary():String {
		return "status=" + status.text() + ";interactive=" + boolText(interactive) + ";active=" + boolText(active) + ";setup=" + boolText(setupAttempted)
			+ ";draw=" + boolText(drawAttempted) + ";restore=" + boolText(restoreAttempted) + ";restored=" + boolText(restored) + ";counts=" + setupCount
			+ "/" + drawCount + "/" + exitCount + "/" + restoreCount + ";message=" + message;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
