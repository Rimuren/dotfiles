# =============================
# Manual Plugin Loader
# ~/.config/zsh/04-plugins.zsh
# =============================
autoload -Uz add-zsh-hook

load_plugin() {
  local file="$ZSH_PLUGINS/$1"
  [[ -r "$file" ]] && source "$file"
}

# Core plugins — load immediately, order matters:
#   1. z                — no ZLE dependency
#   2. zsh-completions  — must be before fzf-tab
#   3. fzf-tab          — must be after compinit, before FSH
#   4. FSH              — must be before substring-search
_core_plugins=(
  "z/z.sh"
  "zsh-completions/zsh-completions.plugin.zsh"
  "fzf-tab/fzf-tab.plugin.zsh"
  "fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
)

for plugin in "${_core_plugins[@]}"; do
  load_plugin "$plugin"
done

# Lazy plugins — loaded before the first prompt.
# Safe to add any plugin here that doesn't wrap core ZLE widgets.
# These run in precmd BEFORE _setup_keybindings (see 41-keybind.zsh),
# so their load order relative to bindkey is guaranteed
_lazy_plugins=(
  "zsh-autosuggestions/zsh-autosuggestions.zsh"
  "zsh-autopair/zsh-autopair.plugin.zsh"
  "interactive-cd/zsh-interactive-cd.plugin.zsh"
)

_load_lazy_plugins() {
  for plugin in "${_lazy_plugins[@]}"; do
    load_plugin "$plugin"
  done
  add-zsh-hook -d precmd _load_lazy_plugins
}

# Register lazy loader — must be registered BEFORE _setup_keybindings
# so it runs first in precmd queue
add-zsh-hook precmd _load_lazy_plugins
