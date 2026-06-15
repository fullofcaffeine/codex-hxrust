package codexhx.runtime.model.streamitem;

typedef ModelKeymapAliasRequestFields = {
	final requestId:String;
	final composerToggleShortcutsConfiguredEmpty:Bool;
	final composerToggleShortcutCount:Int;
	final defaultRawOutputToggle:Null<ModelKeymapBinding>;
	final remappedRawOutputToggle:Null<ModelKeymapBinding>;
	final editorInsertNewlineBindings:Array<ModelKeymapBinding>;
	final editorDeleteForwardWordBindings:Array<ModelKeymapBinding>;
	final editorDeleteBackwardBindings:Array<ModelKeymapBinding>;
	final editorDeleteForwardBindings:Array<ModelKeymapBinding>;
	final editorDeleteBackwardWordBindings:Array<ModelKeymapBinding>;
	final composerToggleShortcutBindings:Array<ModelKeymapBinding>;
	final approvalOpenFullscreenBindings:Array<ModelKeymapBinding>;
	final primaryBindingCandidates:Array<ModelKeymapBinding>;
	final primaryBindingExpected:Null<ModelKeymapBinding>;
	final primaryEmptyCandidateCount:Int;
	final defaultsConflictValidationPassed:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapAliasRequest {
	public final requestId:String;
	public final composerToggleShortcutsConfiguredEmpty:Bool;
	public final composerToggleShortcutCount:Int;
	public final defaultRawOutputToggle:Null<ModelKeymapBinding>;
	public final remappedRawOutputToggle:Null<ModelKeymapBinding>;
	public final editorInsertNewlineBindings:Array<ModelKeymapBinding>;
	public final editorDeleteForwardWordBindings:Array<ModelKeymapBinding>;
	public final editorDeleteBackwardBindings:Array<ModelKeymapBinding>;
	public final editorDeleteForwardBindings:Array<ModelKeymapBinding>;
	public final editorDeleteBackwardWordBindings:Array<ModelKeymapBinding>;
	public final composerToggleShortcutBindings:Array<ModelKeymapBinding>;
	public final approvalOpenFullscreenBindings:Array<ModelKeymapBinding>;
	public final primaryBindingCandidates:Array<ModelKeymapBinding>;
	public final primaryBindingExpected:Null<ModelKeymapBinding>;
	public final primaryEmptyCandidateCount:Int;
	public final defaultsConflictValidationPassed:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapAliasRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.composerToggleShortcutsConfiguredEmpty = fields.composerToggleShortcutsConfiguredEmpty;
		this.composerToggleShortcutCount = fields.composerToggleShortcutCount;
		this.defaultRawOutputToggle = fields.defaultRawOutputToggle;
		this.remappedRawOutputToggle = fields.remappedRawOutputToggle;
		this.editorInsertNewlineBindings = fields.editorInsertNewlineBindings == null ? [] : fields.editorInsertNewlineBindings;
		this.editorDeleteForwardWordBindings = fields.editorDeleteForwardWordBindings == null ? [] : fields.editorDeleteForwardWordBindings;
		this.editorDeleteBackwardBindings = fields.editorDeleteBackwardBindings == null ? [] : fields.editorDeleteBackwardBindings;
		this.editorDeleteForwardBindings = fields.editorDeleteForwardBindings == null ? [] : fields.editorDeleteForwardBindings;
		this.editorDeleteBackwardWordBindings = fields.editorDeleteBackwardWordBindings == null ? [] : fields.editorDeleteBackwardWordBindings;
		this.composerToggleShortcutBindings = fields.composerToggleShortcutBindings == null ? [] : fields.composerToggleShortcutBindings;
		this.approvalOpenFullscreenBindings = fields.approvalOpenFullscreenBindings == null ? [] : fields.approvalOpenFullscreenBindings;
		this.primaryBindingCandidates = fields.primaryBindingCandidates == null ? [] : fields.primaryBindingCandidates;
		this.primaryBindingExpected = fields.primaryBindingExpected;
		this.primaryEmptyCandidateCount = fields.primaryEmptyCandidateCount;
		this.defaultsConflictValidationPassed = fields.defaultsConflictValidationPassed;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
