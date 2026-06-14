package codexhx.runtime.model.streamitem;

enum abstract ModelPatchReviewDecision(String) to String {
	public var Approved = "approved";
	public var ApprovedForSession = "approved_for_session";
	public var ApprovedWithAmendment = "approved_with_amendment";
	public var Denied = "denied";
	public var TimedOut = "timed_out";
	public var Abort = "abort";
}
