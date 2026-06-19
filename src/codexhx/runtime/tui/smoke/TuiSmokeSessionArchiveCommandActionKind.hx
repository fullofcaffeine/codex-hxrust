package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSessionArchiveCommandActionKind(String) to String {
	final ResolveUuid = "resolve_uuid";
	final LookupPage = "lookup_page";
	final ResolveName = "resolve_name";
	final RpcRequest = "rpc_request";
	final RpcResponse = "rpc_response";
	final CommandResult = "command_result";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSessionArchiveCommandActionKind {
		return switch value {
			case "resolve_uuid": ResolveUuid;
			case "lookup_page": LookupPage;
			case "resolve_name": ResolveName;
			case "rpc_request": RpcRequest;
			case "rpc_response": RpcResponse;
			case "command_result": CommandResult;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
