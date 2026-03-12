# ======================
# Minimal Loader
# .zshrc
# ======================

ZSH_CONFIG="$HOME/.config/zsh"

[[ -n "$ZSH_CONFIG_LOADED" ]] && return
export ZSH_CONFIG_LOADED=1

config_files=("$ZSH_CONFIG"/[0-9][0-9]-*.zsh(N))

for file in "${config_files[@]}"; do
  source "$file"
done

