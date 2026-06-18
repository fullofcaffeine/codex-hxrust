package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppLinkActionFields = {
	final kind:TuiSmokeAppLinkActionKind;
	final suggestion:TuiSmokeAppLinkSuggestionKind;
	final screenBefore:TuiSmokeAppLinkScreenKind;
	final screenAfter:TuiSmokeAppLinkScreenKind;
	final decision:TuiSmokeAppLinkDecisionKind;
	final serverName:String;
	final requestId:String;
	final threadId:String;
	final appId:String;
	final title:String;
	final urlHost:String;
	final urlScheme:String;
	final messageChars:Int;
	final actionCount:Int;
	final selectedBefore:Int;
	final selectedAfter:Int;
	final viewStackBefore:Int;
	final viewStackAfter:Int;
	final statusTimerPaused:Bool;
	final statusTimerResumed:Bool;
	final composerDisabled:Bool;
	final frameScheduled:Bool;
	final trustedUrl:Bool;
	final requiresChatgptHost:Bool;
	final browserOpenSent:Bool;
	final refreshConnectorsSent:Bool;
	final setEnabledSent:Bool;
	final enabledBefore:Bool;
	final enabledAfter:Bool;
	final appCommandSent:Bool;
	final resolutionSent:Bool;
	final resolvedDismissed:Bool;
	final staleResolution:Bool;
	final unsupportedRejected:Bool;
	final completeBefore:Bool;
	final completeAfter:Bool;
	final failureCode:String;
}

class TuiSmokeAppLinkAction {
	public final kind:TuiSmokeAppLinkActionKind;
	public final suggestion:TuiSmokeAppLinkSuggestionKind;
	public final screenBefore:TuiSmokeAppLinkScreenKind;
	public final screenAfter:TuiSmokeAppLinkScreenKind;
	public final decision:TuiSmokeAppLinkDecisionKind;
	public final serverName:String;
	public final requestId:String;
	public final threadId:String;
	public final appId:String;
	public final title:String;
	public final urlHost:String;
	public final urlScheme:String;
	public final messageChars:Int;
	public final actionCount:Int;
	public final selectedBefore:Int;
	public final selectedAfter:Int;
	public final viewStackBefore:Int;
	public final viewStackAfter:Int;
	public final statusTimerPaused:Bool;
	public final statusTimerResumed:Bool;
	public final composerDisabled:Bool;
	public final frameScheduled:Bool;
	public final trustedUrl:Bool;
	public final requiresChatgptHost:Bool;
	public final browserOpenSent:Bool;
	public final refreshConnectorsSent:Bool;
	public final setEnabledSent:Bool;
	public final enabledBefore:Bool;
	public final enabledAfter:Bool;
	public final appCommandSent:Bool;
	public final resolutionSent:Bool;
	public final resolvedDismissed:Bool;
	public final staleResolution:Bool;
	public final unsupportedRejected:Bool;
	public final completeBefore:Bool;
	public final completeAfter:Bool;
	public final failureCode:String;

	public function new(fields:TuiSmokeAppLinkActionFields) {
		this.kind = fields.kind == null ? TuiSmokeAppLinkActionKind.Unknown : fields.kind;
		this.suggestion = fields.suggestion == null ? TuiSmokeAppLinkSuggestionKind.Unknown : fields.suggestion;
		this.screenBefore = fields.screenBefore == null ? TuiSmokeAppLinkScreenKind.Unknown : fields.screenBefore;
		this.screenAfter = fields.screenAfter == null ? TuiSmokeAppLinkScreenKind.Unknown : fields.screenAfter;
		this.decision = fields.decision == null ? TuiSmokeAppLinkDecisionKind.Unknown : fields.decision;
		this.serverName = fields.serverName == null ? "" : fields.serverName;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.appId = fields.appId == null ? "" : fields.appId;
		this.title = fields.title == null ? "" : fields.title;
		this.urlHost = fields.urlHost == null ? "" : fields.urlHost;
		this.urlScheme = fields.urlScheme == null ? "" : fields.urlScheme;
		this.messageChars = fields.messageChars;
		this.actionCount = fields.actionCount;
		this.selectedBefore = fields.selectedBefore;
		this.selectedAfter = fields.selectedAfter;
		this.viewStackBefore = fields.viewStackBefore;
		this.viewStackAfter = fields.viewStackAfter;
		this.statusTimerPaused = fields.statusTimerPaused;
		this.statusTimerResumed = fields.statusTimerResumed;
		this.composerDisabled = fields.composerDisabled;
		this.frameScheduled = fields.frameScheduled;
		this.trustedUrl = fields.trustedUrl;
		this.requiresChatgptHost = fields.requiresChatgptHost;
		this.browserOpenSent = fields.browserOpenSent;
		this.refreshConnectorsSent = fields.refreshConnectorsSent;
		this.setEnabledSent = fields.setEnabledSent;
		this.enabledBefore = fields.enabledBefore;
		this.enabledAfter = fields.enabledAfter;
		this.appCommandSent = fields.appCommandSent;
		this.resolutionSent = fields.resolutionSent;
		this.resolvedDismissed = fields.resolvedDismissed;
		this.staleResolution = fields.staleResolution;
		this.unsupportedRejected = fields.unsupportedRejected;
		this.completeBefore = fields.completeBefore;
		this.completeAfter = fields.completeAfter;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
	}

	public function screenTransitionText():String {
		return screenBefore + "->" + screenAfter;
	}

	public function selectionTransitionText():String {
		return selectedBefore + "->" + selectedAfter;
	}

	public function viewStackTransitionText():String {
		return viewStackBefore + "->" + viewStackAfter;
	}

	public function enabledTransitionText():String {
		return enabledBefore + "->" + enabledAfter;
	}

	public function completeTransitionText():String {
		return completeBefore + "->" + completeAfter;
	}
}
