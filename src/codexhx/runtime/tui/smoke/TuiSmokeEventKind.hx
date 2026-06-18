package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeEventKind(String) to String {
	final Draw = "draw";
	final Resize = "resize";
	final ResizeDraw = "resize_draw";
	final Key = "key";
	final StatusUpdate = "status_update";
	final InputUpdate = "input_update";
	final AppExit = "app_exit";
	final EnqueueApp = "enqueue_app";
	final AppServer = "app_server";
	final AppServerRequest = "app_server_request";
	final AppServerResolution = "app_server_resolution";
	final ThreadNotification = "thread_notification";
	final ThreadDelivery = "thread_delivery";
	final ThreadReplay = "thread_replay";
	final EventStream = "event_stream";
	final TerminalMode = "terminal_mode";
	final AltScreen = "alt_screen";
	final DrawComposition = "draw_composition";
	final FrameScheduler = "frame_scheduler";
	final DrawDispatch = "draw_dispatch";
	final OverlayRouting = "overlay_routing";
	final ApprovalOverlay = "approval_overlay";
	final UserInputOverlay = "user_input_overlay";
	final McpElicitationOverlay = "mcp_elicitation_overlay";
	final AppLinkOverlay = "app_link_overlay";
	final HooksBrowser = "hooks_browser";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeEventKind {
		return switch value {
			case "draw": Draw;
			case "resize": Resize;
			case "resize_draw": ResizeDraw;
			case "key": Key;
			case "status_update": StatusUpdate;
			case "input_update": InputUpdate;
			case "app_exit": AppExit;
			case "enqueue_app": EnqueueApp;
			case "app_server": AppServer;
			case "app_server_request": AppServerRequest;
			case "app_server_resolution": AppServerResolution;
			case "thread_notification": ThreadNotification;
			case "thread_delivery": ThreadDelivery;
			case "thread_replay": ThreadReplay;
			case "event_stream": EventStream;
			case "terminal_mode": TerminalMode;
			case "alt_screen": AltScreen;
			case "draw_composition": DrawComposition;
			case "frame_scheduler": FrameScheduler;
			case "draw_dispatch": DrawDispatch;
			case "overlay_routing": OverlayRouting;
			case "approval_overlay": ApprovalOverlay;
			case "user_input_overlay": UserInputOverlay;
			case "mcp_elicitation_overlay": McpElicitationOverlay;
			case "app_link_overlay": AppLinkOverlay;
			case "hooks_browser": HooksBrowser;
			case _: Unknown;
		}
	}
}
