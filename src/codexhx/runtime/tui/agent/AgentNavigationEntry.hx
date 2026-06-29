package codexhx.runtime.tui.agent;

import codexhx.protocol.ThreadId;

typedef AgentNavigationEntryFields = {
	final threadId:ThreadId;
	final agentNickname:String;
	final agentRole:String;
	final agentPath:String;
	final isRunning:Bool;
	final isClosed:Bool;
}

/**
	Immutable metadata for one thread visible in the agent navigation picker.
**/
class AgentNavigationEntry {
	public final threadId:ThreadId;
	public final agentNickname:String;
	public final agentRole:String;
	public final agentPath:String;
	public final isRunning:Bool;
	public final isClosed:Bool;

	public function new(fields:AgentNavigationEntryFields) {
		if (fields.threadId == null)
			throw "agent navigation entry requires a thread id";
		threadId = fields.threadId;
		agentNickname = fields.agentNickname == null ? "" : fields.agentNickname;
		agentRole = fields.agentRole == null ? "" : fields.agentRole;
		agentPath = fields.agentPath == null ? "" : fields.agentPath;
		isRunning = fields.isRunning;
		isClosed = fields.isClosed;
	}

	public function withMetadata(agentNickname:String, agentRole:String, isClosed:Bool):AgentNavigationEntry {
		return new AgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: isRunning && !isClosed,
			isClosed: isClosed
		});
	}

	public function withActivity(agentPath:String, isRunning:Bool):AgentNavigationEntry {
		return new AgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: isRunning,
			isClosed: false
		});
	}

	public function withRunning(isRunning:Bool):AgentNavigationEntry {
		return new AgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: isRunning,
			isClosed: isClosed
		});
	}

	public function withAgentPath(agentPath:String):AgentNavigationEntry {
		return new AgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: isRunning,
			isClosed: isClosed
		});
	}

	public function closed():AgentNavigationEntry {
		return new AgentNavigationEntry({
			threadId: threadId,
			agentNickname: agentNickname,
			agentRole: agentRole,
			agentPath: agentPath,
			isRunning: false,
			isClosed: true
		});
	}
}
