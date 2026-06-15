package codexhx.runtime.model.streamitem;

typedef ModelBacktrackTranscriptCellFields = {
	final cellKind:ModelBacktrackTranscriptCellKind;
	final message:String;
	final textElementCount:Int;
	final localImageCount:Int;
	final remoteImageCount:Int;
	final localImagePath:String;
	final remoteImageUrl:String;
}

class ModelBacktrackTranscriptCell {
	public final cellKind:ModelBacktrackTranscriptCellKind;
	public final message:String;
	public final textElementCount:Int;
	public final localImageCount:Int;
	public final remoteImageCount:Int;
	public final localImagePath:String;
	public final remoteImageUrl:String;

	public function new(fields:ModelBacktrackTranscriptCellFields) {
		this.cellKind = fields.cellKind == null ? ModelBacktrackTranscriptCellKind.Agent : fields.cellKind;
		this.message = fields.message == null ? "" : fields.message;
		this.textElementCount = fields.textElementCount;
		this.localImageCount = fields.localImageCount;
		this.remoteImageCount = fields.remoteImageCount;
		this.localImagePath = fields.localImagePath == null ? "" : fields.localImagePath;
		this.remoteImageUrl = fields.remoteImageUrl == null ? "" : fields.remoteImageUrl;
	}
}
