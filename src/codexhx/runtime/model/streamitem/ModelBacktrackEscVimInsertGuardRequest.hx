package codexhx.runtime.model.streamitem;

typedef ModelBacktrackEscVimInsertGuardRequestFields = {
	final requestId:String;
	final keyIsEsc:Bool;
	final sideConversationActive:Bool;
	final normalBacktrackMode:Bool;
	final composerEmptyInitially:Bool;
	final vimModeEnabled:Bool;
	final vimInsertModeActiveBeforeEsc:Bool;
	final vimInsertEscHandled:Bool;
	final vimInsertModeActiveAfterEsc:Bool;
	final backtrackPrimedAfterVimEsc:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelBacktrackEscVimInsertGuardRequest {
	public final requestId:String;
	public final keyIsEsc:Bool;
	public final sideConversationActive:Bool;
	public final normalBacktrackMode:Bool;
	public final composerEmptyInitially:Bool;
	public final vimModeEnabled:Bool;
	public final vimInsertModeActiveBeforeEsc:Bool;
	public final vimInsertEscHandled:Bool;
	public final vimInsertModeActiveAfterEsc:Bool;
	public final backtrackPrimedAfterVimEsc:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelBacktrackEscVimInsertGuardRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.keyIsEsc = fields.keyIsEsc;
		this.sideConversationActive = fields.sideConversationActive;
		this.normalBacktrackMode = fields.normalBacktrackMode;
		this.composerEmptyInitially = fields.composerEmptyInitially;
		this.vimModeEnabled = fields.vimModeEnabled;
		this.vimInsertModeActiveBeforeEsc = fields.vimInsertModeActiveBeforeEsc;
		this.vimInsertEscHandled = fields.vimInsertEscHandled;
		this.vimInsertModeActiveAfterEsc = fields.vimInsertModeActiveAfterEsc;
		this.backtrackPrimedAfterVimEsc = fields.backtrackPrimedAfterVimEsc;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
