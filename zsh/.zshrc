# ======================
# Minimal Loader
# .zshrc
# ======================

ZSH_CONFIG="$HOME/.config/zsh"

load_zsh_dir() {
  local dir="$1"
  local files=("$dir"/[0-9][0-9]-*.zsh(N))

  for file in "${files[@]}"; do
    [[ -r "$file" ]] && source "$file"
  done
}

load_zsh_dir "$ZSH_CONFIG"

[[ -d "$ZSH_CONFIG/helpers" ]] && load_zsh_dir "$ZSH_CONFIG/helpers"
[[ -d "$ZSH_CONFIG/ui" ]] && load_zsh_dir "$ZSH_CONFIG/ui"
