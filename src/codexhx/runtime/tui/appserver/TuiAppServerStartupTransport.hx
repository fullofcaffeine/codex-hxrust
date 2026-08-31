package codexhx.runtime.tui.appserver;

/** Replaceable transport for the TUI initialize and thread-open handshake. */
interface TuiAppServerStartupTransport {
	function open(request:TuiAppServerStartupRequest):TuiAppServerStartupOutcome;
}
