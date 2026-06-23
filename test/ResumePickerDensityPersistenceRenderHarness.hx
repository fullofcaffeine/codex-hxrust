import codexhx.runtime.tui.resume.live.DensityPersistenceGate;
import sys.FileSystem;

class ResumePickerDensityPersistenceRenderHarness {
	static function main():Void {
		final tempRoot = "generated/tmp/resume-picker-density-persistence-render";
		final codexHome = tempRoot + "/codex-home";
		resetTempHome(tempRoot);

		final report = DensityPersistenceGate.run(codexHome);
		final snapshots = report.renderSnapshots;

		assertEquals("2", Std.string(report.frameRequests), "frame requests");
		assertEquals("2", Std.string(report.renderCount), "render count");
		assertEquals("2", Std.string(snapshots.length), "snapshot count");
		assertTrue(FileSystem.exists(report.successConfigPath), "config file should exist");
		assertContains(report.successConfigText, "session_picker_view = \"dense\"");
		assertContains(report.successSnapshot, "resume-picker action=resume density=dense");
		assertContains(report.successSnapshot, "config persistence=persisted path=" + report.successConfigPath);
		assertContains(report.successSnapshot, "footer density saved selected=0 selectedThread=thread-a");
		assertEquals("persistence_unconfigured", report.failureCode, "failure code");
		assertContains(report.failureMessage, "resume picker density persistence is unavailable");
		assertContains(report.failureSnapshot, "resume-picker action=resume density=comfortable");
		assertContains(report.failureSnapshot, "error code=persistence_unconfigured message=resume picker density persistence is unavailable");
		assertContains(report.failureSnapshot, "config persistence=failed path=<empty>");
		assertContains(report.failureSnapshot, "footer density not saved selected=0 selectedThread=thread-a");

		Sys.println(report.summary());
	}

	static function resetTempHome(path:String):Void {
		if (FileSystem.exists(path))
			deleteRecursive(path);
		FileSystem.createDirectory(path);
	}

	static function deleteRecursive(path:String):Void {
		if (FileSystem.isDirectory(path)) {
			for (entry in FileSystem.readDirectory(path)) {
				deleteRecursive(path + "/" + entry);
			}
			FileSystem.deleteDirectory(path);
		} else {
			FileSystem.deleteFile(path);
		}
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0)
			throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + " expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}
}
