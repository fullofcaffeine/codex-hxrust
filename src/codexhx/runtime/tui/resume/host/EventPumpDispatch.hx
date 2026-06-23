package codexhx.runtime.tui.resume.host;

typedef EventPumpDispatchFields = {
	final kind:EventPumpDispatchKind;
	final generation:Int;
	final activeGeneration:Int;
	final sequence:Int;
	final hostEvent:Null<ResumePickerHostEvent>;
	final summary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class EventPumpDispatch {
	@:recordDefault(EventPumpDispatchKind.Unknown)
	public final kind:EventPumpDispatchKind;
	public final generation:Int;
	public final activeGeneration:Int;
	public final sequence:Int;
	public final hostEvent:Null<ResumePickerHostEvent>;
	public final summary:String;

	public function hasHostEvent():Bool {
		return hostEvent != null && hostEvent.kind != ResumePickerHostEventKind.Unknown;
	}
}
