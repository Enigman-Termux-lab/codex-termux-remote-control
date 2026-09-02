#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# Codex Remote Control — Widget OFF
# Мягкое отключение Remote Control, точечное завершение процессов Codex и очистка
# Размещение: ~/.shortcuts/codex-off.sh (права: chmod 700)
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

if [ -n "$CODEX_BIN" ] && [ -x "$CODEX_BIN" ]; then
    if command -v timeout >/dev/null 2>&1; then
        timeout 20s "$CODEX_BIN" remote-control stop >/dev/null 2>&1 || true
    else
        "$CODEX_BIN" remote-control stop >/dev/null 2>&1 || true
    fi
fi

# Точечно находим и завершаем только процессы Codex, не задевая остальной Termux
CODEX_WRAPPER="codex"
CODEX_NATIVE="codex.bin"

find_codex_pgids() {
    local proc_dir pid cmdline pgid

    for proc_dir in /proc/[0-9]*; do
        pid="${proc_dir##*/}"
        [ "$pid" = "$$" ] && continue
        cmdline="$(tr '\0' ' ' < "$proc_dir/cmdline" 2>/dev/null || true)"

        case "$cmdline" in
            *"$CODEX_WRAPPER"*|*"$CODEX_NATIVE"*)
                pgid="$(ps -o pgid= -p "$pid" 2>/dev/null | sed 's/^[[:space:]]*//;s/[[:space:]].*$//')"
                case "$pgid" in
                    ""|*[!0-9]*) ;;
                    *) printf "%s\n" "$pgid" ;;
                esac
                ;;
        esac
    done | sort -u
}

pgids="$(find_codex_pgids)"
for pgid in $pgids; do
    [ "$pgid" = "$$" ] && continue
    kill -TERM "-$pgid" 2>/dev/null || true
done

sleep 1

pgids="$(find_codex_pgids)"
for pgid in $pgids; do
    [ "$pgid" = "$$" ] && continue
    kill -KILL "-$pgid" 2>/dev/null || true
done

clean_stale_pid_marker
termux-notification-remove codex-remote >/dev/null 2>&1 || true
notify "Codex полностью выключен"
exit 0
