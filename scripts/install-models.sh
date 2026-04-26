#!/bin/bash
#
# Model Downloader for nerd-dictation-auto-switch-languages
# Downloads VOSK models for English and other languages.
#
# Note: Arabic uses Whisper (faster-whisper), NOT VOSK.
# The Whisper model downloads automatically on first Arabic dictation.
#

echo "========================================"
echo "  Model Downloader"
echo "========================================"
echo ""
echo "Note: Arabic uses Whisper (auto-downloaded on first use)."
echo "This script downloads VOSK models for English and other languages."
echo ""

MODEL_DIR="$HOME/.config/nerd-dictation"
mkdir -p "$MODEL_DIR"

# Available VOSK models (Arabic removed — Arabic uses Whisper instead)
declare -A MODELS=(
    ["en-small"]="vosk-model-small-en-us-0.15"
    ["en-large"]="vosk-model-en-us-0.22"
    ["de"]="vosk-model-de-grpc-0.2"
    ["fr"]="vosk-model-fr-0.22"
    ["es"]="vosk-model-es-0.42"
    ["ru"]="vosk-model-ru-0.42"
    ["zh"]="vosk-model-cn-0.22"
)

declare -A MODEL_NAMES=(
    ["en-small"]="English (Small, 40MB) — recommended"
    ["en-large"]="English (Large, 1.8GB) — high accuracy"
    ["de"]="German (45MB)"
    ["fr"]="French (45MB)"
    ["es"]="Spanish (45MB)"
    ["ru"]="Russian (45MB)"
    ["zh"]="Chinese (45MB)"
)

declare -A MODEL_URLS=(
    ["en-small"]="https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip"
    ["en-large"]="https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip"
    ["de"]="https://alphacephei.com/vosk/models/vosk-model-de-grpc-0.2.zip"
    ["fr"]="https://alphacephei.com/vosk/models/vosk-model-fr-0.22.zip"
    ["es"]="https://alphacephei.com/vosk/models/vosk-model-es-0.42.zip"
    ["ru"]="https://alphacephei.com/vosk/models/vosk-model-ru-0.42.zip"
    ["zh"]="https://alphacephei.com/vosk/models/vosk-model-cn-0.22.zip"
)

# Show menu
echo "Available models:"
echo ""
i=1
declare -a KEYS_ORDERED
for key in en-small en-large de fr es ru zh; do
    KEYS_ORDERED+=("$key")
    folder="${MODELS[$key]}"
    if [ -d "$MODEL_DIR/$folder" ]; then
        status="[Installed]"
    else
        status="[Not installed]"
    fi
    echo "  $i. ${MODEL_NAMES[$key]} $status"
    i=$((i+1))
done
echo ""

# Get selection
echo -n "Select model number to download (or 'q' to quit): "
read -r selection

if [ "$selection" = "q" ] || [ "$selection" = "Q" ]; then
    echo "Exiting."
    exit 0
fi

# Convert selection to key (1-based index into ordered array)
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt "${#KEYS_ORDERED[@]}" ]; then
    echo "Invalid selection."
    exit 1
fi

selected_key="${KEYS_ORDERED[$((selection-1))]}"

# Download model
echo ""
echo "Downloading ${MODEL_NAMES[$selected_key]}..."
echo ""

MODEL_NAME="${MODELS[$selected_key]}"
MODEL_URL="${MODEL_URLS[$selected_key]}"

cd "$MODEL_DIR"
wget "$MODEL_URL"

if [ $? -eq 0 ]; then
    ZIP_FILE="${MODEL_URL##*/}"
    unzip -o "$ZIP_FILE"
    rm "$ZIP_FILE"
    echo ""
    echo "✓ Model installed to: $MODEL_DIR/$MODEL_NAME"
else
    echo ""
    echo "✗ Download failed."
    exit 1
fi

echo ""
echo "Done!"
