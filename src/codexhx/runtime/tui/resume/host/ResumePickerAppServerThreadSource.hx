package codexhx.runtime.tui.resume.host;

import codexhx.runtime.asyncruntime.AsyncTask;

interface ResumePickerAppServerThreadSource {
	function requestPage(request:ResumePickerThreadListRequest):AsyncTask<ResumePickerThreadListResponse>;
	function requestTranscript(request:ResumePickerThreadReadRequest):AsyncTask<ResumePickerThreadReadResponse>;
}
