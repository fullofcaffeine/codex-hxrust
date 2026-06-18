package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeFrameSchedulerActionKind(String) to String {
	final CreateRequester = "create_requester";
	final RequestImmediate = "request_immediate";
	final RequestDelayed = "request_delayed";
	final ClampDeadline = "clamp_deadline";
	final CoalesceDeadline = "coalesce_deadline";
	final EmitDraw = "emit_draw";
	final LaggedDraw = "lagged_draw";
	final SenderDropped = "sender_dropped";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeFrameSchedulerActionKind {
		return switch value {
			case "create_requester": CreateRequester;
			case "request_immediate": RequestImmediate;
			case "request_delayed": RequestDelayed;
			case "clamp_deadline": ClampDeadline;
			case "coalesce_deadline": CoalesceDeadline;
			case "emit_draw": EmitDraw;
			case "lagged_draw": LaggedDraw;
			case "sender_dropped": SenderDropped;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
