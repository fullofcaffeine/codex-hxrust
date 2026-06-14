package codexhx.runtime.asyncruntime;

class AsyncRuntimeContractReport {
	public final schema:String;
	public final caseSummaries:Array<String>;

	public function new(caseSummaries:Array<String>) {
		this.schema = "codex-hxrust.async-runtime-contract-report.v1";
		this.caseSummaries = caseSummaries;
	}

	public function summary():String {
		return "schema=" + schema + ";cases=" + Std.string(caseSummaries.length) + ";summaries=[" + caseSummaries.join("##") + "]";
	}
}
