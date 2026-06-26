# ======================
# Functions
# ======================

# FZF History (Ctrl+R)
if command -v fzf &>/dev/null; then
    fzf-history() {
        local selected
        selected=$(history | tac | awk '!seen[$0]++' | sed 's/^ *[0-9]\+ *//' | \
            fzf --height=40% --reverse --border)
        if [[ -n "$selected" ]]; then
            READLINE_LINE="$selected"
            READLINE_POINT=${#selected}
        fi
    }
    bind -x '"\C-r": fzf-history'
fi

# File finder — Enter: open, max 10 files
ff() {
    local files file count max=10
    files=$(fd --type f | fzf -m)
    [[ -z "$files" ]] && return

    count=$(printf "%s\n" "$files" | wc -l)
    if (( count > max )); then
        echo "Limit is $max files, opening first $max only."
        files=$(printf "%s\n" "$files" | head -n "$max")
    fi

    while IFS= read -r file; do
        nohup xdg-open "$file" >/dev/null 2>&1 &
    done <<< "$files"
}

# Minimal bluetooth manager (fallback — no bluetoothctl scan)
blue() {
    local state choice
    systemctl is-active --quiet bluetooth && state="ON" || state="OFF"

    choice=$(printf "Toggle (Current: %s)\nOn\nOff\nStatus\n" "$state" | \
        fzf --height=40% --reverse --border --prompt="Bluetooth > ")

    case "$choice" in
        Toggle*)
            systemctl is-active --quiet bluetooth \
                && sudo systemctl stop bluetooth \
                || sudo systemctl start bluetooth
            ;;
        On)     sudo systemctl start bluetooth ;;
        Off)    sudo systemctl stop bluetooth ;;
        Status) systemctl status bluetooth --no-pager ;;
    esac
}
