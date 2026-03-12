# ======================
# Aliases
# ======================

alias ls='ls -ah --color=auto'
alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'

alias Sybau='sudo pacman -Syu'

# ======================
# FZF History (Ctrl+R)
# ======================

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

# ======================
# File Finder (ff)
# ======================

ff() {
    local files
    files=$(fd --type f | fzf -m)

    if [[ -n "$files" ]]; then
        local count max=10
        count=$(printf "%s\n" "$files" | wc -l)

        if (( count > max )); then
            echo "⚠ Limit is $max files, opening first $max only."
            files=$(printf "%s\n" "$files" | head -n $max)
        fi

        echo "$files" | while IFS= read -r f; do
            nohup xdg-open "$f" >/dev/null 2>&1 &
        done
    fi
}

# ======================
# Minimal Bluetooth (fallback version)
# ======================

blue() {
    local state choice

    if systemctl is-active --quiet bluetooth; then
        state="ON"
    else
        state="OFF"
    fi

    choice=$(printf "Toggle (Current: %s)\nOn\nOff\nStatus\n" "$state" | \
        fzf --height=40% --reverse --border --prompt="Bluetooth > ")

    case "$choice" in
        Toggle*)
            sudo systemctl is-active --quiet bluetooth \
                && sudo systemctl stop bluetooth \
                || sudo systemctl start bluetooth
            ;;
        On)
            sudo systemctl start bluetooth
            ;;
        Off)
            sudo systemctl stop bluetooth
            ;;
        Status)
            systemctl status bluetooth --no-pager
            ;;
    esac
}