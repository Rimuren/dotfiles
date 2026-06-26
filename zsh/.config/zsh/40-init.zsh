# ============================
# Tool Inits
# ~/.config/zsh/40-init.zsh
# ============================

command -v mise >/dev/null && eval "$(mise activate zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"
