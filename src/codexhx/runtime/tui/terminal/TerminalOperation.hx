package codexhx.runtime.tui.terminal;

/**
	Result for a terminal backend operation.
**/
class TerminalOperation {
	public final kind:TerminalOperationKind;
	public final ok:Bool;
	public final message:String;

	public function new(kind:TerminalOperationKind, ok:Bool, message:String) {
		this.kind = kind;
		this.ok = ok;
		this.message = message;
	}

	public static function accepted(kind:TerminalOperationKind, message:String):TerminalOperation {
		return new TerminalOperation(kind, true, message);
	}

	public static function rejected(message:String):TerminalOperation {
		return new TerminalOperation(TerminalOperationKind.Rejected, false, message);
	}

	public static function inactive(message:String):TerminalOperation {
		return new TerminalOperation(TerminalOperationKind.Inactive, false, message);
	}

	public static function alreadyActive(message:String):TerminalOperation {
		return new TerminalOperation(TerminalOperationKind.AlreadyActive, false, message);
	}
}
