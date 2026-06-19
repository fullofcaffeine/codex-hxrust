package codexhx.runtime.tui.resume.host;

import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;

typedef ResumePickerThreadListRequestFields = {
	final requestId:String;
	final cursor:String;
	final query:String;
	final pageSize:Int;
	final sortKey:ResumePickerSortKey;
	final filterMode:ResumePickerFilterMode;
	final cwdFilter:String;
	final showAll:Bool;
	final includeNonInteractive:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerThreadListRequest {
	public final requestId:String;
	public final cursor:String;
	public final query:String;
	public final pageSize:Int;
	@:recordDefault(ResumePickerSortKey.UpdatedAt)
	public final sortKey:ResumePickerSortKey;
	@:recordDefault(ResumePickerFilterMode.Cwd)
	public final filterMode:ResumePickerFilterMode;
	public final cwdFilter:String;
	public final showAll:Bool;
	public final includeNonInteractive:Bool;

	public function summary():String {
		return "id="
			+ requestId
			+ ";cursor="
			+ cursor
			+ ";query="
			+ query
			+ ";pageSize="
			+ pageSize
			+ ";sort="
			+ sortKey
			+ ";filter="
			+ filterMode;
	}
}
