# =============================
# Manual Plugin Loader
# ~/.config/zsh/04-plugins.zsh
# =============================
autoload -Uz add-zsh-hook

load_plugin() {
  local file="$ZSH_PLUGINS/$1"
  [[ -r "$file" ]] && source "$file"
}

# Plugin load order:
#   1. z                — no ZLE dependency
#   2. zsh-completions  — must be before fzf-tab
#   3. fzf-tab          — must be after compinit, before FSH
#   4. FSH              — must be after fzf-tab
#   5. zsh-autosuggestions — after FSH
#   6. zsh-autopair    — after autosuggestions
_plugins=(
  "z/z.sh"
  "zsh-completions/zsh-completions.plugin.zsh"
  "fzf-tab/fzf-tab.plugin.zsh"
  "fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  "zsh-autosuggestions/zsh-autosuggestions.zsh"
  "zsh-autopair/zsh-autopair.plugin.zsh"
)


for plugin in "${_plugins[@]}"; do
  load_plugin "$plugin"
done
