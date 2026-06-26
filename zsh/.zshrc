# ======================
# Minimal Loader
# .zshrc
# ======================

ZSH_CONFIG="$HOME/.config/zsh"

[[ -d "$ZSH_CONFIG" ]] || return

# Load all numbered zsh files from a directory
load_zsh_dir() {
  local dir="$1"
  [[ -d "$dir" ]] || return
  for f in "$dir"/[0-9][0-9]-*.zsh(N); do
    [[ -r "$f" ]] && source "$f"
  done
}

for dir in "$ZSH_CONFIG" "$ZSH_CONFIG/helpers" "$ZSH_CONFIG/ui" "$ZSH_CONFIG/functions"; do
  load_zsh_dir "$dir"
done
