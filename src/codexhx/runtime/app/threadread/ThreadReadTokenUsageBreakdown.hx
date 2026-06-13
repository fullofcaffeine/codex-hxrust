package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageBreakdown {
	public final totalTokens:Int;
	public final inputTokens:Int;
	public final cachedInputTokens:Int;
	public final outputTokens:Int;
	public final reasoningOutputTokens:Int;

	public function new(totalTokens:Int, inputTokens:Int, cachedInputTokens:Int, outputTokens:Int, reasoningOutputTokens:Int) {
		this.totalTokens = totalTokens;
		this.inputTokens = inputTokens;
		this.cachedInputTokens = cachedInputTokens;
		this.outputTokens = outputTokens;
		this.reasoningOutputTokens = reasoningOutputTokens;
	}

	public function isValid():Bool {
		return totalTokens >= 0
			&& inputTokens >= 0
			&& cachedInputTokens >= 0
			&& outputTokens >= 0
			&& reasoningOutputTokens >= 0;
	}

	public function summary(prefix:String):String {
		return prefix
			+ ".totalTokens=" + Std.string(totalTokens)
			+ "," + prefix + ".inputTokens=" + Std.string(inputTokens)
			+ "," + prefix + ".cachedInputTokens=" + Std.string(cachedInputTokens)
			+ "," + prefix + ".outputTokens=" + Std.string(outputTokens)
			+ "," + prefix + ".reasoningOutputTokens=" + Std.string(reasoningOutputTokens);
	}

	public function toJson():String {
		return "{\"totalTokens\":" + Std.string(totalTokens)
			+ ",\"inputTokens\":" + Std.string(inputTokens)
			+ ",\"cachedInputTokens\":" + Std.string(cachedInputTokens)
			+ ",\"outputTokens\":" + Std.string(outputTokens)
			+ ",\"reasoningOutputTokens\":" + Std.string(reasoningOutputTokens)
			+ "}";
	}
}
