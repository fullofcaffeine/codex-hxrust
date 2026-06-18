package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerPopupRenderActionFields = {
	final kind:TuiSmokeComposerPopupRenderActionKind;
	final popup:TuiSmokeComposerPopupKind;
	final searchMode:TuiSmokeMentionSearchModeKind;
	final width:Int;
	final composerHeight:Int;
	final popupHeight:Int;
	final requiredHeight:Int;
	final footerHeight:Int;
	final rowCount:Int;
	final visibleRows:Int;
	final maxRows:Int;
	final selectedIndex:Int;
	final scrollTop:Int;
	final windowStart:Int;
	final windowEnd:Int;
	final horizontalInset:Int;
	final verticalInset:Int;
	final emptyMessage:String;
	final columnMode:String;
	final failureCode:String;
	final renderDelegated:Bool;
	final wrapsDescriptions:Bool;
	final footerHintRendered:Bool;
	final selectedVisible:Bool;
	final waiting:Bool;
	final noLiveTerminal:Bool;
	final noRatatuiRender:Bool;
	final unsupportedRejected:Bool;
}

class TuiSmokeComposerPopupRenderAction {
	public final kind:TuiSmokeComposerPopupRenderActionKind;
	public final popup:TuiSmokeComposerPopupKind;
	public final searchMode:TuiSmokeMentionSearchModeKind;
	public final width:Int;
	public final composerHeight:Int;
	public final popupHeight:Int;
	public final requiredHeight:Int;
	public final footerHeight:Int;
	public final rowCount:Int;
	public final visibleRows:Int;
	public final maxRows:Int;
	public final selectedIndex:Int;
	public final scrollTop:Int;
	public final windowStart:Int;
	public final windowEnd:Int;
	public final horizontalInset:Int;
	public final verticalInset:Int;
	public final emptyMessage:String;
	public final columnMode:String;
	public final failureCode:String;
	public final renderDelegated:Bool;
	public final wrapsDescriptions:Bool;
	public final footerHintRendered:Bool;
	public final selectedVisible:Bool;
	public final waiting:Bool;
	public final noLiveTerminal:Bool;
	public final noRatatuiRender:Bool;
	public final unsupportedRejected:Bool;

	public function new(fields:TuiSmokeComposerPopupRenderActionFields) {
		this.kind = fields.kind == null ? TuiSmokeComposerPopupRenderActionKind.Unknown : fields.kind;
		this.popup = fields.popup == null ? TuiSmokeComposerPopupKind.Unknown : fields.popup;
		this.searchMode = fields.searchMode == null ? TuiSmokeMentionSearchModeKind.Unknown : fields.searchMode;
		this.width = fields.width;
		this.composerHeight = fields.composerHeight;
		this.popupHeight = fields.popupHeight;
		this.requiredHeight = fields.requiredHeight;
		this.footerHeight = fields.footerHeight;
		this.rowCount = fields.rowCount;
		this.visibleRows = fields.visibleRows;
		this.maxRows = fields.maxRows;
		this.selectedIndex = fields.selectedIndex;
		this.scrollTop = fields.scrollTop;
		this.windowStart = fields.windowStart;
		this.windowEnd = fields.windowEnd;
		this.horizontalInset = fields.horizontalInset;
		this.verticalInset = fields.verticalInset;
		this.emptyMessage = fields.emptyMessage == null ? "" : fields.emptyMessage;
		this.columnMode = fields.columnMode == null ? "" : fields.columnMode;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.renderDelegated = fields.renderDelegated;
		this.wrapsDescriptions = fields.wrapsDescriptions;
		this.footerHintRendered = fields.footerHintRendered;
		this.selectedVisible = fields.selectedVisible;
		this.waiting = fields.waiting;
		this.noLiveTerminal = fields.noLiveTerminal;
		this.noRatatuiRender = fields.noRatatuiRender;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

	public function windowText():String {
		return windowStart + ".." + windowEnd;
	}

	public function insetText():String {
		return horizontalInset + "/" + verticalInset;
	}
}
