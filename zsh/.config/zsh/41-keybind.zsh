# ======================
# ZLE Keybindings
# ~/.config/zsh/41-keybind.zsh
# ======================

# Disable Atuin auto-binding (backup besides --disable-up-arrow)
export ATUIN_NOBIND=true

# Use emacs mode
bindkey -e

# ----------------------
# Word movement
# ----------------------

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ----------------------
# Delete word
# ----------------------

# Alt + Backspace (delete 1 word)
bindkey '^[^H' backward-kill-word
bindkey '^[^?' backward-kill-word

# ----------------------
# Home / End
# ----------------------

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
