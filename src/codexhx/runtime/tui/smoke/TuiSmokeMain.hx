package codexhx.runtime.tui.smoke;

class TuiSmokeMain {
	public static function main():Void {
		final cases = TuiSmokeFixtureLoader.loadLoops(fixturePath());
		if (cases.length == 0)
			throw "missing TUI smoke loop fixture case";
		final outcome = TuiSmokeEventLoop.run(cases[0]);
		if (!outcome.ok)
			throw outcome.code;
		Sys.println(outcome.snapshot);
	}

	static function fixturePath():String {
		return "fixtures/hxrust/tui-smoke.v1.json";
	}
}
