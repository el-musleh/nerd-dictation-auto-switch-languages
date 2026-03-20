# Downloading Language Models

This guide explains how to download and install VOSK language models for nerd-dictation-auto-switch-languages.

---

## What Are VOSK Models?

VOSK models are neural network files that convert speech to text. Each model is trained for a specific language. You need a separate model for each language you want to dictate in.

---

## Model Directory Structure

Models should be installed in:

```
~/.config/nerd-dictation/
├── model/          # English (default)
├── model-ar/       # Arabic
├── model-de/       # German
└── model-fr/       # French (example)
```

---

## Available Models

### English Models

| Model | Size | Quality | Use Case |
|-------|------|---------|----------|
| `vosk-model-small-en-us-0.15` | 40 MB | Good | Fast, limited vocabulary |
| `vosk-model-en-us-0.22` | 1.8 GB | Excellent | High accuracy, full vocabulary |

**Recommended**: Start with the small model.

```bash
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip
mv vosk-model-small-en-us-0.15 model
```

### Arabic Models

| Model | Size | Quality | Notes |
|-------|------|---------|-------|
| `vosk-model-ar-mgb2-0.4` | 333 MB | Good | Lightweight Arabic |
| `vosk-model-ar-0.22-linto-1.1.0` | 1.3 GB | Excellent | High accuracy |

**Recommended**: Use `vosk-model-ar-0.22-linto-1.1.0` for best results.

```bash
wget https://alphacephei.com/vosk/models/vosk-model-ar-0.22-linto-1.1.0.zip
unzip vosk-model-ar-0.22-linto-1.1.0.zip
mv vosk-model-ar-0.22-linto-1.1.0 model-ar
```

### Other Languages

Visit [alphacephei.com/vosk/models](https://alphacephei.com/vosk/models) for complete list.

| Language | Code | Model Name |
|----------|------|------------|
| German | `de` | `vosk-model-de-grpc-0.2.zip` |
| French | `fr` | `vosk-model-fr-0.22.zip` |
| Spanish | `es` | `vosk-model-es-0.42.zip` |
| Russian | `ru` | `vosk-model-ru-0.42.zip` |
| Chinese | `zh` | `vosk-model-cn-0.22.zip` |

---

## Installation Steps

### 1. Create Model Directory

```bash
mkdir -p ~/.config/nerd-dictation
```

### 2. Download Model

```bash
cd ~/.config/nerd-dictation
wget https://alphacephei.com/vosk/models/[MODEL-ZIP-FILE]
```

### 3. Extract

```bash
unzip [MODEL-ZIP-FILE]
```

### 4. Rename to Standard Format

```bash
# For English (default model)
mv vosk-model-small-en-us-0.15 model

# For Arabic
mv vosk-model-ar-0.22-linto-1.1.0 model-ar

# For German
mv vosk-model-de-grpc-0.2 model-de
```

---

## Using the Install Script

Instead of manual steps, use:

```bash
cd ~/Desktop/nerd-dictation-auto-switch-languages/scripts
chmod +x install-models.sh
./install-models.sh
```

This interactive script will:
- Show available languages
- Download selected models
- Place them in correct directories

---

## Verify Installation

### Check Models Directory

```bash
ls -la ~/.config/nerd-dictation/
```

Expected output:
```
drwxr-xr-x  7 steve2 steve2  4096 model/
drwxr-xr-x  7 steve2 steve2  4096 model-ar/
```

### Check Model Contents

```bash
ls ~/.config/nerd-dictation/model/
```

Expected files:
```
am/          # Acoustic model
conf/        # Configuration
graph/       # Decoding graph
ivector/     # iVectors
rescore/     # Language model
README
```

---

## Model Size Comparison

| Language | Small Model | Large Model |
|----------|-------------|-------------|
| English | 40 MB | 1.8 GB |
| Arabic | 333 MB | 1.3 GB |
| German | 45 MB | 1.6 GB |
| French | 45 MB | 1.8 GB |

---

## Performance Notes

- **Small models**: Load faster, use less RAM, good for real-time dictation
- **Large models**: More accurate, slower to load, better for transcription

---

## Adding New Languages

To add support for a new language:

1. Find the model at [alphacephei.com/vosk/models](https://alphacephei.com/vosk/models)
2. Download and extract
3. Rename to `model-XX` (XX = language code)
4. Add layout detection in `dictate-start` script:

```bash
# Add this case in dictate-start:
xx)
    MODEL_DIR="$MODEL_BASE/model-xx"
    LANG_NAME="New Language"
    LANG_CODE="xx"
    ;;
```

---

## Troubleshooting

### "Model not found" Error

Check that the model directory exists:
```bash
ls ~/.config/nerd-dictation/model
```

### Model Extraction Failed

Install unzip:
```bash
sudo apt install unzip
```

### Slow Model Loading

Consider using a smaller model for faster startup.

---

## Next Steps

- [Configure Keyboard Layouts](03-configuration.md)
- [Set Up Desktop Integration](05-desktop-integration.md)
