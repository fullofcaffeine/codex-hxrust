package codexhx.runtime.tui.resume.host;

import codexhx.runtime.asyncruntime.AsyncCancelReason;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncDeliveryKind;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.asyncruntime.DeterministicAsyncStream;

class DeterministicResumePickerBackgroundLoader implements ResumePickerBackgroundLoader {
	final source:ResumePickerAppServerThreadSource;
	final stream:DeterministicAsyncStream<ResumePickerHostEvent>;

	public function new(source:ResumePickerAppServerThreadSource, capacity:Int) {
		this.source = source;
		this.stream = new DeterministicAsyncStream<ResumePickerHostEvent>(capacity);
	}

	public function enqueue(request:ResumePickerBackgroundRequest):AsyncPoll<Bool> {
		return switch request.kind {
			case ResumePickerBackgroundRequestKind.Page:
				if (request.page == null) {
					stream.push(ResumePickerHostEvent.failed("", "", "missing_page_request", "page request missing payload"), AsyncDeliveryKind.Lossless);
				} else {
					final pageTask = source.requestPage(request.page);
					switch pageTask.poll(AsyncContext.fixture("page")) {
						case Ready(response, _, _):
							stream.push(ResumePickerHostEvent.pageLoaded(response), AsyncDeliveryKind.Lossless);
						case Failed(error, _, _):
							stream.push(ResumePickerHostEvent.failed(request.page.requestId, "", error.code, error.message), AsyncDeliveryKind.Lossless);
						case Cancelled(reason, _, _):
							stream.push(ResumePickerHostEvent.failed(request.page.requestId, "", "cancelled", Std.string(reason)), AsyncDeliveryKind.Lossless);
						case _:
							stream.push(ResumePickerHostEvent.failed(request.page.requestId, "", "pending", "page task did not complete deterministically"), AsyncDeliveryKind.Lossless);
					}
				}
			case ResumePickerBackgroundRequestKind.Preview:
				enqueueRead(request, true);
			case ResumePickerBackgroundRequestKind.Transcript:
				enqueueRead(request, false);
			case ResumePickerBackgroundRequestKind.Frame:
				stream.push(ResumePickerHostEvent.frameRequested(request.reason), AsyncDeliveryKind.BestEffort);
			case ResumePickerBackgroundRequestKind.Unknown:
				stream.push(ResumePickerHostEvent.failed("", "", "unknown_background_request", "unsupported background request"), AsyncDeliveryKind.BestEffort);
		}
	}

	function enqueueRead(request:ResumePickerBackgroundRequest, preview:Bool):AsyncPoll<Bool> {
		if (request.read == null) {
			return stream.push(ResumePickerHostEvent.failed("", "", "missing_read_request", "thread/read request missing payload"), AsyncDeliveryKind.Lossless);
		}
		final readTask = source.requestTranscript(request.read);
		return switch readTask.poll(AsyncContext.fixture(preview ? "preview" : "transcript")) {
			case Ready(response, _, _):
				stream.push(preview ? ResumePickerHostEvent.previewLoaded(response) : ResumePickerHostEvent.transcriptLoaded(response), AsyncDeliveryKind.Lossless);
			case Failed(error, _, _):
				stream.push(ResumePickerHostEvent.failed(request.read.requestId, request.read.threadId, error.code, error.message), AsyncDeliveryKind.Lossless);
			case Cancelled(reason, _, _):
				stream.push(ResumePickerHostEvent.failed(request.read.requestId, request.read.threadId, "cancelled", Std.string(reason)), AsyncDeliveryKind.Lossless);
			case _:
				stream.push(ResumePickerHostEvent.failed(request.read.requestId, request.read.threadId, "pending", "thread/read task did not complete deterministically"), AsyncDeliveryKind.Lossless);
		}
	}

	public function pollEvent(context:AsyncContext):AsyncPoll<AsyncStreamItem<ResumePickerHostEvent>> {
		return stream.pollNext(context);
	}

	public function cancel(reason:AsyncCancelReason):AsyncPoll<AsyncStreamItem<ResumePickerHostEvent>> {
		return stream.cancel(reason);
	}

	public function pendingCount():Int {
		return stream.pendingCount();
	}

	public function skippedCount():Int {
		return stream.skippedCount();
	}
}
