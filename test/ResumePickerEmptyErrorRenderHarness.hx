import codexhx.runtime.tui.resume.live.ResumePickerEmptyErrorRenderGate;

class ResumePickerEmptyErrorRenderHarness {
	static function main():Void {
		final report = ResumePickerEmptyErrorRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("2", Std.string(report.pageLoads), "page loads");
		assertEquals("1", Std.string(report.failures), "failures");
		assertEquals("4", Std.string(report.frameRequests), "frame requests");
		assertEquals("4", Std.string(report.renderCount), "render count");
		assertEquals("4", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "empty: Loading sessions...");
		assertContains(snapshots[1], "empty: No sessions yet");
		assertContains(snapshots[2], "toolbar sort=updated_at filter=cwd query=needle");
		assertContains(snapshots[2], "empty: No results for \"needle\"");
		assertContains(report.finalSnapshot, "empty: Could not load sessions");
		assertContains(report.finalSnapshot, "error code=missing_page_fixture message=no page response for missing-page");
		assertContains(report.finalSnapshot, "footer error selected=0 selectedThread=<empty>");
		assertContains(report.summary(), "failure=missing_page_fixture:no page response for missing-page");

		Sys.println(report.finalSnapshot.split("\n").join("\\n"));
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0) throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual) throw label + " expected " + expected + " but got " + actual;
	}
}
