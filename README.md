# nerd-dictation++

**Smart Voice Dictation on Linux: Automatically Detect Keyboard Layout**

A wrapper for [nerd-dictation](https://github.com/ideasman42/nerd-dictation) that automatically detects your current keyboard layout and uses the appropriate speech-to-text model. No need to manually switch dictation modes — it figures out whether you're typing in English, Arabic, or any other supported language.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg)
![Desktop](https://img.shields.io/badge/desktop-Cinnamon%20%7C%20GNOME%20%7C%20KDE-orange.svg)

---

## Features

- **🎯 Auto-Detection**: Automatically detects your keyboard layout and selects the correct speech model
- **⚡ Fast**: Press a single shortcut to start dictation in any language
- **🔔 Notifications**: Desktop notifications show which language is active
- **⏱️ Auto-Timeout**: Configurable silence timeout (default: 30 seconds)
- **🛠️ Extensible**: Easy to add support for new languages
- **📝 Detailed Logging**: Verbose mode for debugging

---

## Requirements

| Component | Version | Purpose |
|-----------|---------|---------|
| Linux | Any | Operating system |
| Python | 3.6+ | nerd-dictation runtime |
| xkblayout-state | Latest | Keyboard layout detection |
| zenity | Latest | GUI dialogs |
| vosk | Latest | Speech recognition engine |
| nerd-dictation | Latest | Base dictation tool |

---

## Quick Start

### 1. Run the Setup Script

```bash
cd ~/Desktop/nerd-dictation++/scripts
chmod +x setup.sh
./setup.sh
```

### 2. Download Language Models

```bash
./install-models.sh
```

### 3. Set Up Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super+H` | Start dictation (auto-detects language) |
| `Super+Shift+H` | Stop dictation |

---

## Usage

### Basic Commands

```bash
# Start dictation (detects language automatically)
./dictate-start

# Start with verbose logging
./dictate-start --verbose

# Stop dictation
./dictate-stop
```

### How It Works

1. Press `Super+H` to start dictation
2. The script detects your current keyboard layout
3. Launches the appropriate VOSK model (English, Arabic, etc.)
4. Speak — your words appear on screen
5. Press `Super+Shift+H` to stop

---

## Supported Languages

| Layout | Language | Model Path |
|--------|----------|------------|
| `us` | English | `~/.config/nerd-dictation/model/` |
| `ara` | Arabic | `~/.config/nerd-dictation/model-ar/` |
| `de` | German | `~/.config/nerd-dictation/model-de/` |

> **Note**: Only languages with installed models will work. See [Models Documentation](docs/02-models.md) for installation instructions.

---

## Project Structure

```
nerd-dictation++/
├── README.md              # This file
├── docs/                 # Detailed documentation
│   ├── 01-installation.md
│   ├── 02-models.md
│   ├── 03-configuration.md
│   ├── 04-scripts.md
│   ├── 05-desktop-integration.md
│   ├── 06-advanced.md
│   └── 07-troubleshooting.md
├── scripts/              # Executable scripts
│   ├── setup.sh          # One-command installation
│   ├── install-models.sh  # Model download helper
│   ├── dictate-start     # Smart start script
│   └── dictate-stop      # Smart stop script
├── assets/               # Images and assets
└── blog/                # Blog post draft
```

---

## Documentation

- [Installation Guide](docs/01-installation.md) — Install all prerequisites
- [Downloading Models](docs/02-models.md) — Get speech models for your languages
- [Keyboard Configuration](docs/03-configuration.md) — Set up multi-language keyboards
- [Script Reference](docs/04-scripts.md) — Understand how the scripts work
- [Desktop Integration](docs/05-desktop-integration.md) — Configure shortcuts
- [Advanced Options](docs/06-advanced.md) — Verbose mode, custom timeouts
- [Troubleshooting](docs/07-troubleshooting.md) — Fix common issues

---

## Contributing

Contributions welcome! Please read the documentation and submit a pull request.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [nerd-dictation](https://github.com/ideasman42/nerd-dictation) by ideasman42
- [VOSK](https://alphacephei.com/vosk) by Alpha Cephei
- [xkblayout-state](https://github.com/nonpop/xkblayout-state) by nonpop
