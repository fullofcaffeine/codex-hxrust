package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerRequestFields = {
	final kind:TuiSmokeAppServerRequestKind;
	final requestId:String;
	final threadId:String;
	final turnId:String;
	final itemId:String;
	final approvalId:String;
	final serverName:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAppServerRequest {
	public final kind:TuiSmokeAppServerRequestKind;
	public final requestId:String;
	public final threadId:String;
	public final turnId:String;
	public final itemId:String;
	public final approvalId:String;
	public final serverName:String;

	public function displayId():String {
		return switch kind {
			case TuiSmokeAppServerRequestKind.CommandApproval:
				approvalId.length > 0 ? approvalId : itemId;
			case TuiSmokeAppServerRequestKind.McpElicitation:
				serverName.length > 0 ? serverName : requestId;
			case _:
				itemId.length > 0 ? itemId : requestId;
		}
	}

	public function replaySurface():TuiSmokeReplayedServerRequestSurfaceKind {
		return switch kind {
			case TuiSmokeAppServerRequestKind.CommandApproval:
				TuiSmokeReplayedServerRequestSurfaceKind.CommandApproval;
			case TuiSmokeAppServerRequestKind.FileChangeApproval:
				TuiSmokeReplayedServerRequestSurfaceKind.FileChangeApproval;
			case TuiSmokeAppServerRequestKind.PermissionsApproval:
				TuiSmokeReplayedServerRequestSurfaceKind.PermissionsApproval;
			case TuiSmokeAppServerRequestKind.McpElicitation:
				TuiSmokeReplayedServerRequestSurfaceKind.McpElicitation;
			case TuiSmokeAppServerRequestKind.ToolUserInput:
				TuiSmokeReplayedServerRequestSurfaceKind.ToolUserInput;
			case TuiSmokeAppServerRequestKind.DynamicToolCall
				| TuiSmokeAppServerRequestKind.AuthTokensRefresh
				| TuiSmokeAppServerRequestKind.AttestationGenerate
				| TuiSmokeAppServerRequestKind.LegacyPatchApproval
				| TuiSmokeAppServerRequestKind.LegacyCommandApproval:
				TuiSmokeReplayedServerRequestSurfaceKind.UnsupportedSuppressed;
			case _:
				TuiSmokeReplayedServerRequestSurfaceKind.Unknown;
		}
	}

	public function canReplaySurface():Bool {
		final surface = replaySurface();
		return surface != TuiSmokeReplayedServerRequestSurfaceKind.UnsupportedSuppressed
			&& surface != TuiSmokeReplayedServerRequestSurfaceKind.Unknown;
	}
}
