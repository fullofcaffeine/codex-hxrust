package codexhx.runtime.tui.resume.host;

import codexhx.runtime.asyncruntime.AsyncTask;

interface AppServerThreadSource {
	function requestPage(request:ResumePickerThreadListRequest):AsyncTask<ResumePickerThreadListResponse>;
	function requestTranscript(request:ResumePickerThreadReadRequest):AsyncTask<ResumePickerThreadReadResponse>;
}
