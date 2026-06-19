import codexhx.protocol.json.CodexJson;
import codexhx.runtime.tui.render.TuiAnsiSanitizer;
import codexhx.runtime.tui.render.TuiGlyphScanner;
import codexhx.runtime.tui.render.TuiHistoryBuffer;
import codexhx.runtime.tui.render.TuiRowBuilder;
import haxe.json.Value;
import sys.io.File;

class TuiRenderHarness {
	static function main():Void {
		final fixture = fixtureRoot();
		basicInsertionNoWrap();
		longTokenWraps(stringField(fixture, "longToken"));
		emojiAndCjk(stringField(fixture, "emojiCjk"));
		mixedAnsiSpans(stringField(fixture, "ansi"));
		cursorRestoration();
		wordWrapNoMidWordSplit(intField(fixture, "wideWidth"), stringField(fixture, "wordWrap"));
		emDashAndSpaceWordWrap(intField(fixture, "wideWidth"), stringField(fixture, "emDashWrap"));
		liveCommitOnOverflow(intField(fixture, "width"), stringArrayField(fixture, "liveRows"));
	}

	static function basicInsertionNoWrap():Void {
		final history = new TuiHistoryBuffer(20);
		history.insertHistoryLines(["first", "second"]);
		assertContains(history.contents(), "first");
		assertContains(history.contents(), "second");
	}

	static function longTokenWraps(long:String):Void {
		final history = new TuiHistoryBuffer(20);
		history.insertHistoryLines([long]);
		assertEquals(Std.string(long.length), Std.string(history.countChar("A")));
	}

	static function emojiAndCjk(text:String):Void {
		final history = new TuiHistoryBuffer(20);
		history.insertHistoryLines([text]);
		final contents = history.contents();
		assertContains(contents, "😀");
		assertContains(contents, "你");
		assertContains(contents, "好");
		assertContains(contents, "世");
		assertContains(contents, "界");
		assertEquals("19", Std.string(TuiGlyphScanner.textWidth(text)));
	}

	static function mixedAnsiSpans(text:String):Void {
		final stripped = TuiAnsiSanitizer.strip(text);
		assertEquals("red+plain", stripped);
		assertFalse(stripped.indexOf("\x1b") >= 0, "sanitized line must not contain raw escape bytes");

		final history = new TuiHistoryBuffer(20);
		history.insertHistoryLines([text]);
		assertContains(history.contents(), "red+plain");
	}

	static function cursorRestoration():Void {
		final history = new TuiHistoryBuffer(20);
		history.insertHistoryLines(["x"]);
		assertEquals("0,0", history.cursorSummary());
	}

	static function wordWrapNoMidWordSplit(width:Int, sample:String):Void {
		final history = new TuiHistoryBuffer(width);
		history.insertHistoryLines([sample]);
		assertNotContains(history.contents(), "bo\nth");
		assertContains(history.contents(), "both");
	}

	static function emDashAndSpaceWordWrap(width:Int, sample:String):Void {
		final history = new TuiHistoryBuffer(width);
		history.insertHistoryLines([sample]);
		assertNotContains(history.contents(), "insi\nde");
		assertContains(history.contents(), "inside");
	}

	static function liveCommitOnOverflow(width:Int, liveRows:Array<String>):Void {
		final builder = new TuiRowBuilder(width);
		for (row in liveRows) {
			builder.pushFragment(row);
		}
		final committed = builder.drainCommitReady(3);
		assertEquals("2", Std.string(committed.length));
		assertEquals("one", committed[0].text);
		assertEquals("two", committed[1].text);

		final live = builder.committedRows();
		assertEquals("3", Std.string(live.length));
		assertEquals("three", live[0].text);
		assertEquals("four", live[1].text);
		assertEquals("five", live[2].text);
	}

	static function fixtureRoot():Value {
		final parsed = CodexJson.parse(File.getContent("fixtures/upstream/vt100-render-selected.v1.json"));
		if (!parsed.ok)
			throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		return parsed.value;
	}

	static function valueField(object:Value, name:String):Value {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name)
						return values[i];
					i = i + 1;
				}
				throw "missing field: " + name;
			case _:
				throw "expected object for field: " + name;
		}
	}

	static function stringField(object:Value, name:String):String {
		return switch valueField(object, name) {
			case JString(value): value;
			case _: throw "expected string field: " + name;
		}
	}

	static function intField(object:Value, name:String):Int {
		return switch valueField(object, name) {
			case JNumber(value): Std.int(value);
			case _: throw "expected int field: " + name;
		}
	}

	static function stringArrayField(object:Value, name:String):Array<String> {
		return switch valueField(object, name) {
			case JArray(values):
				final out:Array<String> = [];
				for (value in values) {
					switch value {
						case JString(text): out.push(text);
						case _: throw "expected string array field: " + name;
					}
				}
				out;
			case _:
				throw "expected array field: " + name;
		}
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected " + expected + " but got " + actual;
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) < 0)
			throw "expected to find " + needle + " in " + haystack;
	}

	static function assertNotContains(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) >= 0)
			throw "did not expect to find " + needle + " in " + haystack;
	}

	static function assertFalse(value:Bool, message:String):Void {
		if (value)
			throw message;
	}
}
