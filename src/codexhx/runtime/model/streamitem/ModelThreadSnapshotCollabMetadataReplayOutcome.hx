package codexhx.runtime.model.streamitem;

typedef ModelThreadSnapshotCollabMetadataReplayOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final replayKind:ModelTurnReplayKind;
	final decisionKind:ModelThreadSnapshotCollabMetadataReplayDecisionKind;
	final navigationEntryCount:Int;
	final reseededMetadataCount:Int;
	final replayedWaitItemCount:Int;
	final namedWaitItemCount:Int;
	final replacementCreatedBeforeReplay:Bool;
	final metadataReseededBeforeReplay:Bool;
	final agentNicknamePreserved:Bool;
	final agentRolePreserved:Bool;
	final waitItemRendered:Bool;
	final renderedWaitContainsMetadata:Bool;
	final fallbackThreadIdRendered:Bool;
	final liveOnlyEffectsSuppressed:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final renderedWaitSummary:String;
	final errorMessage:String;
}

class ModelThreadSnapshotCollabMetadataReplayOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final replayKind:ModelTurnReplayKind;
	public final decisionKind:ModelThreadSnapshotCollabMetadataReplayDecisionKind;
	public final navigationEntryCount:Int;
	public final reseededMetadataCount:Int;
	public final replayedWaitItemCount:Int;
	public final namedWaitItemCount:Int;
	public final replacementCreatedBeforeReplay:Bool;
	public final metadataReseededBeforeReplay:Bool;
	public final agentNicknamePreserved:Bool;
	public final agentRolePreserved:Bool;
	public final waitItemRendered:Bool;
	public final renderedWaitContainsMetadata:Bool;
	public final fallbackThreadIdRendered:Bool;
	public final liveOnlyEffectsSuppressed:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final renderedWaitSummary:String;
	public final errorMessage:String;

	public function new(fields:ModelThreadSnapshotCollabMetadataReplayOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.replayKind = fields.replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : fields.replayKind;
		this.decisionKind = fields.decisionKind == null ? ModelThreadSnapshotCollabMetadataReplayDecisionKind.MetadataReplayBlocked : fields.decisionKind;
		this.navigationEntryCount = fields.navigationEntryCount;
		this.reseededMetadataCount = fields.reseededMetadataCount;
		this.replayedWaitItemCount = fields.replayedWaitItemCount;
		this.namedWaitItemCount = fields.namedWaitItemCount;
		this.replacementCreatedBeforeReplay = fields.replacementCreatedBeforeReplay;
		this.metadataReseededBeforeReplay = fields.metadataReseededBeforeReplay;
		this.agentNicknamePreserved = fields.agentNicknamePreserved;
		this.agentRolePreserved = fields.agentRolePreserved;
		this.waitItemRendered = fields.waitItemRendered;
		this.renderedWaitContainsMetadata = fields.renderedWaitContainsMetadata;
		this.fallbackThreadIdRendered = fields.fallbackThreadIdRendered;
		this.liveOnlyEffectsSuppressed = fields.liveOnlyEffectsSuppressed;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.renderedWaitSummary = fields.renderedWaitSummary == null ? "" : fields.renderedWaitSummary;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";replayKind=" + replayKind
			+ ";decisionKind=" + decisionKind
			+ ";navigationEntryCount=" + navigationEntryCount
			+ ";reseededMetadataCount=" + reseededMetadataCount
			+ ";replayedWaitItemCount=" + replayedWaitItemCount
			+ ";namedWaitItemCount=" + namedWaitItemCount
			+ ";replacementCreatedBeforeReplay=" + boolText(replacementCreatedBeforeReplay)
			+ ";metadataReseededBeforeReplay=" + boolText(metadataReseededBeforeReplay)
			+ ";agentNicknamePreserved=" + boolText(agentNicknamePreserved)
			+ ";agentRolePreserved=" + boolText(agentRolePreserved)
			+ ";waitItemRendered=" + boolText(waitItemRendered)
			+ ";renderedWaitContainsMetadata=" + boolText(renderedWaitContainsMetadata)
			+ ";fallbackThreadIdRendered=" + boolText(fallbackThreadIdRendered)
			+ ";liveOnlyEffectsSuppressed=" + boolText(liveOnlyEffectsSuppressed)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";renderedWaitSummary=" + renderedWaitSummary
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
