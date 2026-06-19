package codexhx.runtime.tui.resume.host;

typedef ResumePickerHostOutcomeFields = {
	final ok:Bool;
	final kind:ResumePickerHostOutcomeKind;
	final code:String;
	final message:String;
	final detail:String;
	final pendingCount:Int;
	final skippedCount:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerHostOutcome {
	public final ok:Bool;
	@:recordDefault(ResumePickerHostOutcomeKind.Unknown)
	public final kind:ResumePickerHostOutcomeKind;
	public final code:String;
	public final message:String;
	public final detail:String;
	public final pendingCount:Int;
	public final skippedCount:Int;

	public static function accepted(detail:String, pendingCount:Int, skippedCount:Int):ResumePickerHostOutcome {
		return new ResumePickerHostOutcome({
			ok: true,
			kind: ResumePickerHostOutcomeKind.Accepted,
			code: "accepted",
			message: "",
			detail: detail,
			pendingCount: pendingCount,
			skippedCount: skippedCount
		});
	}

	public static function scheduled(detail:String, pendingCount:Int, skippedCount:Int):ResumePickerHostOutcome {
		return new ResumePickerHostOutcome({
			ok: true,
			kind: ResumePickerHostOutcomeKind.Scheduled,
			code: "scheduled",
			message: "",
			detail: detail,
			pendingCount: pendingCount,
			skippedCount: skippedCount
		});
	}

	public static function rendered(detail:String, pendingCount:Int, skippedCount:Int):ResumePickerHostOutcome {
		return new ResumePickerHostOutcome({
			ok: true,
			kind: ResumePickerHostOutcomeKind.Rendered,
			code: "rendered",
			message: "",
			detail: detail,
			pendingCount: pendingCount,
			skippedCount: skippedCount
		});
	}

	public static function persisted(detail:String, pendingCount:Int, skippedCount:Int):ResumePickerHostOutcome {
		return new ResumePickerHostOutcome({
			ok: true,
			kind: ResumePickerHostOutcomeKind.Persisted,
			code: "persisted",
			message: "",
			detail: detail,
			pendingCount: pendingCount,
			skippedCount: skippedCount
		});
	}

	public static function failure(code:String, message:String, pendingCount:Int, skippedCount:Int):ResumePickerHostOutcome {
		return new ResumePickerHostOutcome({
			ok: false,
			kind: ResumePickerHostOutcomeKind.Failed,
			code: code,
			message: message,
			detail: "",
			pendingCount: pendingCount,
			skippedCount: skippedCount
		});
	}

	public function summary():String {
		return "ok=" + (ok ? "true" : "false") + ";kind=" + kind + ";code=" + code + ";detail=" + detail + ";pending=" + pendingCount + ";skipped="
			+ skippedCount;
	}
}
