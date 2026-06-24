import codexhx.validation.tui.resume.live.ResumePickerNoCredentialGate;
import codexhx.validation.tui.resume.live.ResumePickerNoCredentialReport;
import sys.FileSystem;

class ResumePickerRenderSnapshotHarness {
	static function main():Void {
		final tempRoot = "generated/tmp/resume-picker-render-snapshot";
		final codexHome = tempRoot + "/codex-home";
		resetTempHome(tempRoot);

		final report = ResumePickerNoCredentialGate.run(codexHome);
		final snapshots = report.renderSnapshots;

		assertEquals("6", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "no rows loaded");
		assertContains(snapshots[1], "> Resume kernel | thread-a");
		assertContains(snapshots[2], "> Host facade | thread-b");
		assertContains(snapshots[3], "overlay loading thread=thread-b message=Loading transcript...");
		assertContains(snapshots[4], "overlay transcript thread=thread-b cells=3");
		assertEquals(expectedFinalSnapshot(), report.finalSnapshot, "final snapshot");
		assertTrue(report.densityPersisted, "density should persist");
		assertContains(report.configText, "session_picker_view = \"dense\"");

		Sys.println(report.finalSnapshot.split("\n").join("\\n"));
	}

	static function expectedFinalSnapshot():String {
		return [
			"resume-picker action=resume density=dense",
			"toolbar sort=updated_at filter=cwd query=<empty>",
			"rows loaded=2 filtered=2 scanned=2 accepted=2 invalid=0",
			"  Resume kernel | thread-a | turns=3 | 2026-06-19T12:00:00Z | cwd=/workspace/codex-hxrust",
			"> Host facade | thread-b | turns=5 | 2026-06-19T12:05:00Z | cwd=/workspace/codex-hxrust",
			"page next=cursor-2 moreBelow=false loadingOlder=false scanCap=false nextPresent=true",
			"overlay transcript thread=thread-b cells=3",
			"footer 100% selected=1 selectedThread=thread-b"
		].join("\n");
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
			throw label + " expected `" + expected + "` but got `" + actual + "`";
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}
}
