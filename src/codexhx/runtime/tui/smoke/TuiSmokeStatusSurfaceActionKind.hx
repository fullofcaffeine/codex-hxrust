package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeStatusSurfaceActionKind(String) to String {
	final RefreshSurfaces = "refresh_surfaces";
	final RefreshTerminalTitle = "refresh_terminal_title";
	final SetStatus = "set_status";
	final SetupStatusLine = "setup_status_line";
	final StatusLineBranch = "status_line_branch";
	final StatusLineGitSummary = "status_line_git_summary";
	final PreviewTerminalTitle = "preview_terminal_title";
	final RevertTerminalTitlePreview = "revert_terminal_title_preview";
	final SetupTerminalTitle = "setup_terminal_title";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeStatusSurfaceActionKind {
		return switch value {
			case "refresh_surfaces": RefreshSurfaces;
			case "refresh_terminal_title": RefreshTerminalTitle;
			case "set_status": SetStatus;
			case "setup_status_line": SetupStatusLine;
			case "status_line_branch": StatusLineBranch;
			case "status_line_git_summary": StatusLineGitSummary;
			case "preview_terminal_title": PreviewTerminalTitle;
			case "revert_terminal_title_preview": RevertTerminalTitlePreview;
			case "setup_terminal_title": SetupTerminalTitle;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
