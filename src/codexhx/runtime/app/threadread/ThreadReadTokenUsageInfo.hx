package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageInfo {
	public final total:ThreadReadTokenUsageBreakdown;
	public final last:ThreadReadTokenUsageBreakdown;
	public final hasModelContextWindow:Bool;
	public final modelContextWindow:Int;

	public function new(total:ThreadReadTokenUsageBreakdown, last:ThreadReadTokenUsageBreakdown, hasModelContextWindow:Bool, modelContextWindow:Int) {
		this.total = total;
		this.last = last;
		this.hasModelContextWindow = hasModelContextWindow;
		this.modelContextWindow = modelContextWindow;
	}

	public function isValid():Bool {
		return total != null
			&& last != null
			&& total.isValid()
			&& last.isValid()
			&& (!hasModelContextWindow || modelContextWindow >= 0);
	}

	public function modelContextWindowText():String {
		return hasModelContextWindow ? Std.string(modelContextWindow) : "null";
	}

	public function summary():String {
		return total.summary("total") + ";" + last.summary("last") + ";modelContextWindow=" + modelContextWindowText();
	}

	public function toJson():String {
		return "{\"total\":"
			+ total.toJson()
			+ ",\"last\":"
			+ last.toJson()
			+ ",\"modelContextWindow\":"
			+ modelContextWindowText()
			+ "}";
	}
}
