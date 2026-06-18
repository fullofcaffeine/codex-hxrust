package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerTextareaRenderActionFields = {
	final kind:TuiSmokeComposerTextareaRenderActionKind;
	final mode:TuiSmokeComposerTextareaRenderModeKind;
	final promptKind:TuiSmokeComposerTextareaPromptKind;
	final promptText:String;
	final placeholderText:String;
	final maskChar:String;
	final failureCode:String;
	final width:Int;
	final height:Int;
	final textareaRightReserve:Int;
	final innerWidth:Int;
	final composerHeight:Int;
	final popupHeight:Int;
	final footerTotalHeight:Int;
	final textareaWidth:Int;
	final textareaHeight:Int;
	final remoteImageCount:Int;
	final remoteImageHeight:Int;
	final remoteImageSeparator:Int;
	final selectedRemoteIndex:Int;
	final desiredHeight:Int;
	final wrappedLineCount:Int;
	final scrollBefore:Int;
	final scrollAfter:Int;
	final visibleStartLine:Int;
	final visibleEndLine:Int;
	final textLength:Int;
	final elementCount:Int;
	final highlightCount:Int;
	final pluginHighlightCount:Int;
	final historyHighlightCount:Int;
	final cursorX:Int;
	final cursorY:Int;
	final inputEnabled:Bool;
	final bashMode:Bool;
	final textareaEmpty:Bool;
	final placeholderVisible:Bool;
	final cursorVisible:Bool;
	final remoteImagesDoNotMutateTextarea:Bool;
	final renderOnlyHighlights:Bool;
	final noLiveTerminal:Bool;
	final noRatatuiRender:Bool;
	final unsupportedRejected:Bool;
}

class TuiSmokeComposerTextareaRenderAction {
	public final kind:TuiSmokeComposerTextareaRenderActionKind;
	public final mode:TuiSmokeComposerTextareaRenderModeKind;
	public final promptKind:TuiSmokeComposerTextareaPromptKind;
	public final promptText:String;
	public final placeholderText:String;
	public final maskChar:String;
	public final failureCode:String;
	public final width:Int;
	public final height:Int;
	public final textareaRightReserve:Int;
	public final innerWidth:Int;
	public final composerHeight:Int;
	public final popupHeight:Int;
	public final footerTotalHeight:Int;
	public final textareaWidth:Int;
	public final textareaHeight:Int;
	public final remoteImageCount:Int;
	public final remoteImageHeight:Int;
	public final remoteImageSeparator:Int;
	public final selectedRemoteIndex:Int;
	public final desiredHeight:Int;
	public final wrappedLineCount:Int;
	public final scrollBefore:Int;
	public final scrollAfter:Int;
	public final visibleStartLine:Int;
	public final visibleEndLine:Int;
	public final textLength:Int;
	public final elementCount:Int;
	public final highlightCount:Int;
	public final pluginHighlightCount:Int;
	public final historyHighlightCount:Int;
	public final cursorX:Int;
	public final cursorY:Int;
	public final inputEnabled:Bool;
	public final bashMode:Bool;
	public final textareaEmpty:Bool;
	public final placeholderVisible:Bool;
	public final cursorVisible:Bool;
	public final remoteImagesDoNotMutateTextarea:Bool;
	public final renderOnlyHighlights:Bool;
	public final noLiveTerminal:Bool;
	public final noRatatuiRender:Bool;
	public final unsupportedRejected:Bool;

	public function new(fields:TuiSmokeComposerTextareaRenderActionFields) {
		this.kind = fields.kind == null ? TuiSmokeComposerTextareaRenderActionKind.Unknown : fields.kind;
		this.mode = fields.mode == null ? TuiSmokeComposerTextareaRenderModeKind.Unknown : fields.mode;
		this.promptKind = fields.promptKind == null ? TuiSmokeComposerTextareaPromptKind.Unknown : fields.promptKind;
		this.promptText = fields.promptText == null ? "" : fields.promptText;
		this.placeholderText = fields.placeholderText == null ? "" : fields.placeholderText;
		this.maskChar = fields.maskChar == null ? "" : fields.maskChar;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.width = fields.width;
		this.height = fields.height;
		this.textareaRightReserve = fields.textareaRightReserve;
		this.innerWidth = fields.innerWidth;
		this.composerHeight = fields.composerHeight;
		this.popupHeight = fields.popupHeight;
		this.footerTotalHeight = fields.footerTotalHeight;
		this.textareaWidth = fields.textareaWidth;
		this.textareaHeight = fields.textareaHeight;
		this.remoteImageCount = fields.remoteImageCount;
		this.remoteImageHeight = fields.remoteImageHeight;
		this.remoteImageSeparator = fields.remoteImageSeparator;
		this.selectedRemoteIndex = fields.selectedRemoteIndex;
		this.desiredHeight = fields.desiredHeight;
		this.wrappedLineCount = fields.wrappedLineCount;
		this.scrollBefore = fields.scrollBefore;
		this.scrollAfter = fields.scrollAfter;
		this.visibleStartLine = fields.visibleStartLine;
		this.visibleEndLine = fields.visibleEndLine;
		this.textLength = fields.textLength;
		this.elementCount = fields.elementCount;
		this.highlightCount = fields.highlightCount;
		this.pluginHighlightCount = fields.pluginHighlightCount;
		this.historyHighlightCount = fields.historyHighlightCount;
		this.cursorX = fields.cursorX;
		this.cursorY = fields.cursorY;
		this.inputEnabled = fields.inputEnabled;
		this.bashMode = fields.bashMode;
		this.textareaEmpty = fields.textareaEmpty;
		this.placeholderVisible = fields.placeholderVisible;
		this.cursorVisible = fields.cursorVisible;
		this.remoteImagesDoNotMutateTextarea = fields.remoteImagesDoNotMutateTextarea;
		this.renderOnlyHighlights = fields.renderOnlyHighlights;
		this.noLiveTerminal = fields.noLiveTerminal;
		this.noRatatuiRender = fields.noRatatuiRender;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

	public function lineWindowText():String {
		return visibleStartLine + ".." + visibleEndLine;
	}

	public function textareaSizeText():String {
		return textareaWidth + "x" + textareaHeight;
	}
}
