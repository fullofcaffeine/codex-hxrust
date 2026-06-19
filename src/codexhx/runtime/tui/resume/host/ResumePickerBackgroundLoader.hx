package codexhx.runtime.tui.resume.host;

import codexhx.runtime.asyncruntime.AsyncCancelReason;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncStreamItem;

interface ResumePickerBackgroundLoader {
	function enqueue(request:ResumePickerBackgroundRequest):AsyncPoll<Bool>;
	function pollEvent(context:AsyncContext):AsyncPoll<AsyncStreamItem<ResumePickerHostEvent>>;
	function cancel(reason:AsyncCancelReason):AsyncPoll<AsyncStreamItem<ResumePickerHostEvent>>;
}
