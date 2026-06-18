package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHistorySearchActionKind(String) to String {
	final Begin = "begin";
	final QueryEdit = "query_edit";
	final SearchResult = "search_result";
	final Navigate = "navigate";
	final Accept = "accept";
	final Cancel = "cancel";
	final LookupRequest = "lookup_request";
	final LookupResponse = "lookup_response";
	final FooterRender = "footer_render";
	final Highlight = "highlight";
	final Keymap = "keymap";
	final SuppressPopups = "suppress_popups";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHistorySearchActionKind {
		return switch value {
			case "begin": Begin;
			case "query_edit": QueryEdit;
			case "search_result": SearchResult;
			case "navigate": Navigate;
			case "accept": Accept;
			case "cancel": Cancel;
			case "lookup_request": LookupRequest;
			case "lookup_response": LookupResponse;
			case "footer_render": FooterRender;
			case "highlight": Highlight;
			case "keymap": Keymap;
			case "suppress_popups": SuppressPopups;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
