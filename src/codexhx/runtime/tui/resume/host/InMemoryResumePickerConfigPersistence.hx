package codexhx.runtime.tui.resume.host;

import codexhx.runtime.asyncruntime.AsyncTask;
import codexhx.runtime.asyncruntime.DeterministicAsyncTask;
import codexhx.runtime.tui.resume.ResumePickerDensity;

class InMemoryResumePickerConfigPersistence implements ResumePickerConfigPersistence {
	final configured:Bool;
	var attempts:Int;
	var lastDensity:ResumePickerDensity;

	public function new(configured:Bool) {
		this.configured = configured;
		this.attempts = 0;
		this.lastDensity = ResumePickerDensity.Unknown;
	}

	public function persistDensity(density:ResumePickerDensity):AsyncTask<ResumePickerHostOutcome> {
		attempts = attempts + 1;
		lastDensity = density;
		final task = new DeterministicAsyncTask<ResumePickerHostOutcome>();
		if (!configured) {
			task.fail("persistence_unconfigured", "resume picker density persistence is unavailable", true);
		} else {
			task.complete(ResumePickerHostOutcome.persisted(Std.string(density), attempts, 0));
		}
		return task;
	}

	public function attemptCount():Int {
		return attempts;
	}

	public function persistedDensity():ResumePickerDensity {
		return lastDensity;
	}
}
