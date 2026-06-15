package codexhx.runtime.model.streamitem;

typedef ModelSideConversationBacktrackEscVimGuardRequestFields = {
	final requestId:String;
	final keyIsEsc:Bool;
	final sideConversationActive:Bool;
	final normalBacktrackMode:Bool;
	final composerEmptyInitially:Bool;
	final vimModeEnabled:Bool;
	final vimInsertModeActiveBeforeSideEsc:Bool;
	final vimInsertModeActiveAfterInsertKey:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelSideConversationBacktrackEscVimGuardRequest {
	public final requestId:String;
	public final keyIsEsc:Bool;
	public final sideConversationActive:Bool;
	public final normalBacktrackMode:Bool;
	public final composerEmptyInitially:Bool;
	public final vimModeEnabled:Bool;
	public final vimInsertModeActiveBeforeSideEsc:Bool;
	public final vimInsertModeActiveAfterInsertKey:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelSideConversationBacktrackEscVimGuardRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.keyIsEsc = fields.keyIsEsc;
		this.sideConversationActive = fields.sideConversationActive;
		this.normalBacktrackMode = fields.normalBacktrackMode;
		this.composerEmptyInitially = fields.composerEmptyInitially;
		this.vimModeEnabled = fields.vimModeEnabled;
		this.vimInsertModeActiveBeforeSideEsc = fields.vimInsertModeActiveBeforeSideEsc;
		this.vimInsertModeActiveAfterInsertKey = fields.vimInsertModeActiveAfterInsertKey;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
