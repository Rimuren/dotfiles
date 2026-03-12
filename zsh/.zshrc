# ======================
# Minimal Loader
# .zshrc
# ======================

[[ -n "$ZSH_CONFIG_LOADED" ]] && return
export ZSH_CONFIG_LOADED=1

ZSH_CONFIG="$HOME/.config/zsh"

# universal loader
load_zsh_dir() {
  local dir="$1"
  local files=("$dir"/[0-9][0-9]-*.zsh(N))

  for file in "${files[@]}"; do
    [[ -r "$file" ]] && source "$file"
  done
}

# load main config
load_zsh_dir "$ZSH_CONFIG"

# load sub modules
[[ -d "$ZSH_CONFIG/helpers" ]] && load_zsh_dir "$ZSH_CONFIG/helpers"
[[ -d "$ZSH_CONFIG/ui" ]] && load_zsh_dir "$ZSH_CONFIG/ui"