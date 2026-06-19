package codexhx.runtime.tui.resume.host;

import codexhx.runtime.asyncruntime.AsyncTask;
import codexhx.runtime.asyncruntime.DeterministicAsyncTask;
import codexhx.runtime.tui.resume.ResumePickerDensity;
import sys.FileSystem;
import sys.io.File;

class TempHomeResumePickerConfigPersistence implements ResumePickerConfigPersistence {
	final codexHome:String;
	var attempts:Int;

	public function new(codexHome:String) {
		this.codexHome = codexHome;
		this.attempts = 0;
	}

	public function persistDensity(density:ResumePickerDensity):AsyncTask<ResumePickerHostOutcome> {
		attempts = attempts + 1;
		final task = new DeterministicAsyncTask<ResumePickerHostOutcome>();
		try {
			ensureDirectory(codexHome);
			final path = configPath();
			File.saveContent(path, "session_picker_view = \"" + Std.string(density) + "\"\n");
			task.complete(ResumePickerHostOutcome.persisted(path, attempts, 0));
		} catch (error:Dynamic) {
			task.fail("config_write_failed", Std.string(error), false);
		}
		return task;
	}

	public function configPath():String {
		return codexHome + "/config.toml";
	}

	public function attemptCount():Int {
		return attempts;
	}

	static function ensureDirectory(path:String):Void {
		if (path.length == 0 || FileSystem.exists(path))
			return;
		final parts = path.split("/");
		var current = "";
		for (part in parts) {
			if (part.length == 0) {
				current = "/";
				continue;
			}
			current = current == "/" ? current + part : current.length == 0 ? part : current + "/" + part;
			if (!FileSystem.exists(current))
				FileSystem.createDirectory(current);
		}
	}
}
