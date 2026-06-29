import codexhx.runtime.tui.smoke.TuiSmokeFixtureLoader;
import codexhx.runtime.tui.smoke.TuiSmokeEventLoop;
import codexhx.runtime.tui.smoke.TuiSmokeRunner;

class TuiSmokeHarness {
	static final FixturePath = "fixtures/hxrust/tui-smoke.v1.json";

	static function main():Void {
		final cases = TuiSmokeFixtureLoader.load(FixturePath);
		assertEquals("2", Std.string(cases.length));
		for (request in cases) {
			final outcome = TuiSmokeRunner.run(request);
			assertTrue(outcome.ok, request.name + " should render and exit cleanly");
			assertTrue(outcome.terminalRestored, request.name + " should restore terminal facade");
			assertEquals(request.expectedSnapshot, outcome.snapshot);
		}
		final loopCases = TuiSmokeFixtureLoader.loadLoops(FixturePath);
		assertEquals("264", Std.string(loopCases.length));
		for (request in loopCases) {
			final outcome = TuiSmokeEventLoop.run(request);
			if (!outcome.ok)
				throw request.name + " should run app-loop cleanly\ntrace:\n" + outcome.trace + "\nsnapshot:\n" + outcome.snapshot;
			assertTrue(outcome.terminalRestored, request.name + " should restore terminal facade");
			assertEquals(request.expectedTrace, outcome.trace);
			assertEquals(request.expectedSnapshot, outcome.snapshot);
		}
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}
}
