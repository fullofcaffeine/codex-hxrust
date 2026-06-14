package codexhx.runtime.model.streamitem;

enum abstract ModelStreamItemEventKind(String) to String {
	public var OutputItemAdded = "output_item_added";
	public var OutputItemDone = "output_item_done";
	public var OutputTextDelta = "output_text_delta";
	public var ReasoningSummaryDelta = "reasoning_summary_delta";
	public var ReasoningContentDelta = "reasoning_content_delta";
	public var Completed = "completed";
}
