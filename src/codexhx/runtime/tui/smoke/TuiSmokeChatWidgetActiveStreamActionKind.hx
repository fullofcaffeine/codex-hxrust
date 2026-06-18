package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetActiveStreamActionKind(String) to String {
	final AgentDelta = "agent_delta";
	final PlanDelta = "plan_delta";
	final CommitTick = "commit_tick";
	final Resize = "resize";
	final ActiveTail = "active_tail";
	final FlushAnswer = "flush_answer";
	final PlanComplete = "plan_complete";
	final RenderMode = "render_mode";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetActiveStreamActionKind {
		return switch value {
			case "agent_delta": AgentDelta;
			case "plan_delta": PlanDelta;
			case "commit_tick": CommitTick;
			case "resize": Resize;
			case "active_tail": ActiveTail;
			case "flush_answer": FlushAnswer;
			case "plan_complete": PlanComplete;
			case "render_mode": RenderMode;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
