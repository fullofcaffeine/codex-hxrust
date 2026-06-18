package codexhx.runtime.tui.smoke;

typedef TuiSmokeHooksBrowserActionFields = {
	final kind:TuiSmokeHooksBrowserActionKind;
	final pageBefore:TuiSmokeHooksBrowserPageKind;
	final pageAfter:TuiSmokeHooksBrowserPageKind;
	final eventName:String;
	final hookKey:String;
	final hookSource:TuiSmokeHookSourceKind;
	final trustBefore:TuiSmokeHookTrustKind;
	final trustAfter:TuiSmokeHookTrustKind;
	final eventCount:Int;
	final hookCount:Int;
	final activeCount:Int;
	final installedCount:Int;
	final needsReviewCount:Int;
	final warningCount:Int;
	final errorCount:Int;
	final visibleRows:Int;
	final detailLines:Int;
	final commandDetailLines:Int;
	final updatesCount:Int;
	final selectedBefore:Int;
	final selectedAfter:Int;
	final scrollBefore:Int;
	final scrollAfter:Int;
	final enabledBefore:Bool;
	final enabledAfter:Bool;
	final managed:Bool;
	final needsReview:Bool;
	final setHookEnabledSent:Bool;
	final trustHookSent:Bool;
	final trustHooksSent:Bool;
	final completeBefore:Bool;
	final completeAfter:Bool;
	final frameScheduled:Bool;
	final rendered:Bool;
	final unsupportedRejected:Bool;
	final failureCode:String;
}

class TuiSmokeHooksBrowserAction {
	public final kind:TuiSmokeHooksBrowserActionKind;
	public final pageBefore:TuiSmokeHooksBrowserPageKind;
	public final pageAfter:TuiSmokeHooksBrowserPageKind;
	public final eventName:String;
	public final hookKey:String;
	public final hookSource:TuiSmokeHookSourceKind;
	public final trustBefore:TuiSmokeHookTrustKind;
	public final trustAfter:TuiSmokeHookTrustKind;
	public final eventCount:Int;
	public final hookCount:Int;
	public final activeCount:Int;
	public final installedCount:Int;
	public final needsReviewCount:Int;
	public final warningCount:Int;
	public final errorCount:Int;
	public final visibleRows:Int;
	public final detailLines:Int;
	public final commandDetailLines:Int;
	public final updatesCount:Int;
	public final selectedBefore:Int;
	public final selectedAfter:Int;
	public final scrollBefore:Int;
	public final scrollAfter:Int;
	public final enabledBefore:Bool;
	public final enabledAfter:Bool;
	public final managed:Bool;
	public final needsReview:Bool;
	public final setHookEnabledSent:Bool;
	public final trustHookSent:Bool;
	public final trustHooksSent:Bool;
	public final completeBefore:Bool;
	public final completeAfter:Bool;
	public final frameScheduled:Bool;
	public final rendered:Bool;
	public final unsupportedRejected:Bool;
	public final failureCode:String;

	public function new(fields:TuiSmokeHooksBrowserActionFields) {
		this.kind = fields.kind == null ? TuiSmokeHooksBrowserActionKind.Unknown : fields.kind;
		this.pageBefore = fields.pageBefore == null ? TuiSmokeHooksBrowserPageKind.Unknown : fields.pageBefore;
		this.pageAfter = fields.pageAfter == null ? TuiSmokeHooksBrowserPageKind.Unknown : fields.pageAfter;
		this.eventName = fields.eventName == null ? "" : fields.eventName;
		this.hookKey = fields.hookKey == null ? "" : fields.hookKey;
		this.hookSource = fields.hookSource == null ? TuiSmokeHookSourceKind.Unknown : fields.hookSource;
		this.trustBefore = fields.trustBefore == null ? TuiSmokeHookTrustKind.Unknown : fields.trustBefore;
		this.trustAfter = fields.trustAfter == null ? TuiSmokeHookTrustKind.Unknown : fields.trustAfter;
		this.eventCount = fields.eventCount;
		this.hookCount = fields.hookCount;
		this.activeCount = fields.activeCount;
		this.installedCount = fields.installedCount;
		this.needsReviewCount = fields.needsReviewCount;
		this.warningCount = fields.warningCount;
		this.errorCount = fields.errorCount;
		this.visibleRows = fields.visibleRows;
		this.detailLines = fields.detailLines;
		this.commandDetailLines = fields.commandDetailLines;
		this.updatesCount = fields.updatesCount;
		this.selectedBefore = fields.selectedBefore;
		this.selectedAfter = fields.selectedAfter;
		this.scrollBefore = fields.scrollBefore;
		this.scrollAfter = fields.scrollAfter;
		this.enabledBefore = fields.enabledBefore;
		this.enabledAfter = fields.enabledAfter;
		this.managed = fields.managed;
		this.needsReview = fields.needsReview;
		this.setHookEnabledSent = fields.setHookEnabledSent;
		this.trustHookSent = fields.trustHookSent;
		this.trustHooksSent = fields.trustHooksSent;
		this.completeBefore = fields.completeBefore;
		this.completeAfter = fields.completeAfter;
		this.frameScheduled = fields.frameScheduled;
		this.rendered = fields.rendered;
		this.unsupportedRejected = fields.unsupportedRejected;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
	}

	public function pageTransitionText():String {
		return pageBefore + "->" + pageAfter;
	}

	public function selectionTransitionText():String {
		return selectedBefore + "->" + selectedAfter;
	}

	public function scrollTransitionText():String {
		return scrollBefore + "->" + scrollAfter;
	}

	public function enabledTransitionText():String {
		return enabledBefore + "->" + enabledAfter;
	}

	public function trustTransitionText():String {
		return trustBefore + "->" + trustAfter;
	}

	public function completeTransitionText():String {
		return completeBefore + "->" + completeAfter;
	}
}
