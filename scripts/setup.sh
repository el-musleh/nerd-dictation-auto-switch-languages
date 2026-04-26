#!/bin/bash
#
# nerd-dictation-auto-switch-languages Setup Script
# One-command installation for everything.
#
# What this installs:
#   - System tools: xdotool, xsel, zenity, libnotify
#   - xkblayout-state (keyboard layout detector)
#   - Python: vosk (English), faster-whisper (Arabic)
#   - nerd-dictation (patched version with Whisper + CLIPBOARD support)
#   - dictate-start / dictate-stop scripts
#   - English VOSK model (auto-downloaded)
#

set -e  # Exit on error

echo "========================================"
echo "  nerd-dictation-auto-switch-languages Setup"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success() { echo -e "${GREEN}✓${NC} $1"; }
info()    { echo -e "${YELLOW}ℹ${NC} $1"; }
error()   { echo -e "${RED}✗${NC} $1"; }

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    error "Please do NOT run as root. Run as a normal user."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Step 1: Detect OS
# ---------------------------------------------------------------------------
info "Detecting operating system..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS="unknown"
fi
success "Detected: $OS"

# ---------------------------------------------------------------------------
# Step 2: Install system dependencies
#   xdotool  — simulate keystrokes (English output, backspace)
#   xsel     — clipboard tool used to paste Arabic text (RTL-safe)
#   zenity   — GUI dialogs for error messages
#   libnotify — desktop notifications
# ---------------------------------------------------------------------------
info "Installing system dependencies..."
case $OS in
    ubuntu|debian|linuxmint)
        sudo apt update
        sudo apt install -y \
            python3-pip \
            xdotool \
            xsel \
            zenity \
            libnotify-bin \
            wget \
            unzip \
            git
        ;;
    fedora)
        sudo dnf install -y \
            python3-pip \
            xdotool \
            xsel \
            zenity \
            libnotify \
            wget \
            unzip \
            git
        ;;
    arch|manjaro)
        sudo pacman -S --noconfirm \
            python-pip \
            xdotool \
            xsel \
            zenity \
            libnotify \
            wget \
            unzip \
            git
        ;;
    *)
        error "Unsupported OS: $OS"
        info "Please install these manually:"
        info "  python3-pip xdotool xsel zenity libnotify-bin wget unzip git"
        ;;
esac
success "System dependencies installed"

# ---------------------------------------------------------------------------
# Step 3: Install xkblayout-state (keyboard layout detector)
# ---------------------------------------------------------------------------
info "Installing xkblayout-state..."
if ! command -v xkblayout-state &> /dev/null; then
    TEMP_DIR=$(mktemp -d)
    git clone https://github.com/nonpop/xkblayout-state.git "$TEMP_DIR/xkblayout-state"
    cd "$TEMP_DIR/xkblayout-state"
    make
    sudo make install
    cd ~
    rm -rf "$TEMP_DIR"
    success "xkblayout-state installed"
else
    success "xkblayout-state already installed"
fi

# ---------------------------------------------------------------------------
# Step 4: Install Python packages
#   vosk          — English speech recognition (offline, fast)
#   faster-whisper — Arabic speech recognition (much more accurate than VOSK)
# ---------------------------------------------------------------------------
info "Installing Python packages (vosk + faster-whisper)..."
pip3 install vosk faster-whisper --break-system-packages 2>/dev/null \
    || pip3 install vosk faster-whisper
success "Python packages installed"

# ---------------------------------------------------------------------------
# Step 5: Install nerd-dictation (patched version)
#
# This repo ships a patched nerd-dictation that adds:
#   --engine WHISPER        high-accuracy Arabic via faster-whisper
#   --simulate-input-tool CLIPBOARD  RTL-safe paste using xsel
#   Arabic-aware text processing (no incorrect English capitalization)
#   "Dictation Ready" notification once model is loaded (not just started)
# ---------------------------------------------------------------------------
info "Installing nerd-dictation (patched)..."
mkdir -p "$HOME/nerd-dictation"

if [ -f "$SCRIPT_DIR/nerd-dictation" ]; then
    cp "$SCRIPT_DIR/nerd-dictation" "$HOME/nerd-dictation/nerd-dictation"
    chmod +x "$HOME/nerd-dictation/nerd-dictation"
    success "Patched nerd-dictation installed"
else
    # Fallback: clone from upstream and warn user
    error "Patched nerd-dictation not found in $SCRIPT_DIR"
    info "Falling back to upstream nerd-dictation (Arabic Whisper support will be missing)"
    if [ ! -f "$HOME/nerd-dictation/nerd-dictation" ]; then
        git clone https://github.com/ideasman42/nerd-dictation.git "$HOME/nerd-dictation"
    fi
    chmod +x "$HOME/nerd-dictation/nerd-dictation"
fi

# ---------------------------------------------------------------------------
# Step 6: Copy dictate-start and dictate-stop scripts
# ---------------------------------------------------------------------------
info "Installing dictate-start and dictate-stop..."
if [ -f "$SCRIPT_DIR/dictate-start" ]; then
    cp "$SCRIPT_DIR/dictate-start" "$HOME/nerd-dictation/dictate-start"
    cp "$SCRIPT_DIR/dictate-stop"  "$HOME/nerd-dictation/dictate-stop"
    chmod +x "$HOME/nerd-dictation/dictate-start"
    chmod +x "$HOME/nerd-dictation/dictate-stop"
    success "Scripts installed to ~/nerd-dictation/"
else
    error "Scripts not found in $SCRIPT_DIR — please copy manually"
fi

# ---------------------------------------------------------------------------
# Step 7: Create model directory and download English model
# ---------------------------------------------------------------------------
info "Setting up model directory..."
mkdir -p "$HOME/.config/nerd-dictation"
success "Model directory ready: ~/.config/nerd-dictation/"

info "Downloading English VOSK model (small, ~40 MB)..."
if [ ! -d "$HOME/.config/nerd-dictation/model" ]; then
    cd "$HOME/.config/nerd-dictation"
    wget -q --show-progress https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
    unzip -q vosk-model-small-en-us-0.15.zip
    mv vosk-model-small-en-us-0.15 model
    rm vosk-model-small-en-us-0.15.zip
    success "English model installed"
else
    success "English model already installed"
fi

# ---------------------------------------------------------------------------
# Step 8: Pre-download the Whisper Arabic model (optional)
#
# The 'small' Whisper model (~460 MB) downloads automatically on first use,
# but pre-downloading it here avoids a delay the first time Arabic dictation
# is started.
# ---------------------------------------------------------------------------
info "Pre-downloading Whisper Arabic model (small, ~460 MB)..."
echo -n "Download now? Saves time on first Arabic dictation use. (y/n): "
read -r response
if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    python3 -c "
from faster_whisper import WhisperModel
print('Downloading Whisper small model...')
WhisperModel('small', device='cpu', compute_type='int8')
print('Done.')
"
    success "Whisper small model cached"
else
    info "Skipped — will download automatically on first Arabic dictation"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "========================================"
echo "  Setup Complete!"
echo "========================================"
echo ""
echo "Installed to: ~/nerd-dictation/"
echo ""
echo "How it works:"
echo "  English keyboard layout → VOSK (offline, instant)"
echo "  Arabic keyboard layout  → Whisper (high accuracy)"
echo ""
echo "Next steps:"
echo ""
echo "1. Set keyboard shortcuts in your desktop settings:"
echo "   Start: ~/nerd-dictation/dictate-start"
echo "   Stop:  ~/nerd-dictation/dictate-stop"
echo ""
echo "2. Test English (switch to English layout first):"
echo "   ~/nerd-dictation/dictate-start"
echo ""
echo "3. Test Arabic (switch to Arabic layout first):"
echo "   ~/nerd-dictation/dictate-start"
echo "   Wait for 'Dictation Ready' notification, then speak."
echo ""
echo "4. Debug Arabic issues:"
echo "   cat /tmp/nerd-dictation-ar.log"
echo ""
echo "For full documentation see: docs/"
echo "========================================"
