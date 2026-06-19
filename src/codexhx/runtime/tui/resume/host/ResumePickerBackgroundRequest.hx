package codexhx.runtime.tui.resume.host;

typedef ResumePickerBackgroundRequestFields = {
	final kind:ResumePickerBackgroundRequestKind;
	final page:Null<ResumePickerThreadListRequest>;
	final read:Null<ResumePickerThreadReadRequest>;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerBackgroundRequest {
	@:recordDefault(ResumePickerBackgroundRequestKind.Unknown)
	public final kind:ResumePickerBackgroundRequestKind;
	public final page:Null<ResumePickerThreadListRequest>;
	public final read:Null<ResumePickerThreadReadRequest>;
	public final reason:String;

	public static function pageLoad(request:ResumePickerThreadListRequest):ResumePickerBackgroundRequest {
		return new ResumePickerBackgroundRequest({
			kind: ResumePickerBackgroundRequestKind.Page,
			page: request,
			read: null,
			reason: ""
		});
	}

	public static function previewLoad(request:ResumePickerThreadReadRequest):ResumePickerBackgroundRequest {
		return new ResumePickerBackgroundRequest({
			kind: ResumePickerBackgroundRequestKind.Preview,
			page: null,
			read: request,
			reason: ""
		});
	}

	public static function transcriptLoad(request:ResumePickerThreadReadRequest):ResumePickerBackgroundRequest {
		return new ResumePickerBackgroundRequest({
			kind: ResumePickerBackgroundRequestKind.Transcript,
			page: null,
			read: request,
			reason: ""
		});
	}

	public static function frame(reason:String):ResumePickerBackgroundRequest {
		return new ResumePickerBackgroundRequest({
			kind: ResumePickerBackgroundRequestKind.Frame,
			page: null,
			read: null,
			reason: reason
		});
	}
}
