import codexhx.validation.tui.resume.live.KeyboardNavigationGate;

class ResumePickerKeyboardNavigationRenderHarness {
	static function main():Void {
		final report = KeyboardNavigationGate.run();
		final snapshots = report.renderSnapshots;

		assertEquals("5", Std.string(report.frameRequests), "frame requests");
		assertEquals("5", Std.string(report.renderCount), "render count");
		assertEquals("5", Std.string(snapshots.length), "snapshot count");
		assertContains(snapshots[0], "> Resume kernel | thread-a");
		assertContains(snapshots[1], "> Host facade | thread-b");
		assertContains(snapshots[2], "navigation selected=4 scrollTop=2 viewRows=3 moreAbove=true pageDownCompleted=true");
		assertContains(snapshots[2], "> Navigation renderer | thread-e");
		assertContains(snapshots[2], "page next=<empty> moreBelow=true loadingOlder=false");
		assertContains(snapshots[3], "toolbar sort=updated_at filter=cwd query=kernel");
		assertContains(snapshots[3], "> Preview renderer | thread-c");
		assertContains(report.finalSnapshot, "toolbar sort=updated_at filter=cwd query=<empty>");
		assertContains(report.finalSnapshot, "> Host facade | thread-b");
		assertContains(report.finalSnapshot, "footer start fresh selected=1 selectedThread=thread-b");

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
