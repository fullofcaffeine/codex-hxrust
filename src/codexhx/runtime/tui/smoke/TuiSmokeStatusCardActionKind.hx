package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeStatusCardActionKind(String) to String {
	final Summary = "summary";
	final ModelProvider = "model_provider";
	final Permissions = "permissions";
	final ThreadSession = "thread_session";
	final TokenUsage = "token_usage";
	final RateLimit = "rate_limit";
	final Refresh = "refresh";
	final RenderWidth = "render_width";
	final RemoteWrap = "remote_wrap";
	final Continuation = "continuation";
	final SubscriberVisibility = "subscriber_visibility";
	final UsageLink = "usage_link";
	final RefreshRequest = "refresh_request";
	final RefreshDelivery = "refresh_delivery";
	final CachedSnapshot = "cached_snapshot";
	final StaleCompletion = "stale_completion";
	final StartupPrefetch = "startup_prefetch";
	final NoRefreshGate = "no_refresh_gate";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeStatusCardActionKind {
		return switch value {
			case "summary": Summary;
			case "model_provider": ModelProvider;
			case "permissions": Permissions;
			case "thread_session": ThreadSession;
			case "token_usage": TokenUsage;
			case "rate_limit": RateLimit;
			case "refresh": Refresh;
			case "render_width": RenderWidth;
			case "remote_wrap": RemoteWrap;
			case "continuation": Continuation;
			case "subscriber_visibility": SubscriberVisibility;
			case "usage_link": UsageLink;
			case "refresh_request": RefreshRequest;
			case "refresh_delivery": RefreshDelivery;
			case "cached_snapshot": CachedSnapshot;
			case "stale_completion": StaleCompletion;
			case "startup_prefetch": StartupPrefetch;
			case "no_refresh_gate": NoRefreshGate;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
