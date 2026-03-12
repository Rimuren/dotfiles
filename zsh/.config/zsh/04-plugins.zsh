# ======================
# Manual Plugin Loader
# 04-plugins.zsh
# ======================

load_plugin() {
  local file="$ZSH_PLUGINS/$1"
  if [[ -r "$file" ]]; then
    source "$file"
  fi
}

autoload -Uz add-zsh-hook

# ======================
# Core Plugins
# ======================

load_plugin "z/z.sh"
load_plugin "fzf-tab/fzf-tab.plugin.zsh"

# ======================
# Lazy Interactive Plugins
# ======================

lazy_interactive() {
  load_plugin "zsh-autosuggestions/zsh-autosuggestions.zsh"
  load_plugin "fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  load_plugin "zsh-autopair/zsh-autopair.plugin.zsh"

  add-zsh-hook -d precmd lazy_interactive
}

add-zsh-hook precmd lazy_interactive