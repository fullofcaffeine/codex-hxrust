import codexhx.runtime.tui.resume.live.ResumePickerNoCredentialGate;
import codexhx.runtime.tui.resume.live.ResumePickerNoCredentialReport;
import sys.FileSystem;
import sys.io.File;

class ResumePickerNoCredentialGateHarness {
	static function main():Void {
		final tempRoot = "generated/tmp/resume-picker-no-credential";
		final codexHome = tempRoot + "/codex-home";
		resetTempHome(tempRoot);

		final report = ResumePickerNoCredentialGate.run(codexHome);

		assertEquals("1", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.transcriptLoads), "transcript loads");
		assertEquals("3", Std.string(report.keyEvents), "key events");
		assertEquals("6", Std.string(report.frameRequests), "frame requests");
		assertEquals("6", Std.string(report.renderCount), "render count");
		assertTrue(report.overlayOpened, "transcript overlay should open");
		assertTrue(report.densityPersisted, "density should persist into temp Codex home");
		assertTrue(FileSystem.exists(report.configPath), "config file should exist");
		assertContains(report.configText, "session_picker_view = \"dense\"");
		assertContains(report.finalSummary, "selected=1");
		assertContains(report.finalSummary, "density=dense");
		assertContains(report.finalSummary, "overlay=true");
		assertContains(report.finalSummary, "pending=thread-b");
		assertContains(report.summary(), "kind=page_loaded");
		assertContains(report.summary(), "kind=transcript_loaded");

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
