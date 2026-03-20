# Changelog

All notable changes to nerd-dictation-auto-switch-languages will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-20

### Added
- Initial release
- `dictate-start` script with automatic keyboard layout detection
- `dictate-stop` script for stopping dictation
- Support for English (`us`) and Arabic (`ara`) layouts
- Desktop notifications for start/stop events
- Timeout functionality (30 seconds default)
- Verbose logging mode (`--verbose` flag)
- Model installation script (`install-models.sh`)
- One-command setup script (`setup.sh`)
- Comprehensive documentation:
  - Installation guide
  - Model download instructions
  - Keyboard configuration guide
  - Script reference
  - Desktop integration guide
  - Advanced options
  - Troubleshooting guide
- Blog post draft for publication

### Features
- Auto-detect keyboard layout using `xkblayout-state`
- Map layouts to VOSK models automatically
- zenity error dialogs for unsupported layouts
- notify-send notifications for user feedback
- State file tracking for active dictation sessions
- Support for multiple language models
- Graceful error handling

### Dependencies
- nerd-dictation (base tool)
- VOSK (speech recognition)
- xkblayout-state (layout detection)
- zenity (GUI dialogs)
- notify-send (notifications)

---

## [Unreleased]

### Planned
- [ ] Support for Wayland (using wtype instead of xdotool)
- [ ] More language models (French, German, Spanish)
- [ ] GUI configuration tool
- [ ] Auto-language switching during dictation
- [ ] Whisper backend option
- [ ] Custom timeout configuration
- [ ] Per-application language preferences
