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
	final pendingPageRequests:StringMap<ResumePickerThreadListRequest>;
	final pendingReadRequests:StringMap<ResumePickerThreadReadRequest>;
	final requestLog:Array<String>;
	final transportLog:Array<String>;
	var pageRequests:Int;
	var readRequests:Int;

	public function new(queueCapacity:Int) {
		this.transport = new FixtureLiveTransport(queueCapacity);
		this.resultFixtures = new StringMap();
		this.errorFixtures = new StringMap();
		this.pendingPageRequests = new StringMap();
		this.pendingReadRequests = new StringMap();
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

	public function addThreadReadResult(requestId:String, resultJson:String):Void {
		resultFixtures.set(requestId, resultJson);
	}

	public function addThreadReadError(requestId:String, errorJson:String):Void {
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
			task.fail("json_rpc_thread_list_error", errorMessage(errorJson, "thread/list"), false);
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

	public function enqueuePageRequest(request:ResumePickerThreadListRequest):RuntimeClientOutcome {
		pageRequests = pageRequests + 1;
		requestLog.push(threadListRequestFacts(request));
		final accepted = transport.sendRequest(request.requestId, "thread/list", encodeThreadListParams(request));
		transportLog.push("fanout-send:" + outcomeSummary(accepted));
		if (accepted.ok)
			pendingPageRequests.set(request.requestId, request);
		return accepted;
	}

	public function completePageRequest(requestId:String, resultJson:String):ResumePickerHostEvent {
		final completed = transport.completeResponse(requestId, "thread/list", resultJson);
		transportLog.push("fanout-complete:" + outcomeSummary(completed));
		if (!completed.ok) {
			if (completed.code == "completed")
				pendingPageRequests.remove(requestId);
			return ResumePickerHostEvent.failed(requestId, "", "json_rpc_response_rejected", completed.code + ":" + completed.message);
		}
		pendingPageRequests.remove(requestId);
		final response = decodeThreadListResponse(requestId, resultJson);
		if (!response.ok)
			return ResumePickerHostEvent.failed(requestId, "", response.errorCode, response.errorMessage);
		return ResumePickerHostEvent.pageLoaded(response.response);
	}

	public function failPageRequest(requestId:String, errorJson:String):ResumePickerHostEvent {
		final failed = transport.failResponse(requestId, "thread/list", errorJson);
		transportLog.push("fanout-error:" + outcomeSummary(failed));
		if (!failed.ok) {
			if (failed.code == "failed")
				pendingPageRequests.remove(requestId);
			return ResumePickerHostEvent.failed(requestId, "", "json_rpc_response_rejected", failed.code + ":" + failed.message);
		}
		pendingPageRequests.remove(requestId);
		return ResumePickerHostEvent.failed(requestId, "", "json_rpc_thread_list_error", errorMessage(errorJson, "thread/list"));
	}

	public function requestTranscript(request:ResumePickerThreadReadRequest):AsyncTask<ResumePickerThreadReadResponse> {
		readRequests = readRequests + 1;
		requestLog.push(threadReadRequestFacts(request));
		final task = new DeterministicAsyncTask<ResumePickerThreadReadResponse>();
		final paramsJson = encodeThreadReadParams(request);
		final accepted = transport.sendRequest(request.requestId, "thread/read", paramsJson);
		transportLog.push("send:" + outcomeSummary(accepted));
		if (!accepted.ok) {
			task.fail("json_rpc_request_rejected", accepted.code + ":" + accepted.message, false);
			return task;
		}

		final errorJson = errorFixtures.get(request.requestId);
		if (errorJson != null) {
			final failed = transport.failResponse(request.requestId, "thread/read", errorJson);
			transportLog.push("error:" + outcomeSummary(failed));
			task.fail("json_rpc_thread_read_error", errorMessage(errorJson, "thread/read"), false);
			return task;
		}

		final resultJson = resultFixtures.get(request.requestId);
		if (resultJson == null) {
			task.fail("missing_json_rpc_thread_read_fixture", "no JSON-RPC thread/read fixture for " + request.requestId, false);
			return task;
		}

		final completed = transport.completeResponse(request.requestId, "thread/read", resultJson);
		transportLog.push("complete:" + outcomeSummary(completed));
		if (!completed.ok) {
			task.fail("json_rpc_response_rejected", completed.code + ":" + completed.message, false);
			return task;
		}

		final response = decodeThreadReadResponse(request, resultJson);
		if (!response.ok) {
			task.fail(response.errorCode, response.errorMessage, false);
		} else {
			task.complete(response.response);
		}
		return task;
	}

	public function enqueueReadRequest(request:ResumePickerThreadReadRequest):RuntimeClientOutcome {
		readRequests = readRequests + 1;
		requestLog.push(threadReadRequestFacts(request));
		final accepted = transport.sendRequest(request.requestId, "thread/read", encodeThreadReadParams(request));
		transportLog.push("fanout-send:" + outcomeSummary(accepted));
		if (accepted.ok)
			pendingReadRequests.set(request.requestId, request);
		return accepted;
	}

	public function completeReadRequest(requestId:String, resultJson:String):ResumePickerHostEvent {
		final request = pendingReadRequests.get(requestId);
		final threadId = request == null ? "" : request.threadId;
		final completed = transport.completeResponse(requestId, "thread/read", resultJson);
		transportLog.push("fanout-complete:" + outcomeSummary(completed));
		if (!completed.ok) {
			if (completed.code == "completed")
				pendingReadRequests.remove(requestId);
			return ResumePickerHostEvent.failed(requestId, threadId, "json_rpc_response_rejected", completed.code + ":" + completed.message);
		}
		pendingReadRequests.remove(requestId);
		if (request == null)
			return ResumePickerHostEvent.failed(requestId, "", "missing_pending_thread_read_request", "thread/read response has no typed pending request");
		final response = decodeThreadReadResponse(request, resultJson);
		if (!response.ok)
			return ResumePickerHostEvent.failed(requestId, request.threadId, response.errorCode, response.errorMessage);
		return request.previewOnly ? ResumePickerHostEvent.previewLoaded(response.response) : ResumePickerHostEvent.transcriptLoaded(response.response);
	}

	public function failReadRequest(requestId:String, errorJson:String):ResumePickerHostEvent {
		final request = pendingReadRequests.get(requestId);
		final threadId = request == null ? "" : request.threadId;
		final failed = transport.failResponse(requestId, "thread/read", errorJson);
		transportLog.push("fanout-error:" + outcomeSummary(failed));
		if (!failed.ok) {
			if (failed.code == "failed")
				pendingReadRequests.remove(requestId);
			return ResumePickerHostEvent.failed(requestId, threadId, "json_rpc_response_rejected", failed.code + ":" + failed.message);
		}
		pendingReadRequests.remove(requestId);
		return ResumePickerHostEvent.failed(requestId, threadId, "json_rpc_thread_read_error", errorMessage(errorJson, "thread/read"));
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

	static function encodeThreadReadParams(request:ResumePickerThreadReadRequest):String {
		return "{" + "\"threadId\":" + CodexJson.quote(request.threadId) + ",\"includeTurns\":" + boolLabel(request.includeTurns) + "}";
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

	static function decodeThreadReadResponse(request:ResumePickerThreadReadRequest, resultJson:String):JsonRpcThreadReadDecodeOutcome {
		final parsed = CodexJson.parse(resultJson);
		if (!parsed.ok)
			return JsonRpcThreadReadDecodeOutcome.failure(parsed.errorCode, parsed.errorPath, parsed.errorMessage);
		return switch parsed.value {
			case JObject(keys, values):
				final threadIndex = fieldIndex(keys, "thread");
				if (threadIndex < 0)
					return JsonRpcThreadReadDecodeOutcome.failure("missing_field", "$.thread", "required object field is missing");
				switch values[threadIndex] {
					case JObject(_, _):
						decodeThreadReadThread(request, values[threadIndex], "$.thread");
					case _:
						JsonRpcThreadReadDecodeOutcome.failure("expected_object", "$.thread", "expected JSON object");
				}
			case _:
				JsonRpcThreadReadDecodeOutcome.failure("expected_object", "$", "thread/read result must be a JSON object");
		}
	}

	static function decodeThreadReadThread(request:ResumePickerThreadReadRequest, value:Value, path:String):JsonRpcThreadReadDecodeOutcome {
		return switch value {
			case JObject(keys, values):
				final id = requiredString(keys, values, "id", path + ".id");
				if (!id.ok)
					return JsonRpcThreadReadDecodeOutcome.failure(id.errorCode, id.errorPath, id.errorMessage);
				final preview = optionalString(keys, values, "preview", "");
				final turns = optionalArray(keys, values, "turns");
				final previewLines = capLines(splitPreview(preview), request.maxPreviewLines);
				final transcriptCells = request.includeTurns && !request.previewOnly ? decodeTranscriptCells(turns) : [];
				JsonRpcThreadReadDecodeOutcome.success(new ResumePickerThreadReadResponse({
					requestId: request.requestId,
					threadId: id.value,
					previewLines: previewLines,
					transcriptCells: transcriptCells,
					truncated: request.maxPreviewLines > 0 && splitPreview(preview).length > request.maxPreviewLines}));
			case _:
				JsonRpcThreadReadDecodeOutcome.failure("expected_object", path, "thread/read thread must be a JSON object");
		}
	}

	static function decodeTranscriptCells(turns:Array<Value>):Array<String> {
		final cells:Array<String> = [];
		for (turn in turns) {
			switch turn {
				case JObject(keys, values):
					final items = optionalArray(keys, values, "items");
					for (item in items)
						cells.push(decodeThreadItemCell(item));
				case _:
			}
		}
		if (cells.length == 0)
			cells.push("fallback: No transcript content");
		return cells;
	}

	static function decodeThreadItemCell(value:Value):String {
		return switch value {
			case JObject(keys, values):
				final role = transcriptRole(optionalString(keys, values, "role", optionalString(keys, values, "type", "item")));
				final text = optionalString(keys, values, "text", optionalString(keys, values, "summary", decodeUserMessageContent(keys, values)));
				text.length == 0 ? role : role + ": " + text;
			case JString(text):
				"item: " + text;
			case _:
				"item";
		}
	}

	static function transcriptRole(value:String):String {
		return switch value {
			case "userMessage": "user";
			case "agentMessage": "assistant";
			case other: other;
		}
	}

	static function decodeUserMessageContent(keys:Array<String>, values:Array<Value>):String {
		final content = optionalArray(keys, values, "content");
		final parts:Array<String> = [];
		for (entry in content) {
			switch entry {
				case JObject(entryKeys, entryValues):
					final text = optionalString(entryKeys, entryValues, "text", "");
					if (text.length > 0)
						parts.push(text);
				case _:
			}
		}
		return parts.join(" ");
	}

	static function threadListRequestFacts(request:ResumePickerThreadListRequest):String {
		return request.summary() + ";jsonMethod=thread/list" + ";jsonParams=" + encodeThreadListParams(request);
	}

	static function threadReadRequestFacts(request:ResumePickerThreadReadRequest):String {
		return request.summary() + ";jsonMethod=thread/read" + ";jsonParams=" + encodeThreadReadParams(request);
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return "ok=" + boolLabel(outcome.ok) + ";code=" + outcome.code + ";request=" + outcome.requestId + ";method=" + outcome.method + ";pending="
			+ outcome.pendingCount + ";message=" + outcome.message;
	}

	static function errorMessage(errorJson:String, method:String):String {
		final parsed = CodexJson.parse(errorJson);
		if (!parsed.ok)
			return parsed.errorCode + ":" + parsed.errorMessage;
		return switch parsed.value {
			case JObject(keys, values):
				final code = optionalNumber(keys, values, "code", 0);
				final message = optionalString(keys, values, "message", "JSON-RPC " + method + " error");
				Std.string(code) + ":" + message;
			case _:
				"JSON-RPC " + method + " error";
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

	static function optionalArray(keys:Array<String>, values:Array<Value>, name:String):Array<Value> {
		final i = fieldIndex(keys, name);
		if (i < 0)
			return [];
		return switch values[i] {
			case JArray(entries): entries;
			case _: [];
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

	static function splitPreview(preview:String):Array<String> {
		final lines:Array<String> = [];
		for (line in preview.split("\n")) {
			final trimmed = StringTools.trim(line);
			if (trimmed.length > 0)
				lines.push(trimmed);
		}
		return lines;
	}

	static function capLines(lines:Array<String>, maxLines:Int):Array<String> {
		if (maxLines <= 0 || lines.length <= maxLines)
			return lines.copy();
		return lines.slice(0, maxLines);
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

class JsonRpcThreadReadDecodeOutcome {
	public final ok:Bool;
	public final response:ResumePickerThreadReadResponse;
	public final errorCode:String;
	public final errorPath:String;
	public final errorMessage:String;

	function new(ok:Bool, response:ResumePickerThreadReadResponse, errorCode:String, errorPath:String, errorMessage:String) {
		this.ok = ok;
		this.response = response;
		this.errorCode = errorCode;
		this.errorPath = errorPath;
		this.errorMessage = errorMessage;
	}

	public static function success(response:ResumePickerThreadReadResponse):JsonRpcThreadReadDecodeOutcome {
		return new JsonRpcThreadReadDecodeOutcome(true, response, "", "", "");
	}

	public static function failure(code:String, path:String, message:String):JsonRpcThreadReadDecodeOutcome {
		return new JsonRpcThreadReadDecodeOutcome(false, null, code, path, message);
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
