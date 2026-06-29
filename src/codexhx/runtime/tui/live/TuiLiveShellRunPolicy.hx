package codexhx.runtime.tui.live;

import codexhx.runtime.tui.appserver.TuiAppServerPumpPolicy;

/**
	Bounded execution policy for the first runnable live TUI shell loop.
**/
class TuiLiveShellRunPolicy {
	public final maxIterations:Int;
	public final idleEventLimit:Int;
	public final appServerPolicy:TuiAppServerPumpPolicy;

	public function new(maxIterations:Int, idleEventLimit:Int, appServerPolicy:TuiAppServerPumpPolicy) {
		this.maxIterations = maxIterations <= 0 ? 1 : maxIterations;
		this.idleEventLimit = idleEventLimit <= 0 ? 1 : idleEventLimit;
		this.appServerPolicy = appServerPolicy == null ? TuiAppServerPumpPolicy.lossless() : appServerPolicy;
	}

	public static function bounded(maxIterations:Int, idleEventLimit:Int):TuiLiveShellRunPolicy {
		return new TuiLiveShellRunPolicy(maxIterations, idleEventLimit, TuiAppServerPumpPolicy.lossless());
	}
}
