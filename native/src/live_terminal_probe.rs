use crossterm::event::{self, Event, KeyCode, KeyModifiers};
use crossterm::terminal::{
    disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen,
};
use crossterm::ExecutableCommand;
use ratatui::backend::CrosstermBackend;
use ratatui::layout::{Constraint, Direction, Layout};
use ratatui::widgets::{Block, Borders, Paragraph};
use ratatui::Terminal;
use std::cell::RefCell;
use std::io::{self, IsTerminal, Stdout, Write};
use std::time::Duration;

const STATUS_COMPLETED: i32 = 0;
const STATUS_SKIPPED_NO_TTY: i32 = 1;
const STATUS_SETUP_FAILED: i32 = 2;
const STATUS_DRAW_FAILED: i32 = 3;
const STATUS_RESTORE_FAILED: i32 = 4;
const STATUS_INACTIVE: i32 = 5;

#[derive(Clone, Debug)]
struct ProbeState {
    interactive: bool,
    active: bool,
    setup_attempted: bool,
    draw_attempted: bool,
    restore_attempted: bool,
    restored: bool,
    setup_count: i32,
    draw_count: i32,
    exit_count: i32,
    restore_count: i32,
    last_status: i32,
    last_exit_reason: i32,
    raw_enabled: bool,
    alternate_screen_enabled: bool,
    message: String,
}

impl Default for ProbeState {
    fn default() -> Self {
        Self {
            interactive: false,
            active: false,
            setup_attempted: false,
            draw_attempted: false,
            restore_attempted: false,
            restored: false,
            setup_count: 0,
            draw_count: 0,
            exit_count: 0,
            restore_count: 0,
            last_status: STATUS_INACTIVE,
            last_exit_reason: 0,
            raw_enabled: false,
            alternate_screen_enabled: false,
            message: "live terminal probe inactive".to_string(),
        }
    }
}

thread_local! {
    static TERMINAL: RefCell<Option<Terminal<CrosstermBackend<Stdout>>>> = RefCell::new(None);
    static STATE: RefCell<ProbeState> = RefCell::new(ProbeState::default());
}

pub fn setup_live(_columns: i32, _rows: i32) -> i32 {
    let interactive = io::stdin().is_terminal() && io::stdout().is_terminal();
    TERMINAL.with(|terminal| {
        terminal.borrow_mut().take();
    });
    STATE.with(|state| {
        let mut state = state.borrow_mut();
        *state = ProbeState::default();
        state.interactive = interactive;
        state.setup_attempted = true;
        state.setup_count = 1;
    });

    if !interactive {
        return finish_status(
            STATUS_SKIPPED_NO_TTY,
            false,
            false,
            false,
            "live terminal skipped because stdin/stdout are not TTYs",
        );
    }

    if let Err(err) = enable_raw_mode() {
        return finish_status(
            STATUS_SETUP_FAILED,
            false,
            false,
            false,
            format!("enable raw mode failed: {err}"),
        );
    }
    STATE.with(|state| state.borrow_mut().raw_enabled = true);

    let mut stdout = io::stdout();
    if let Err(err) = stdout.execute(EnterAlternateScreen) {
        restore_partial();
        return finish_status(
            STATUS_SETUP_FAILED,
            false,
            false,
            false,
            format!("enter alternate screen failed: {err}"),
        );
    }
    stdout.flush().ok();
    STATE.with(|state| state.borrow_mut().alternate_screen_enabled = true);

    let backend = CrosstermBackend::new(io::stdout());
    match Terminal::new(backend) {
        Ok(terminal) => {
            TERMINAL.with(|slot| {
                *slot.borrow_mut() = Some(terminal);
            });
            finish_status(
                STATUS_COMPLETED,
                true,
                false,
                false,
                "live terminal setup complete",
            )
        }
        Err(err) => {
            restore_partial();
            finish_status(
                STATUS_SETUP_FAILED,
                false,
                false,
                false,
                format!("terminal creation failed: {err}"),
            )
        }
    }
}

pub fn draw_live(
    title: impl AsRef<str>,
    body: impl AsRef<str>,
    _cursor_row: i32,
    _cursor_column: i32,
) -> i32 {
    STATE.with(|state| {
        let mut state = state.borrow_mut();
        state.draw_attempted = true;
        state.draw_count += 1;
    });

    if !last_interactive() {
        return finish_status(
            STATUS_SKIPPED_NO_TTY,
            false,
            true,
            last_restored(),
            "live terminal draw skipped because stdin/stdout are not TTYs",
        );
    }

    TERMINAL.with(|slot| {
        let mut borrow = slot.borrow_mut();
        let Some(terminal) = borrow.as_mut() else {
            return finish_status(
                STATUS_INACTIVE,
                false,
                true,
                false,
                "live terminal draw requested while inactive",
            );
        };

        let title = title.as_ref().to_string();
        let body = body.as_ref().to_string();
        match terminal.draw(|frame| {
            let chunks = Layout::default()
                .direction(Direction::Vertical)
                .constraints([
                    Constraint::Length(1),
                    Constraint::Min(1),
                    Constraint::Length(1),
                ])
                .split(frame.size());
            let header = Paragraph::new("codex-hxrust live terminal probe");
            frame.render_widget(header, chunks[0]);
            let body =
                Paragraph::new(body).block(Block::default().title(title).borders(Borders::ALL));
            frame.render_widget(body, chunks[1]);
            let footer =
                Paragraph::new("q/Esc/Ctrl-C request exit; restore is automatic in the gate");
            frame.render_widget(footer, chunks[2]);
        }) {
            Ok(_) => finish_status(
                STATUS_COMPLETED,
                true,
                true,
                false,
                "live terminal frame drawn",
            ),
            Err(err) => finish_status(
                STATUS_DRAW_FAILED,
                true,
                true,
                false,
                format!("live terminal draw failed: {err}"),
            ),
        }
    })
}

pub fn poll_live(timeout_ms: i32) -> i32 {
    if !last_interactive() || !last_active() {
        return 0;
    }

    let timeout = Duration::from_millis(timeout_ms.max(0) as u64);
    if !event::poll(timeout).unwrap_or(false) {
        return 0;
    }

    match event::read() {
        Ok(Event::Key(key)) => match key.code {
            KeyCode::Char('q') => 1,
            KeyCode::Esc => 2,
            KeyCode::Char('c') if key.modifiers.contains(KeyModifiers::CONTROL) => 3,
            _ => 0,
        },
        Ok(_) => 0,
        Err(_) => 0,
    }
}

pub fn request_exit(reason: i32) -> i32 {
    STATE.with(|state| {
        let mut state = state.borrow_mut();
        state.exit_count += 1;
        state.last_exit_reason = reason;
    });

    if last_interactive() || last_active() {
        finish_status(
            STATUS_COMPLETED,
            last_active(),
            last_draw_attempted(),
            last_restored(),
            "live terminal exit requested",
        )
    } else {
        finish_status(
            STATUS_SKIPPED_NO_TTY,
            false,
            last_draw_attempted(),
            last_restored(),
            "live terminal exit recorded in headless fallback",
        )
    }
}

pub fn restore_live(_reason: i32) -> i32 {
    STATE.with(|state| {
        let mut state = state.borrow_mut();
        state.restore_attempted = true;
        state.restore_count += 1;
    });

    if !last_interactive() {
        return finish_status(
            STATUS_SKIPPED_NO_TTY,
            false,
            last_draw_attempted(),
            true,
            "live terminal restore skipped because no terminal was taken",
        );
    }

    if restore_partial() {
        finish_status(
            STATUS_COMPLETED,
            false,
            last_draw_attempted(),
            true,
            "live terminal restored",
        )
    } else {
        finish_status(
            STATUS_RESTORE_FAILED,
            false,
            last_draw_attempted(),
            false,
            "live terminal restore failed",
        )
    }
}

pub fn last_status() -> i32 {
    STATE.with(|state| state.borrow().last_status)
}

pub fn is_interactive() -> bool {
    STATE.with(|state| state.borrow().interactive)
}

pub fn is_active() -> bool {
    last_active()
}

pub fn setup_was_attempted() -> bool {
    STATE.with(|state| state.borrow().setup_attempted)
}

pub fn draw_was_attempted() -> bool {
    last_draw_attempted()
}

pub fn restore_was_attempted() -> bool {
    STATE.with(|state| state.borrow().restore_attempted)
}

pub fn was_restored() -> bool {
    last_restored()
}

pub fn setup_count() -> i32 {
    STATE.with(|state| state.borrow().setup_count)
}

pub fn draw_count() -> i32 {
    STATE.with(|state| state.borrow().draw_count)
}

pub fn exit_count() -> i32 {
    STATE.with(|state| state.borrow().exit_count)
}

pub fn restore_count() -> i32 {
    STATE.with(|state| state.borrow().restore_count)
}

pub fn last_exit_reason() -> i32 {
    STATE.with(|state| state.borrow().last_exit_reason)
}

pub fn last_message() -> String {
    STATE.with(|state| state.borrow().message.clone())
}

fn finish_status(
    status: i32,
    active: bool,
    draw_attempted: bool,
    restored: bool,
    message: impl Into<String>,
) -> i32 {
    STATE.with(|state| {
        let mut state = state.borrow_mut();
        state.active = active;
        state.draw_attempted = state.draw_attempted || draw_attempted;
        state.restored = restored;
        state.last_status = status;
        state.message = message.into();
    });
    status
}

fn restore_partial() -> bool {
    let mut ok = true;
    TERMINAL.with(|slot| {
        if let Some(mut terminal) = slot.borrow_mut().take() {
            if terminal.show_cursor().is_err() {
                ok = false;
            }
        }
    });

    let (raw_enabled, alternate_enabled) = STATE.with(|state| {
        let state = state.borrow();
        (state.raw_enabled, state.alternate_screen_enabled)
    });

    if alternate_enabled {
        let mut stdout = io::stdout();
        if stdout.execute(LeaveAlternateScreen).is_err() {
            ok = false;
        }
        if stdout.flush().is_err() {
            ok = false;
        }
    }
    if raw_enabled && disable_raw_mode().is_err() {
        ok = false;
    }

    STATE.with(|state| {
        let mut state = state.borrow_mut();
        state.raw_enabled = false;
        state.alternate_screen_enabled = false;
        state.active = false;
    });
    ok
}

fn last_interactive() -> bool {
    STATE.with(|state| state.borrow().interactive)
}

fn last_active() -> bool {
    STATE.with(|state| state.borrow().active)
}

fn last_draw_attempted() -> bool {
    STATE.with(|state| state.borrow().draw_attempted)
}

fn last_restored() -> bool {
    STATE.with(|state| state.borrow().restored)
}
