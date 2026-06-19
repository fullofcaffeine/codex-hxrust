package codexhx.runtime.tui.resume.host;

import codexhx.runtime.asyncruntime.AsyncTask;
import codexhx.runtime.tui.resume.ResumePickerDensity;

interface ResumePickerConfigPersistence {
	function persistDensity(density:ResumePickerDensity):AsyncTask<ResumePickerHostOutcome>;
}
