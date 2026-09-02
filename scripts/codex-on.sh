#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# Codex Remote Control — Widget ON
# Запуск фонового Remote-демона, проверка подключения и запуск ChatGPT на Android
# Размещение: ~/.shortcuts/codex-on.sh (права: chmod 700)
# ==============================================================================
set -u

export PATH="$HOME/.local/npm-global/bin:$HOME/.local/bin:$HOME/bin:${PREFIX:-/data/data/com.termux/files/usr}/bin:${PATH:-}"

CODEX_BIN="$HOME/.local/npm-global/bin/codex"
if [ ! -x "$CODEX_BIN" ]; then
    CODEX_BIN="$(command -v codex 2>/dev/null || true)"
fi

notify() {
    if command -v termux-toast >/dev/null 2>&1; then
        termux-toast "$1" >/dev/null 2>&1 || true
    fi
}

clean_stale_pid_marker() {
    local pid_file="$HOME/.codex/app-server-daemon/app-server.pid"
    local pid

    [ -f "$pid_file" ] || return 0
    pid="$(sed -n 's/.*"pid"[[:space:]]*:[[:space:]]*\([0-9][0-9]*\).*/\1/p' "$pid_file")"
    [ -n "$pid" ] || return 0

    if ! kill -0 "$pid" 2>/dev/null; then
        rm -f "$pid_file" "$pid_file.lock"
    fi
}

if [ -z "$CODEX_BIN" ] || [ ! -x "$CODEX_BIN" ]; then
    notify "Codex Remote: бинарник codex не найден в PATH"
    exit 1
fi

clean_stale_pid_marker

result=""
if command -v timeout >/dev/null 2>&1; then
    result="$(timeout 20s "$CODEX_BIN" remote-control start --json 2>&1)"
else
    result="$("$CODEX_BIN" remote-control start --json 2>&1)"
fi

if ! printf "%s\n" "$result" | grep -Eq '"status"[[:space:]]*:[[:space:]]*"connected"'; then
    notify "Codex Remote: ошибка подключения демона"
    exit 1
fi

# Автоматический запуск официального мобильного приложения ChatGPT
am start --user 0 -n com.openai.chatgpt/.MainActivity >/dev/null 2>&1 || true
notify "Codex Remote успешно включён"
exit 0
