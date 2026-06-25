package codexhx.runtime.tui.smoke;

typedef TuiSmokeAgentNavigationEntryFields = {
	final threadId:String;
	final agentNickname:String;
	final agentRole:String;
	final agentPath:String;
	final isRunning:Bool;
	final isClosed:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAgentNavigationEntry {
	public final threadId:String;
	public final agentNickname:String;
	public final agentRole:String;
	public final agentPath:String;
	public final isRunning:Bool;
	public final isClosed:Bool;

	public function withMetadata(agentNickname:String, agentRole:String, isClosed:Bool):TuiSmokeAgentNavigationEntry {
		return new TuiSmokeAgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: isRunning && !isClosed,
			isClosed: isClosed
		});
	}

	public function withActivity(agentPath:String, isRunning:Bool):TuiSmokeAgentNavigationEntry {
		return new TuiSmokeAgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: isRunning,
			isClosed: false
		});
	}

	public function withRunning(isRunning:Bool):TuiSmokeAgentNavigationEntry {
		return new TuiSmokeAgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: isRunning,
			isClosed: isClosed
		});
	}

	public function withAgentPath(agentPath:String):TuiSmokeAgentNavigationEntry {
		return new TuiSmokeAgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: isRunning,
			isClosed: isClosed
		});
	}

	public function closed():TuiSmokeAgentNavigationEntry {
		return new TuiSmokeAgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: false,
			isClosed: true
		});
	}
}
