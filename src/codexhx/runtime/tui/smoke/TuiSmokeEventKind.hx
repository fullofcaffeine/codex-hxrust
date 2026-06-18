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
			case _: Unknown;
		}
	}
}
