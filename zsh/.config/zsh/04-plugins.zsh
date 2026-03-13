# ======================
# Manual Plugin Loader
# 04-plugins.zsh
# ======================

autoload -Uz add-zsh-hook

load_plugin() {
  local file="$ZSH_PLUGINS/$1"
  [[ -r "$file" ]] && source "$file"
}

_core_plugins=(
  "z/z.sh"
  "fzf-tab/fzf-tab.plugin.zsh"
)

_interactive_plugins=(
  "zsh-autosuggestions/zsh-autosuggestions.zsh"
  "fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  "zsh-autopair/zsh-autopair.plugin.zsh"
)

for plugin in $_core_plugins; do
  load_plugin "$plugin"
done

lazy_interactive() {
  for plugin in $_interactive_plugins; do
    load_plugin "$plugin"
  done
  add-zsh-hook -d precmd lazy_interactive
}
add-zsh-hook precmd lazy_interactive