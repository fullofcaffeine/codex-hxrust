package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideParentPendingDecisionKind(String) to String {
	var SetNeedsInput = "set_needs_input";
	var SetNeedsApproval = "set_needs_approval";
	var ClearedNoPending = "cleared_no_pending";
	var UsedRequestStatusFallback = "used_request_status_fallback";
	var PreservedNoPending = "preserved_no_pending";
}
