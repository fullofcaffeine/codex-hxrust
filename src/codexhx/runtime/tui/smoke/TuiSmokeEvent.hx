package codexhx.runtime.tui.smoke;

typedef TuiSmokeEventFields = {
	final kind:TuiSmokeEventKind;
	final key:TuiSmokeKeyKind;
	final status:String;
	final input:String;
	final exitMode:TuiSmokeExitMode;
	final resizeDraw:Null<TuiSmokeResizeDrawAction>;
	final appEvent:Null<TuiSmokeAppEvent>;
	final appServerEvent:Null<TuiSmokeAppServerEvent>;
	final appServerRequest:Null<TuiSmokeAppServerRequest>;
	final appServerResolution:Null<TuiSmokeAppServerResolution>;
	final threadNotification:Null<TuiSmokeThreadNotification>;
	final threadDelivery:Null<TuiSmokeThreadDeliveryAction>;
	final threadReplay:Null<TuiSmokeThreadReplayAction>;
	final eventStream:Null<TuiSmokeEventStreamPlan>;
	final terminalModePlan:Null<TuiSmokeTerminalModePlan>;
	final altScreen:Null<TuiSmokeAltScreenPlan>;
	final drawComposition:Null<TuiSmokeDrawCompositionPlan>;
	final frameScheduler:Null<TuiSmokeFrameSchedulerPlan>;
	final drawDispatch:Null<TuiSmokeDrawDispatchPlan>;
	final overlayRouting:Null<TuiSmokeOverlayRoutingPlan>;
	final approvalOverlay:Null<TuiSmokeApprovalPlan>;
	final userInputOverlay:Null<TuiSmokeUserInputPlan>;
	final mcpElicitationOverlay:Null<TuiSmokeMcpElicitationPlan>;
	final appLinkOverlay:Null<TuiSmokeAppLinkPlan>;
	final hooksBrowser:Null<TuiSmokeHooksBrowserPlan>;
	final slashCommandPopup:Null<TuiSmokeSlashPopupPlan>;
}

class TuiSmokeEvent {
	public final kind:TuiSmokeEventKind;
	public final key:TuiSmokeKeyKind;
	public final status:String;
	public final input:String;
	public final exitMode:TuiSmokeExitMode;
	public final resizeDraw:Null<TuiSmokeResizeDrawAction>;
	public final appEvent:Null<TuiSmokeAppEvent>;
	public final appServerEvent:Null<TuiSmokeAppServerEvent>;
	public final appServerRequest:Null<TuiSmokeAppServerRequest>;
	public final appServerResolution:Null<TuiSmokeAppServerResolution>;
	public final threadNotification:Null<TuiSmokeThreadNotification>;
	public final threadDelivery:Null<TuiSmokeThreadDeliveryAction>;
	public final threadReplay:Null<TuiSmokeThreadReplayAction>;
	public final eventStream:Null<TuiSmokeEventStreamPlan>;
	public final terminalModePlan:Null<TuiSmokeTerminalModePlan>;
	public final altScreen:Null<TuiSmokeAltScreenPlan>;
	public final drawComposition:Null<TuiSmokeDrawCompositionPlan>;
	public final frameScheduler:Null<TuiSmokeFrameSchedulerPlan>;
	public final drawDispatch:Null<TuiSmokeDrawDispatchPlan>;
	public final overlayRouting:Null<TuiSmokeOverlayRoutingPlan>;
	public final approvalOverlay:Null<TuiSmokeApprovalPlan>;
	public final userInputOverlay:Null<TuiSmokeUserInputPlan>;
	public final mcpElicitationOverlay:Null<TuiSmokeMcpElicitationPlan>;
	public final appLinkOverlay:Null<TuiSmokeAppLinkPlan>;
	public final hooksBrowser:Null<TuiSmokeHooksBrowserPlan>;
	public final slashCommandPopup:Null<TuiSmokeSlashPopupPlan>;

	public function new(fields:TuiSmokeEventFields) {
		this.kind = fields.kind == null ? TuiSmokeEventKind.Unknown : fields.kind;
		this.key = fields.key == null ? TuiSmokeKeyKind.Unknown : fields.key;
		this.status = fields.status == null ? "" : fields.status;
		this.input = fields.input == null ? "" : fields.input;
		this.exitMode = fields.exitMode == null ? TuiSmokeExitMode.Unknown : fields.exitMode;
		this.resizeDraw = fields.resizeDraw;
		this.appEvent = fields.appEvent;
		this.appServerEvent = fields.appServerEvent;
		this.appServerRequest = fields.appServerRequest;
		this.appServerResolution = fields.appServerResolution;
		this.threadNotification = fields.threadNotification;
		this.threadDelivery = fields.threadDelivery;
		this.threadReplay = fields.threadReplay;
		this.eventStream = fields.eventStream;
		this.terminalModePlan = fields.terminalModePlan;
		this.altScreen = fields.altScreen;
		this.drawComposition = fields.drawComposition;
		this.frameScheduler = fields.frameScheduler;
		this.drawDispatch = fields.drawDispatch;
		this.overlayRouting = fields.overlayRouting;
		this.approvalOverlay = fields.approvalOverlay;
		this.userInputOverlay = fields.userInputOverlay;
		this.mcpElicitationOverlay = fields.mcpElicitationOverlay;
		this.appLinkOverlay = fields.appLinkOverlay;
		this.hooksBrowser = fields.hooksBrowser;
		this.slashCommandPopup = fields.slashCommandPopup;
	}
}
