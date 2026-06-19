package codexhx.runtime.tui.resume.host;

import codexhx.runtime.asyncruntime.AsyncTask;
import codexhx.runtime.asyncruntime.DeterministicAsyncTask;
import haxe.ds.StringMap;

class InMemoryResumePickerThreadSource implements ResumePickerAppServerThreadSource {
	final pages:StringMap<ResumePickerThreadListResponse>;
	final reads:StringMap<ResumePickerThreadReadResponse>;
	var pageRequests:Int;
	var readRequests:Int;

	public function new() {
		this.pages = new StringMap();
		this.reads = new StringMap();
		this.pageRequests = 0;
		this.readRequests = 0;
	}

	public function addPage(response:ResumePickerThreadListResponse):Void {
		pages.set(response.requestId, response);
	}

	public function addRead(response:ResumePickerThreadReadResponse):Void {
		reads.set(response.requestId, response);
	}

	public function requestPage(request:ResumePickerThreadListRequest):AsyncTask<ResumePickerThreadListResponse> {
		pageRequests = pageRequests + 1;
		final task = new DeterministicAsyncTask<ResumePickerThreadListResponse>();
		final response = pages.get(request.requestId);
		if (response == null) {
			task.fail("missing_page_fixture", "no page response for " + request.requestId, false);
		} else {
			task.complete(response);
		}
		return task;
	}

	public function requestTranscript(request:ResumePickerThreadReadRequest):AsyncTask<ResumePickerThreadReadResponse> {
		readRequests = readRequests + 1;
		final task = new DeterministicAsyncTask<ResumePickerThreadReadResponse>();
		final response = reads.get(request.requestId);
		if (response == null) {
			task.fail("missing_thread_read_fixture", "no thread/read response for " + request.requestId, false);
		} else {
			task.complete(response);
		}
		return task;
	}

	public function pageRequestCount():Int {
		return pageRequests;
	}

	public function readRequestCount():Int {
		return readRequests;
	}
}
