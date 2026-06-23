package codexhx.runtime.tui.resume.host;

typedef ResumePickerBackgroundRequestFields = {
	final kind:BackgroundRequestKind;
	final page:Null<ResumePickerThreadListRequest>;
	final read:Null<ResumePickerThreadReadRequest>;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerBackgroundRequest {
	@:recordDefault(BackgroundRequestKind.Unknown)
	public final kind:BackgroundRequestKind;
	public final page:Null<ResumePickerThreadListRequest>;
	public final read:Null<ResumePickerThreadReadRequest>;
	public final reason:String;

	public static function pageLoad(request:ResumePickerThreadListRequest):ResumePickerBackgroundRequest {
		return new ResumePickerBackgroundRequest({
			kind: BackgroundRequestKind.Page,
			page: request,
			read: null,
			reason: ""
		});
	}

	public static function previewLoad(request:ResumePickerThreadReadRequest):ResumePickerBackgroundRequest {
		return new ResumePickerBackgroundRequest({
			kind: BackgroundRequestKind.Preview,
			page: null,
			read: request,
			reason: ""
		});
	}

	public static function transcriptLoad(request:ResumePickerThreadReadRequest):ResumePickerBackgroundRequest {
		return new ResumePickerBackgroundRequest({
			kind: BackgroundRequestKind.Transcript,
			page: null,
			read: request,
			reason: ""
		});
	}

	public static function frame(reason:String):ResumePickerBackgroundRequest {
		return new ResumePickerBackgroundRequest({
			kind: BackgroundRequestKind.Frame,
			page: null,
			read: null,
			reason: reason
		});
	}
}
