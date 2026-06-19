# ======================
# Prompt
# ~/.config/zsh/40-prompt.zsh
# ======================

eval "$(mise activate zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

# Bindkey setup runs in precmd, registered AFTER _load_lazy_plugins,
# so it always executes after all lazy plugins are loaded.
# This is the key: zsh runs precmd_functions in registration order.
_setup_keybindings() {
  bindkey '^[[1;5C' forward-word                # Ctrl+Right
  bindkey '^[[1;5D' backward-word               # Ctrl+Left
  bindkey '^[^?'    backward-kill-word          # Alt+Backspace
  bindkey '^[^H'    backward-kill-word          # Alt+Backspace (fallback)
  add-zsh-hook -d precmd _setup_keybindings
}

add-zsh-hook precmd _setup_keybindings