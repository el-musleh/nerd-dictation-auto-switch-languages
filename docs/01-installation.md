# Installation Guide

Complete step-by-step installation instructions for nerd-dictation++.

---

## Prerequisites

Before installing, ensure you have:

- **Linux OS** (Ubuntu, Linux Mint, Fedora, etc.)
- **Python 3.6 or higher**
- **Internet connection** (for downloading models)
- **Microphone** 🎤

---

## Step 1: Install System Dependencies

### For Ubuntu/Debian/Linux Mint:

```bash
sudo apt update
sudo apt install -y \
    python3-pip \
    xdotool \
    zenity \
    libnotify-bin \
    wget \
    unzip
```

### For Fedora:

```bash
sudo dnf install -y \
    python3-pip \
    xdotool \
    zenity \
    libnotify \
    wget \
    unzip
```

### For Arch/Manjaro:

```bash
sudo pacman -S --noconfirm \
    python-pip \
    xdotool \
    zenity \
    libnotify \
    wget \
    unzip
```

---

## Step 2: Install xkblayout-state

This tool detects your current keyboard layout.

### Ubuntu/Debian:

```bash
# Clone and install
git clone https://github.com/nonpop/xkblayout-state.git
cd xkblayout-state
make
sudo make install
```

### Verify Installation:

```bash
xkblayout-state print "%s"
# Should output: us (or your current layout)
```

---

## Step 3: Install VOSK

```bash
pip install vosk
```

> **Note**: If you encounter "externally managed environment" error:
> ```bash
> pip install vosk --break-system-packages
> ```
> Or use pipx:
> ```bash
> pipx install vosk
> ```

---

## Step 4: Install nerd-dictation

```bash
# Clone the repository
git clone https://github.com/ideasman42/nerd-dictation.git ~/nerd-dictation

# Make it executable
chmod +x ~/nerd-dictation/nerd-dictation
```

---

## Step 5: Download Language Models

### English (Required)

```bash
mkdir -p ~/.config/nerd-dictation
cd ~/.config/nerd-dictation

# Download English model (~40MB)
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip
mv vosk-model-small-en-us-0.15 model
```

### Arabic (Optional)

```bash
cd ~/.config/nerd-dictation
wget https://alphacephei.com/vosk/models/vosk-model-ar-mgb2-0.4.zip
unzip vosk-model-ar-mgb2-0.4.zip
mv vosk-model-ar-mgb2-0.4 model-ar
```

---

## Step 6: Copy nerd-dictation++ Scripts

```bash
# Copy scripts to nerd-dictation folder
cp ~/Desktop/nerd-dictation++/scripts/dictate-start ~/nerd-dictation/
cp ~/Desktop/nerd-dictation++/scripts/dictate-stop ~/nerd-dictation/

# Make them executable
chmod +x ~/nerd-dictation/dictate-start
chmod +x ~/nerd-dictation/dictate-stop
```

---

## Step 7: Configure Keyboard Layouts

Your keyboard layouts must be set up in your desktop environment.

### For Cinnamon (Linux Mint):

1. Open **System Settings → Keyboard**
2. Go to **Layouts**
3. Add the layouts you need (e.g., English, Arabic)
4. Note the layout codes:
   - `us` = English (US)
   - `ara` = Arabic
   - `de` = German

### Verify Layouts:

```bash
xkblayout-state print "%s(%e)"
# Output example: us(us)%
```

---

## Step 8: Set Up Keyboard Shortcuts

See [Desktop Integration Guide](05-desktop-integration.md) for detailed instructions.

### Quick Setup:

1. **System Settings → Keyboard → Shortcuts → Custom Shortcuts**
2. Click **+ Add Custom Shortcut**
3. Set up:

| Name | Command | Shortcut |
|------|---------|----------|
| Start Dictation | `~/nerd-dictation/dictate-start` | `Super+H` |
| Stop Dictation | `~/nerd-dictation/dictate-stop` | `Super+Shift+H` |

---

## Automated Installation

Instead of following all steps manually, run:

```bash
cd ~/Desktop/nerd-dictation++/scripts
chmod +x setup.sh
./setup.sh
```

This will:
- Install all system dependencies
- Install xkblayout-state
- Install VOSK
- Clone nerd-dictation
- Download English and Arabic models

---

## Verification

Test your installation:

```bash
# Set English keyboard layout
setxkbmap us

# Start dictation
~/nerd-dictation/dictate-start

# You should see a notification: "English dictation is now listening..."
```

---

## Next Steps

- [Download Additional Models](02-models.md)
- [Configure Keyboard Layouts](03-configuration.md)
- [Set Up Desktop Integration](05-desktop-integration.md)

---

## Troubleshooting

See [Troubleshooting Guide](07-troubleshooting.md) if you encounter issues.
