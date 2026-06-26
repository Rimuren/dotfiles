# ===============================
# Startup Info
# ~/.config/zsh/50-startup.zsh
# ===============================

# Only run in interactive shells
[[ -o interactive ]] || return

# Allow disabling
[[ -n "$NO_FASTFETCH" ]] && return

# Run fastfetch if available
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi
