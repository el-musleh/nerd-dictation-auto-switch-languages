#!/bin/bash
#
# Model Downloader for nerd-dictation-auto-switch-languages
# Interactive script to download VOSK models
#

echo "========================================"
echo "  Model Downloader"
echo "========================================"
echo ""

MODEL_DIR="$HOME/.config/nerd-dictation"
mkdir -p "$MODEL_DIR"

# Available models
declare -A MODELS=(
    ["en-small"]="vosk-model-small-en-us-0.15"
    ["en-large"]="vosk-model-en-us-0.22"
    ["ar-small"]="vosk-model-ar-mgb2-0.4"
    ["ar-large"]="vosk-model-ar-0.22-linto-1.1.0"
    ["de"]="vosk-model-de-grpc-0.2"
    ["fr"]="vosk-model-fr-0.22"
    ["es"]="vosk-model-es-0.42"
    ["ru"]="vosk-model-ru-0.42"
    ["zh"]="vosk-model-cn-0.22"
)

declare -A MODEL_NAMES=(
    ["en-small"]="English (Small, 40MB)"
    ["en-large"]="English (Large, 1.8GB)"
    ["ar-small"]="Arabic (Small, 333MB)"
    ["ar-large"]="Arabic (Large, 1.3GB)"
    ["de"]="German (45MB)"
    ["fr"]="French (45MB)"
    ["es"]="Spanish (45MB)"
    ["ru"]="Russian (45MB)"
    ["zh"]="Chinese (45MB)"
)

declare -A MODEL_URLS=(
    ["en-small"]="https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip"
    ["en-large"]="https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip"
    ["ar-small"]="https://alphacephei.com/vosk/models/vosk-model-ar-mgb2-0.4.zip"
    ["ar-large"]="https://alphacephei.com/vosk/models/vosk-model-ar-0.22-linto-1.1.0.zip"
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
for key in "${!MODEL_NAMES[@]}"; do
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

# Convert selection to key
keys=("${!MODEL_NAMES[@]}")
selected_key="${keys[$((selection-1))]}"

if [ -z "$selected_key" ]; then
    echo "Invalid selection."
    exit 1
fi

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
