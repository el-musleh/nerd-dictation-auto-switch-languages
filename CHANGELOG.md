# Changelog

All notable changes to nerd-dictation-auto-switch-languages.

---

## [2.0.0] — 2026-04-26

### Fresh-install hardening, GPU support, PipeWire support

#### `scripts/setup.sh`
- Added `x11-utils` (Ubuntu/Debian), `xprop` (Fedora), `xorg-xprop` (Arch) — provides the `xprop` binary required by terminal-window detection
- Added `pulseaudio-utils` (Ubuntu/Debian/Fedora), `pulseaudio` (Arch) — provides `parec` for audio recording
- Added `numpy` to pip install (was an implicit transitive dependency; now explicit to prevent import errors)
- Added post-install audio tool availability check: reports which of `parec`, `pw-cat`, `sox` is available, or shows a clear error with fix instructions for PipeWire-only systems
- Added error handling around the `xkblayout-state` build: separate error messages for clone failure and make failure, with `libx11-dev` hint
- Added error handling around Whisper model pre-download: shows retry command on failure instead of silently passing
- Added permission verification after `chmod +x` on installed scripts
- Fixed Whisper model size shown in prompt: was `~460 MB`, correct size is `~244 MB`

#### `scripts/dictate-start`
- Added auto-detection of audio recording tool at startup: tries `parec` → `pw-cat` → `sox`; exits with a clear error if none found — fixes silent failure on PipeWire-only systems
- Added auto-detection of GPU via `nvidia-smi`: sets `--whisper-device cuda` if an NVIDIA GPU is present, `cpu` otherwise
- Added `--whisper-device "$WHISPER_DEVICE"` to the Whisper launch command — enables GPU acceleration without editing the script
- Added `--input "$INPUT_METHOD"` to both VOSK and Whisper launch commands — passes detected audio tool explicitly
- Improved error message for missing `nerd-dictation` binary: hints to run `setup.sh`
- Improved startup log line: now includes input method alongside engine and timeout

#### `scripts/dictate-stop`
- Added `ENGINE` default: if the field is absent from the state file (written by an older install), `ENGINE` defaults to `VOSK` — prevents the wait logic from breaking on upgrade

#### `scripts/install-models.sh`
- Removed VOSK Arabic models (`ar-small`: `vosk-model-ar-mgb2-0.4`, `ar-large`: `vosk-model-ar-0.22-linto-1.1.0`) — Arabic uses Whisper, not VOSK; listing these was misleading
- Added header note explaining Arabic uses Whisper (auto-downloaded) and this script is VOSK-only
- Fixed menu ordering: models now display in a consistent order (`en-small`, `en-large`, `de`, `fr`, `es`, `ru`, `zh`) using an ordered array instead of hash-map iteration
- Fixed index-to-key mapping: hash iteration produced non-deterministic menu numbers; now stable

#### `docs/01-installation.md`
- Rewrote manual installation section to match current architecture
- Corrected system dependency lists for all three distros (added `xsel`, `x11-utils`/`xprop`, `pulseaudio-utils`)
- Added table explaining why each package is needed
- Replaced "clone upstream nerd-dictation" step with "copy patched nerd-dictation from repo" — the upstream version lacks Whisper support
- Removed VOSK Arabic model download step — Arabic uses Whisper, no model directory needed
- Added `numpy` to pip install command
- Updated verification section with correct expected notifications for both languages

#### `docs/03-configuration.md`
- Removed `model-ar/` from the layout→engine table — Arabic does not use a VOSK model directory
- Updated "Adding a New Layout" code example to show the correct Arabic Whisper case alongside a VOSK example
- Added note clarifying the difference between Whisper-based and VOSK-based layout entries

---

## [1.1.0] — 2026-04-25

### Arabic dictation rewrite: Whisper engine, clipboard output, reliable stop

This release replaced the VOSK Arabic backend with Whisper and fixed all Arabic output issues.

#### Before → After

| Area | Before | After |
|------|--------|-------|
| Arabic accuracy | VOSK (`vosk-model-ar-mgb2-0.4`) — poor recognition, frequent misses | Whisper `small` via `faster-whisper` — dramatically better, handles dialects |
| Arabic output | `xdotool type` — silently dropped all RTL characters; nothing appeared | `xsel` clipboard + smart paste key — text reliably appears |
| Terminal paste | `Ctrl+V` for all windows — does not paste in GNOME Terminal | Detects terminal via `xprop WM_CLASS`; uses `Ctrl+Shift+V` for terminals, `Ctrl+V` for GUI apps |
| Stop behaviour | `SIGTERM` sent to PID before `nerd-dictation end` — killed Whisper before transcription; 100% text loss | Signals `nerd-dictation end` first, waits up to 30 s for process to exit, force-kills only on timeout |
| Ready signal | "Dictation Started" fired from bash immediately — users spoke before model loaded | Bash shows "Dictation Loading"; Python fires "Dictation Ready" after model loads and recording starts |
| State file | No `ENGINE` field | Writes `ENGINE:WHISPER` or `ENGINE:VOSK`; `dictate-stop` uses it to decide wait strategy |
| Fresh install | `setup.sh` cloned upstream nerd-dictation (no Whisper support) | Patched `nerd-dictation` included in repo; `setup.sh` copies it |

#### Files changed

- **`scripts/nerd-dictation`** (new file in repo) — Patched version adding:
  - `text_from_whisper_pipe()` — Whisper recording and transcription pipeline (16 kHz, int8/float16, VAD filter, RMS silence detection)
  - `simulate_typing_with_clipboard()` — xsel clipboard paste with terminal-aware key selection
  - `_active_window_is_terminal()` — reads `WM_CLASS` via `xprop` to detect terminal windows
  - `_is_arabic_text()` — detects Arabic Unicode (U+0600–U+06FF) to skip incorrect English capitalisation
  - CLI args: `--engine {VOSK,WHISPER}`, `--whisper-model`, `--whisper-device {cpu,cuda}`, `--language`
  - `CLIPBOARD` added as a valid `--simulate-input-tool` option
- **`scripts/dictate-start`** — Arabic routes to Whisper; logs to `/tmp/nerd-dictation-ar.log`; two-notification flow; writes `ENGINE` to state file
- **`scripts/dictate-stop`** — Reversed stop order: signal → wait → force-kill
- **`scripts/setup.sh`** — Installs `xsel` and `faster-whisper`; copies patched `nerd-dictation` from repo; offers Whisper model pre-download; removed VOSK Arabic model step
- **`docs/02-models.md`** — Documents Whisper for Arabic, VOSK for English; Whisper model size/speed table; no `model-ar/` directory
- **`docs/07-troubleshooting.md`** — Arabic log path, transcript-present-but-no-output diagnosis, terminal paste explanation, `faster-whisper`/`xsel` install commands

---

## [1.0.0] — 2026-03-20

### Initial release

- `dictate-start` script with automatic keyboard layout detection via `xkblayout-state`
- `dictate-stop` script
- English (`us`) → VOSK and Arabic (`ara`) → VOSK (later replaced by Whisper in 1.1.0)
- Desktop notifications, 30-second timeout, verbose logging
- `install-models.sh`, `setup.sh`
- Full documentation suite (installation, models, configuration, desktop integration, advanced, troubleshooting)
