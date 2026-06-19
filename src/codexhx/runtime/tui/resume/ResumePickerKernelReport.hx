package codexhx.runtime.tui.resume;

class ResumePickerKernelReport {
	public final planCount:Int;
	public final commandCount:Int;
	public final pageRequests:Int;
	public final previewRequests:Int;
	public final transcriptRequests:Int;
	public final frameRequests:Int;
	public final persistDensityRequests:Int;
	public final overlayOpenRequests:Int;
	public final loadMoreRequests:Int;
	public final startFreshRequests:Int;
	public final errorSurfaces:Int;
	public final finalState:ResumePickerState;

	public function new(planCount:Int, finalState:ResumePickerState) {
		this.planCount = planCount;
		this.commandCount = finalState.commandCount;
		this.pageRequests = finalState.countEffect(ResumePickerEffectKind.RequestPage);
		this.previewRequests = finalState.countEffect(ResumePickerEffectKind.RequestPreview);
		this.transcriptRequests = finalState.countEffect(ResumePickerEffectKind.RequestTranscript);
		this.frameRequests = finalState.countEffect(ResumePickerEffectKind.RequestFrame);
		this.persistDensityRequests = finalState.countEffect(ResumePickerEffectKind.PersistDensity);
		this.overlayOpenRequests = finalState.countEffect(ResumePickerEffectKind.OpenTranscriptOverlay);
		this.loadMoreRequests = finalState.countEffect(ResumePickerEffectKind.LoadMore);
		this.startFreshRequests = finalState.countEffect(ResumePickerEffectKind.StartFresh);
		this.errorSurfaces = finalState.countEffect(ResumePickerEffectKind.SurfaceError);
		this.finalState = finalState;
	}

	public function summary():String {
		return "plans=" + planCount + ";commands=" + commandCount + ";page=" + pageRequests + ";preview=" + previewRequests + ";transcript="
			+ transcriptRequests + ";frames=" + frameRequests + ";persist=" + persistDensityRequests + ";overlay=" + overlayOpenRequests + ";load_more="
			+ loadMoreRequests + ";start_fresh=" + startFreshRequests + ";errors=" + errorSurfaces + ";final=" + finalState.summary();
	}
}
