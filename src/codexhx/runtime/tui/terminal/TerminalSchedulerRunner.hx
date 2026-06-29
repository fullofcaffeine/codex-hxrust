package codexhx.runtime.tui.terminal;

/**
	Applies scheduler effects to a terminal backend.
**/
class TerminalSchedulerRunner {
	public static function applyEffects(backend:TerminalBackend, effects:Array<TerminalSchedulerEffect>):Array<TerminalOperation> {
		final operations:Array<TerminalOperation> = [];
		if (backend == null || effects == null)
			return operations;
		for (effect in effects) {
			switch effect {
				case ResizeBackend(size):
					operations.push(backend.resize(size));
				case DrawFrame(frame):
					operations.push(backend.draw(frame));
				case RequestExit(reason):
					operations.push(backend.requestExit(reason));
			}
		}
		return operations;
	}
}
