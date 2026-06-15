package codexhx.runtime.model.streamitem;

typedef ModelCollabAgentMetadataEntryFields = {
	final threadId:String;
	final agentNickname:String;
	final agentRole:String;
}

class ModelCollabAgentMetadataEntry {
	public final threadId:String;
	public final agentNickname:String;
	public final agentRole:String;

	public function new(fields:ModelCollabAgentMetadataEntryFields) {
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.agentNickname = fields.agentNickname == null ? "" : fields.agentNickname;
		this.agentRole = fields.agentRole == null ? "" : fields.agentRole;
	}
}
