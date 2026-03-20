#!/bin/bash
#
# nerd-dictation-auto-switch-languages Setup Script
# One-command installation for everything
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

# Functions
success() { echo -e "${GREEN}✓${NC} $1"; }
info() { echo -e "${YELLOW}ℹ${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    error "Please do NOT run as root. Run as a normal user."
    exit 1
fi

# Step 1: Detect OS
info "Detecting operating system..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS="unknown"
fi
success "Detected: $OS"

# Step 2: Install system dependencies
info "Installing system dependencies..."
case $OS in
    ubuntu|debian|linuxmint)
        sudo apt update
        sudo apt install -y \
            python3-pip \
            xdotool \
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
            zenity \
            libnotify \
            wget \
            unzip \
            git
        ;;
    *)
        error "Unsupported OS: $OS"
        info "Please install dependencies manually:"
        info "  python3-pip, xdotool, zenity, libnotify-bin, wget, unzip, git"
        ;;
esac
success "System dependencies installed"

# Step 3: Install xkblayout-state
info "Installing xkblayout-state..."
if ! command -v xkblayout-state &> /dev/null; then
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    git clone https://github.com/nonpop/xkblayout-state.git
    cd xkblayout-state
    make
    sudo make install
    cd ~
    rm -rf "$TEMP_DIR"
    success "xkblayout-state installed"
else
    success "xkblayout-state already installed"
fi

# Step 4: Install VOSK
info "Installing VOSK..."
pip install vosk --break-system-packages 2>/dev/null || pip install vosk
success "VOSK installed"

# Step 5: Clone nerd-dictation
info "Installing nerd-dictation..."
if [ ! -d "$HOME/nerd-dictation" ]; then
    git clone https://github.com/ideasman42/nerd-dictation.git "$HOME/nerd-dictation"
    chmod +x "$HOME/nerd-dictation/nerd-dictation"
    success "nerd-dictation cloned"
else
    success "nerd-dictation already exists"
fi

# Step 6: Create model directory
info "Creating model directory..."
mkdir -p "$HOME/.config/nerd-dictation"
success "Model directory created"

# Step 7: Copy scripts
info "Copying nerd-dictation-auto-switch-languages scripts..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/dictate-start" ]; then
    cp "$SCRIPT_DIR/dictate-start" "$HOME/nerd-dictation/"
    cp "$SCRIPT_DIR/dictate-stop" "$HOME/nerd-dictation/"
    chmod +x "$HOME/nerd-dictation/dictate-start"
    chmod +x "$HOME/nerd-dictation/dictate-stop"
    success "Scripts copied"
else
    info "Scripts not found in $SCRIPT_DIR"
    info "Please copy scripts manually:"
    info "  cp dictate-start ~/.config/nerd-dictation/"
    info "  cp dictate-stop ~/.config/nerd-dictation/"
fi

# Step 8: Download English model
info "Downloading English model..."
if [ ! -d "$HOME/.config/nerd-dictation/model" ]; then
    cd "$HOME/.config/nerd-dictation"
    wget -q https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
    unzip -o vosk-model-small-en-us-0.15.zip
    mv vosk-model-small-en-us-0.15 model
    rm vosk-model-small-en-us-0.15.zip
    success "English model downloaded"
else
    success "English model already exists"
fi

# Step 9: Download Arabic model (optional)
info "Downloading Arabic model..."
if [ ! -d "$HOME/.config/nerd-dictation/model-ar" ]; then
    echo -n "Download Arabic model? (y/n): "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        wget -q https://alphacephei.com/vosk/models/vosk-model-ar-mgb2-0.4.zip
        unzip -o vosk-model-ar-mgb2-0.4.zip
        mv vosk-model-ar-mgb2-0.4 model-ar
        rm vosk-model-ar-mgb2-0.4.zip
        success "Arabic model downloaded"
    else
        info "Skipped Arabic model"
    fi
else
    success "Arabic model already exists"
fi

# Summary
echo ""
echo "========================================"
echo "  Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Set up keyboard shortcuts in your desktop:"
echo "   - Super+H: Start dictation"
echo "   - Super+Shift+H: Stop dictation"
echo ""
echo "2. Test manually:"
echo "   ~/nerd-dictation/dictate-start"
echo ""
echo "3. For help, see:"
echo "   ~/Desktop/nerd-dictation-auto-switch-languages/docs/"
echo ""
echo "========================================"
