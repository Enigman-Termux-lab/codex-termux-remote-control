---
name: codex-termux-remote-control
description: Install, configure, and control OpenAI Codex CLI in Android Termux with ChatGPT Remote Control pairing and widget lifecycle.
---

# Codex Termux Remote Control Skill

Use this skill to safely deploy and manage Codex CLI in Termux, connect it to the official ChatGPT mobile app via Remote Control, and manage its lifecycle via Termux:Widget.

## Architecture & Workflow

1. **Installation:** Use community native port:
   ```bash
   pkg install nodejs-lts -y
   npm install -g @mmmbuto/codex-cli-termux@latest
   ```
2. **Auth:** Use device authentication:
   ```bash
   codex login --device-auth
   ```
3. **Start & Pair:**
   ```bash
   codex remote-control start --json
   codex remote-control pair --json
   ```
   Provide the user ONLY the `manualPairingCode`. Never expose full tokens or dumps.
4. **Widgets:**
   - `~/.shortcuts/codex-on.sh`: starts remote daemon and launches ChatGPT Android app.
   - `~/.shortcuts/codex-off.sh`: cleanly terminates Codex processes and removes stale PID files.
