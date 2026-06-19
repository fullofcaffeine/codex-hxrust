package codexhx.runtime.app.threadread;

import codexhx.protocol.TurnId;

class ThreadReadTokenUsageTurnOwnerHint {
	public final id:TurnId;
	public final position:Int;
	public final hasPosition:Bool;

	function new(id:TurnId, position:Int, hasPosition:Bool) {
		this.id = id;
		this.position = position;
		this.hasPosition = hasPosition;
	}

	public static function fromRaw(id:String, position:Int, hasPosition:Bool):Null<ThreadReadTokenUsageTurnOwnerHint> {
		final turnId = TurnId.fromString(id);
		if (turnId == null)
			return null;
		if (hasPosition && position < 0)
			return null;
		return new ThreadReadTokenUsageTurnOwnerHint(turnId, position, hasPosition);
	}

	public function idString():String {
		return id.toString();
	}

	public function summary():String {
		return "owner=" + idString() + ";position=" + (hasPosition ? Std.string(position) : "none");
	}
}
