import codexhx.runtime.tui.resume.live.ResumePickerToolbarFooterRenderGate;

class ResumePickerToolbarFooterRenderHarness {
	static function main():Void {
		final report = ResumePickerToolbarFooterRenderGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("4", Std.string(report.frameRequests), "frame requests");
		assertEquals("4", Std.string(report.renderCount), "render count");
		assertEquals("4", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "toolbar sort=updated_at filter=cwd query=<empty>");
		assertContains(snapshots[0], "toolbar-detail focus=filter mode=wide");
		assertContains(snapshots[0], "footer-hints mode=wide width=96 compact=false keyOnly=false loading=false");
		assertContains(snapshots[1], "toolbar sort=created_at filter=all query=<empty>");
		assertContains(snapshots[1], "toolbar-detail focus=sort mode=compact");
		assertContains(snapshots[1], "footer-hints mode=compact width=44 compact=true keyOnly=false loading=false");
		assertContains(snapshots[2], "toolbar sort=created_at filter=all query=term");
		assertContains(snapshots[2], "footer-hints mode=key-only width=18 compact=true keyOnly=true loading=false");
		assertContains(report.finalSnapshot, "footer-hints mode=loading width=28 compact=true keyOnly=true loading=true");
		assertContains(report.finalSnapshot, "footer loading 66% selected=0 selectedThread=thread-a");

		Sys.println(report.finalSnapshot.split("\n").join("\\n"));
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0)
			throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + " expected " + expected + " but got " + actual;
	}
}
