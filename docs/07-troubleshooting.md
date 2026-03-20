# Troubleshooting

Solutions to common issues with nerd-dictation++.

---

## Quick Diagnostics

Before troubleshooting, run these commands to understand your setup:

```bash
# Check keyboard layout detection
xkblayout-state print "%s"

# Verify scripts are executable
ls -la ~/nerd-dictation/dictate-*

# Check models directory
ls ~/.config/nerd-dictation/

# View latest logs
tail -20 /tmp/dictate-start.log
```

---

## Common Issues

### Issue: "nerd-dictation not found"

**Symptom**: Error popup: "nerd-dictation not found at: /home/..."

**Cause**: Script can't find the base nerd-dictation installation

**Solution**:
```bash
# Verify nerd-dictation exists
ls ~/nerd-dictation/nerd-dictation

# If missing, reinstall
git clone https://github.com/ideasman42/nerd-dictation.git ~/nerd-dictation
chmod +x ~/nerd-dictation/nerd-dictation
```

---

### Issue: "Could not detect keyboard layout"

**Symptom**: Error popup when starting dictation

**Cause**: `xkblayout-state` not installed or not working

**Solution**:
```bash
# Test if xkblayout-state works
xkblayout-state print "%s"

# If not, install it
git clone https://github.com/nonpop/xkblayout-state.git
cd xkblayout-state
make
sudo make install

# Log out and back in
```

---

### Issue: "Unsupported keyboard layout"

**Symptom**: Error popup showing your layout is not supported

**Cause**: Layout not added to `dictate-start` script

**Solution 1**: Add the layout to the script:
```bash
nano ~/nerd-dictation/dictate-start
```
Add a case for your layout:
```bash
case "$CURRENT_LAYOUT" in
    us) # existing ;;
    ara) # existing ;;
    YOUR_CODE)
        MODEL_DIR="$MODEL_BASE/model-yourlang"
        LANG_NAME="Your Language"
        LANG_CODE="YOUR_CODE"
        ;;
esac
```

**Solution 2**: Install the model for a supported layout

---

### Issue: "Model not installed"

**Symptom**: Error popup: "English/Arabic model not installed"

**Cause**: Model folder missing or corrupted

**Solution**:
```bash
# Check what models exist
ls ~/.config/nerd-dictation/

# Download English model
cd ~/.config/nerd-dictation
wget https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip
mv vosk-model-small-en-us-0.15 model

# Download Arabic model
wget https://alphacephei.com/vosk/models/vosk-model-ar-mgb2-0.4.zip
unzip vosk-model-ar-mgb2-0.4.zip
mv vosk-model-ar-mgb2-0.4 model-ar
```

---

### Issue: Dictation Not Typing Text

**Symptom**: Dictation starts but no text appears

**Cause**: `xdotool` not working properly

**Solution**:
```bash
# Test xdotool
xdotool type "hello"

# Install if missing
sudo apt install xdotool

# Check for Wayland (xdotool won't work on Wayland)
echo $XDG_SESSION_TYPE
# If says "wayland", you need wtype instead
```

---

### Issue: Notification Not Showing

**Symptom**: No desktop notification when starting/stopping

**Cause**: `libnotify` not installed or notification daemon not running

**Solution**:
```bash
# Install libnotify
sudo apt install libnotify-bin

# Test notifications
notify-send "Test" "Hello!"

# Check notification daemon
ps aux | grep -E "notify|notification"
```

---

### Issue: Script Works in Terminal But Not From Shortcut

**Symptom**: Running `./dictate-start` works, but keyboard shortcut doesn't

**Cause**: Environment differences when running from desktop

**Solution**:
```bash
# Edit your shortcut command to use bash explicitly:
bash -c "/home/YOUR_USER/nerd-dictation/dictate-start"
```

In your desktop shortcut settings, set the command to:
```
bash -c "~/nerd-dictation/dictate-start"
```

---

### Issue: "Dictation already running"

**Symptom**: Can't start new dictation

**Cause**: Previous dictation process still active

**Solution**:
```bash
# Force stop all dictation
pkill -f nerd-dictation

# Remove stale state file
rm ~/.dictate-state

# Start fresh
~/nerd-dictation/dictate-start
```

---

### Issue: Wrong Language Detected

**Symptom**: Arabic keyboard but English dictation starts (or vice versa)

**Cause**: Layout detection lagging or unreliable

**Solution 1**: Check actual layout:
```bash
xkblayout-state print "%s"
```

**Solution 2**: Wait longer between switching layouts and starting dictation

**Solution 3**: Check xkblayout-state is installed correctly:
```bash
which xkblayout-state
xkblayout-state print "%s(%e)"
```

---

### Issue: Very Slow Model Loading

**Symptom**: Takes >10 seconds to start dictation

**Cause**: Using large model or slow disk

**Solution**:
1. Use smaller model:
   ```bash
   # Instead of vosk-model-en-us-0.22 (1.8GB)
   # Use vosk-model-small-en-us-0.15 (40MB)
   ```

2. Move models to faster storage (SSD)

3. Check disk performance:
   ```bash
   hdparm -t /dev/sda
   ```

---

## Debug Mode

Enable verbose logging to see exactly what's happening:

```bash
# Run with verbose
cd ~/nerd-dictation
./dictate-start --verbose

# In another terminal, watch the log
tail -f /tmp/dictate-start.log

# Also watch nerd-dictation log
tail -f /tmp/nerd-dictation.log
```

---

## Getting Help

### Collect Debug Info

Run this script to gather system information:

```bash
cat << 'EOF' > ~/debug-dictation.sh
#!/bin/bash
echo "=== nerd-dictation++ Debug Info ==="
echo ""
echo "OS:"
cat /etc/os-release | grep PRETTY
echo ""
echo "Python:"
python3 --version
echo ""
echo "Keyboard Layout:"
xkblayout-state print "%s(%e)"
echo ""
echo "Models:"
ls -la ~/.config/nerd-dictation/
echo ""
echo "Scripts:"
ls -la ~/nerd-dictation/dictate-*
echo ""
echo "xkblayout-state:"
which xkblayout-state
echo ""
echo "Recent Logs:"
tail -10 /tmp/dictate-start.log 2>/dev/null || echo "No log file"
EOF
chmod +x ~/debug-dictation.sh
~/debug-dictation.sh
```

### Report an Issue

When reporting issues, include:
1. Output of `~/debug-dictation.sh`
2. Your desktop environment (Cinnamon, GNOME, KDE, etc.)
3. Your keyboard layout codes
4. Steps to reproduce

---

## FAQ

### Q: Can I use this with Wayland?

**A**: Partially. The base `nerd-dictation` uses `xdotool` which works only on X11. For Wayland:
- Use `wtype` instead of `xdotool`
- Or switch to X11 session

### Q: How do I add more languages?

**A**: See [Advanced Options](06-advanced.md#adding-new-languages)

### Q: Can I use Bluetooth headphones?

**A**: Yes, as long as they're set as the default audio input device.

### Q: How accurate is it?

**A**: VOSK models typically achieve 90-95% accuracy for clear speech.

### Q: Can I use this offline?

**A**: Yes! VOSK models run entirely offline.

---

## Still Stuck?

1. Search existing [GitHub Issues](https://github.com/ideasman42/nerd-dictation/issues)
2. Check [VOSK Models](https://alphacephei.com/vosk/models) documentation
3. Review [nerd-dictation README](https://github.com/ideasman42/nerd-dictation)
