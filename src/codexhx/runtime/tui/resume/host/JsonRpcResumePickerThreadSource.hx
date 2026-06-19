package codexhx.runtime.tui.resume.host;

import codexhx.protocol.json.CodexJson;
import codexhx.runtime.app.RuntimeClientOutcome;
import codexhx.runtime.app.transport.FixtureLiveTransport;
import codexhx.runtime.asyncruntime.AsyncTask;
import codexhx.runtime.asyncruntime.DeterministicAsyncTask;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import haxe.ds.StringMap;
import haxe.json.Value;

class JsonRpcResumePickerThreadSource implements ResumePickerAppServerThreadSource {
	final transport:FixtureLiveTransport;
	final resultFixtures:StringMap<String>;
	final errorFixtures:StringMap<String>;
	final requestLog:Array<String>;
	final transportLog:Array<String>;
	var pageRequests:Int;
	var readRequests:Int;

	public function new(queueCapacity:Int) {
		this.transport = new FixtureLiveTransport(queueCapacity);
		this.resultFixtures = new StringMap();
		this.errorFixtures = new StringMap();
		this.requestLog = [];
		this.transportLog = [];
		this.pageRequests = 0;
		this.readRequests = 0;
	}

	public function addThreadListResult(requestId:String, resultJson:String):Void {
		resultFixtures.set(requestId, resultJson);
	}

	public function addThreadListError(requestId:String, errorJson:String):Void {
		errorFixtures.set(requestId, errorJson);
	}

	public function requestPage(request:ResumePickerThreadListRequest):AsyncTask<ResumePickerThreadListResponse> {
		pageRequests = pageRequests + 1;
		requestLog.push(threadListRequestFacts(request));
		final task = new DeterministicAsyncTask<ResumePickerThreadListResponse>();
		final paramsJson = encodeThreadListParams(request);
		final accepted = transport.sendRequest(request.requestId, "thread/list", paramsJson);
		transportLog.push("send:" + outcomeSummary(accepted));
		if (!accepted.ok) {
			task.fail("json_rpc_request_rejected", accepted.code + ":" + accepted.message, false);
			return task;
		}

		final errorJson = errorFixtures.get(request.requestId);
		if (errorJson != null) {
			final failed = transport.failResponse(request.requestId, "thread/list", errorJson);
			transportLog.push("error:" + outcomeSummary(failed));
			task.fail("json_rpc_thread_list_error", errorMessage(errorJson), false);
			return task;
		}

		final resultJson = resultFixtures.get(request.requestId);
		if (resultJson == null) {
			task.fail("missing_json_rpc_thread_list_fixture", "no JSON-RPC thread/list fixture for " + request.requestId, false);
			return task;
		}

		final completed = transport.completeResponse(request.requestId, "thread/list", resultJson);
		transportLog.push("complete:" + outcomeSummary(completed));
		if (!completed.ok) {
			task.fail("json_rpc_response_rejected", completed.code + ":" + completed.message, false);
			return task;
		}

		final response = decodeThreadListResponse(request.requestId, resultJson);
		if (!response.ok) {
			task.fail(response.errorCode, response.errorMessage, false);
		} else {
			task.complete(response.response);
		}
		return task;
	}

	public function requestTranscript(request:ResumePickerThreadReadRequest):AsyncTask<ResumePickerThreadReadResponse> {
		readRequests = readRequests + 1;
		final task = new DeterministicAsyncTask<ResumePickerThreadReadResponse>();
		task.fail("unsupported_json_rpc_thread_read_fixture",
			"JSON-RPC resume picker source currently supports thread/list only; request="
			+ request.requestId
			+ ";thread="
			+ request.threadId, false);
		return task;
	}

	public function pageRequestCount():Int {
		return pageRequests;
	}

	public function readRequestCount():Int {
		return readRequests;
	}

	public function requestSummaries():Array<String> {
		return requestLog.copy();
	}

	public function transportSummaries():Array<String> {
		return transportLog.copy();
	}

	public function drainedEventSummaries():Array<String> {
		return transport.drainEventSummaries();
	}

	public function pendingTransportRequests():Int {
		return transport.pendingCount();
	}

	static function encodeThreadListParams(request:ResumePickerThreadListRequest):String {
		final archived = request.showAll ? "null" : "false";
		final cursor = nullableString(request.cursor);
		final searchTerm = nullableString(request.query);
		final cwd = request.filterMode == ResumePickerFilterMode.Cwd
			&& request.cwdFilter.length > 0 ? "[" + CodexJson.quote(request.cwdFilter) + "]" : "null";
		final sourceKinds = request.includeNonInteractive ? "[\"cli\",\"appServer\",\"subAgent\"]" : "[\"cli\",\"appServer\"]";
		return "{" + "\"archived\":" + archived + ",\"cursor\":" + cursor + ",\"limit\":" + request.pageSize + ",\"searchTerm\":" + searchTerm
			+ ",\"sortDirection\":\"desc\"" + ",\"sortKey\":" + CodexJson.quote(Std.string(request.sortKey)) + ",\"cwd\":" + cwd + ",\"sourceKinds\":"
			+ sourceKinds + ",\"useStateDbOnly\":false" + "}";
	}

	static function decodeThreadListResponse(requestId:String, resultJson:String):JsonRpcThreadListDecodeOutcome {
		final parsed = CodexJson.parse(resultJson);
		if (!parsed.ok)
			return JsonRpcThreadListDecodeOutcome.failure(parsed.errorCode, parsed.errorPath, parsed.errorMessage);
		return switch parsed.value {
			case JObject(keys, values):
				final data = arrayField(keys, values, "data", "$.data");
				if (!data.ok)
					return JsonRpcThreadListDecodeOutcome.failure(data.errorCode, data.errorPath, data.errorMessage);
				final rows:Array<ResumePickerThreadRow> = [];
				var i = 0;
				while (i < data.values.length) {
					final row = decodeThreadRow(data.values[i], "$.data[" + Std.string(i) + "]");
					if (!row.ok)
						return JsonRpcThreadListDecodeOutcome.failure(row.errorCode, row.errorPath, row.errorMessage);
					rows.push(row.row);
					i = i + 1;
				}
				final nextCursor = nullableStringField(keys, values, "nextCursor");
				JsonRpcThreadListDecodeOutcome.success(new ResumePickerThreadListResponse({
					requestId: requestId,
					rows: rows,
					nextCursor: nextCursor,
					scannedRows: rows.length,
					acceptedRows: rows.length,
					invalidRows: 0,
					reachedScanCap: false
				}));
			case _:
				JsonRpcThreadListDecodeOutcome.failure("expected_object", "$", "thread/list result must be a JSON object");
		}
	}

	static function decodeThreadRow(value:Value, path:String):JsonRpcThreadRowDecodeOutcome {
		return switch value {
			case JObject(keys, values):
				final id = requiredString(keys, values, "id", path + ".id");
				if (!id.ok)
					return JsonRpcThreadRowDecodeOutcome.failure(id.errorCode, id.errorPath, id.errorMessage);
				final turns = arrayField(keys, values, "turns", path + ".turns");
				if (!turns.ok)
					return JsonRpcThreadRowDecodeOutcome.failure(turns.errorCode, turns.errorPath, turns.errorMessage);
				JsonRpcThreadRowDecodeOutcome.success(new ResumePickerThreadRow({
					threadId: id.value,
					title: optionalString(keys, values, "title", id.value),
					cwd: optionalString(keys, values, "cwd", ""),
					updatedAt: optionalString(keys, values, "updatedAt", ""),
					archived: optionalBool(keys, values, "archived", false),
					turnCount: turns.values.length
				}));
			case _:
				JsonRpcThreadRowDecodeOutcome.failure("expected_object", path, "thread/list data entry must be a JSON object");
		}
	}

	static function threadListRequestFacts(request:ResumePickerThreadListRequest):String {
		return request.summary() + ";jsonMethod=thread/list" + ";jsonParams=" + encodeThreadListParams(request);
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return "ok=" + boolLabel(outcome.ok) + ";code=" + outcome.code + ";request=" + outcome.requestId + ";method=" + outcome.method + ";pending="
			+ outcome.pendingCount + ";message=" + outcome.message;
	}

	static function errorMessage(errorJson:String):String {
		final parsed = CodexJson.parse(errorJson);
		if (!parsed.ok)
			return parsed.errorCode + ":" + parsed.errorMessage;
		return switch parsed.value {
			case JObject(keys, values):
				final code = optionalNumber(keys, values, "code", 0);
				final message = optionalString(keys, values, "message", "JSON-RPC thread/list error");
				Std.string(code) + ":" + message;
			case _:
				"JSON-RPC thread/list error";
		}
	}

	static function requiredString(keys:Array<String>, values:Array<Value>, name:String, path:String):JsonRpcStringDecodeOutcome {
		final i = fieldIndex(keys, name);
		if (i < 0)
			return JsonRpcStringDecodeOutcome.failure("missing_field", path, "required field is missing");
		return switch values[i] {
			case JString(value): JsonRpcStringDecodeOutcome.success(value);
			case _: JsonRpcStringDecodeOutcome.failure("expected_string", path, "expected JSON string");
		}
	}

	static function arrayField(keys:Array<String>, values:Array<Value>, name:String, path:String):JsonRpcArrayDecodeOutcome {
		final i = fieldIndex(keys, name);
		if (i < 0)
			return JsonRpcArrayDecodeOutcome.failure("missing_field", path, "required array field is missing");
		return switch values[i] {
			case JArray(entries): JsonRpcArrayDecodeOutcome.success(entries);
			case _: JsonRpcArrayDecodeOutcome.failure("expected_array", path, "expected JSON array");
		}
	}

	static function nullableStringField(keys:Array<String>, values:Array<Value>, name:String):String {
		final i = fieldIndex(keys, name);
		if (i < 0)
			return "";
		return switch values[i] {
			case JString(value): value;
			case _: "";
		}
	}

	static function optionalString(keys:Array<String>, values:Array<Value>, name:String, fallback:String):String {
		final i = fieldIndex(keys, name);
		if (i < 0)
			return fallback;
		return switch values[i] {
			case JString(value): value;
			case _: fallback;
		}
	}

	static function optionalBool(keys:Array<String>, values:Array<Value>, name:String, fallback:Bool):Bool {
		final i = fieldIndex(keys, name);
		if (i < 0)
			return fallback;
		return switch values[i] {
			case JBool(value): value;
			case _: fallback;
		}
	}

	static function optionalNumber(keys:Array<String>, values:Array<Value>, name:String, fallback:Int):Int {
		final i = fieldIndex(keys, name);
		if (i < 0)
			return fallback;
		return switch values[i] {
			case JNumber(value): Std.int(value);
			case _: fallback;
		}
	}

	static function nullableString(value:String):String {
		return value.length == 0 ? "null" : CodexJson.quote(value);
	}

	static function fieldIndex(keys:Array<String>, name:String):Int {
		var i = 0;
		while (i < keys.length) {
			if (keys[i] == name)
				return i;
			i = i + 1;
		}
		return -1;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}

class JsonRpcThreadListDecodeOutcome {
	public final ok:Bool;
	public final response:ResumePickerThreadListResponse;
	public final errorCode:String;
	public final errorPath:String;
	public final errorMessage:String;

	function new(ok:Bool, response:ResumePickerThreadListResponse, errorCode:String, errorPath:String, errorMessage:String) {
		this.ok = ok;
		this.response = response;
		this.errorCode = errorCode;
		this.errorPath = errorPath;
		this.errorMessage = errorMessage;
	}

	public static function success(response:ResumePickerThreadListResponse):JsonRpcThreadListDecodeOutcome {
		return new JsonRpcThreadListDecodeOutcome(true, response, "", "", "");
	}

	public static function failure(code:String, path:String, message:String):JsonRpcThreadListDecodeOutcome {
		return new JsonRpcThreadListDecodeOutcome(false, null, code, path, message);
	}
}

class JsonRpcThreadRowDecodeOutcome {
	public final ok:Bool;
	public final row:ResumePickerThreadRow;
	public final errorCode:String;
	public final errorPath:String;
	public final errorMessage:String;

	function new(ok:Bool, row:ResumePickerThreadRow, errorCode:String, errorPath:String, errorMessage:String) {
		this.ok = ok;
		this.row = row;
		this.errorCode = errorCode;
		this.errorPath = errorPath;
		this.errorMessage = errorMessage;
	}

	public static function success(row:ResumePickerThreadRow):JsonRpcThreadRowDecodeOutcome {
		return new JsonRpcThreadRowDecodeOutcome(true, row, "", "", "");
	}

	public static function failure(code:String, path:String, message:String):JsonRpcThreadRowDecodeOutcome {
		return new JsonRpcThreadRowDecodeOutcome(false, null, code, path, message);
	}
}

class JsonRpcStringDecodeOutcome {
	public final ok:Bool;
	public final value:String;
	public final errorCode:String;
	public final errorPath:String;
	public final errorMessage:String;

	function new(ok:Bool, value:String, errorCode:String, errorPath:String, errorMessage:String) {
		this.ok = ok;
		this.value = value;
		this.errorCode = errorCode;
		this.errorPath = errorPath;
		this.errorMessage = errorMessage;
	}

	public static function success(value:String):JsonRpcStringDecodeOutcome {
		return new JsonRpcStringDecodeOutcome(true, value, "", "", "");
	}

	public static function failure(code:String, path:String, message:String):JsonRpcStringDecodeOutcome {
		return new JsonRpcStringDecodeOutcome(false, "", code, path, message);
	}
}

class JsonRpcArrayDecodeOutcome {
	public final ok:Bool;
	public final values:Array<Value>;
	public final errorCode:String;
	public final errorPath:String;
	public final errorMessage:String;

	function new(ok:Bool, values:Array<Value>, errorCode:String, errorPath:String, errorMessage:String) {
		this.ok = ok;
		this.values = values;
		this.errorCode = errorCode;
		this.errorPath = errorPath;
		this.errorMessage = errorMessage;
	}

	public static function success(values:Array<Value>):JsonRpcArrayDecodeOutcome {
		return new JsonRpcArrayDecodeOutcome(true, values, "", "", "");
	}

	public static function failure(code:String, path:String, message:String):JsonRpcArrayDecodeOutcome {
		return new JsonRpcArrayDecodeOutcome(false, [], code, path, message);
	}
}
