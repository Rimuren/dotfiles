# ===============================
# Mise Runtime Manager UI
# ~/.config/zsh/ui/25-miseui.zsh
# ===============================

command -v mise >/dev/null || return

# Cache dir for slow remote calls
_MISE_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/miseui"
mkdir -p "$_MISE_CACHE_DIR"

# fzf wrapper for mise — no preview by default, caller can override
_mfzf() { fzfui --preview-window=hidden "$@"; }

# Main entry point
miseui() {
  local choice
  choice=$(printf "%s\n" \
    "󰏗  Install Runtime" \
    "  Switch Runtime" \
    "  Update Runtime" \
    "  Remove Runtime" \
    "  Installed Runtimes" \
    "  Current Runtimes" \
    "  Plugins" \
    "  Install Plugin" \
    "  Remove Plugin" \
    "  Update All Plugins" \
    "  Reshim" \
    "  Remote Versions" \
    "  Mise Commands" \
    | _mfzf \
        --prompt="Mise > " \
        --preview-window=hidden \
    ) || return

  case "$choice" in
    *"Install Runtime")    _mise_install_runtime ;;
    *"Switch Runtime")     _mise_switch_runtime ;;
    *"Update Runtime")     _mise_update_runtime ;;
    *"Remove Runtime")     _mise_remove_runtime ;;
    *"Installed Runtimes") _mise_list_runtimes ;;
    *"Current Runtimes")   _mise_current_runtime ;;
    *"Plugins")            _mise_list_plugins ;;
    *"Install Plugin")     _mise_install_plugin ;;
    *"Remove Plugin")      _mise_remove_plugin ;;
    *"Update All Plugins") mise plugins update ;;
    *"Reshim")             mise reshim && echo "Reshim done." ;;
    *"Remote Versions")    _mise_remote_versions ;;
    *"Mise Commands")      _mise_commands ;;
  esac
}

# --- Cache helper ---

_mise_cache_refresh() {
  local cache="$1"
  if [[ ! -f "$cache" ]] || [[ $(find "$cache" -mtime +1 2>/dev/null) ]]; then
    echo "Fetching plugin list (first run may take a moment)..."
    mise plugins ls-remote > "$cache" 2>/dev/null
  fi
}

# --- Runtime management ---

_mise_install_runtime() {
  local tool version cache="$_MISE_CACHE_DIR/plugins-remote"
  _mise_cache_refresh "$cache"

  tool=$(awk '{print $1}' "$cache" | \
    _mfzf \
      --prompt="Tool > " \
      --preview 'grep "^{}" '"$cache"' | head -5'
  ) || return

  version=$(mise ls-remote "$tool" 2>/dev/null | \
    _mfzf \
      --prompt="Version ($tool) > " \
      --preview "echo 'Installing: $tool@{}'"
  ) || return

  echo "Installing $tool@$version..."
  mise install "$tool@$version" && mise reshim
}

_mise_switch_runtime() {
  local runtime tool version scope

  runtime=$(mise ls --installed 2>/dev/null | \
    _mfzf \
      --prompt="Switch to > " \
      --preview 'echo "Runtime: {}"'
  ) || return

  tool=$(awk '{print $1}' <<< "$runtime")
  version=$(awk '{print $2}' <<< "$runtime")

  scope=$(printf "global\nlocal" | \
    _mfzf \
      --height=~20% \
      --prompt="Scope > " \
      --preview-window=hidden
  ) || return

  case "$scope" in
    global) mise use -g "$tool@$version" ;;
    local)  mise use "$tool@$version" ;;
  esac
}

_mise_update_runtime() {
  local tool
  tool=$(mise ls --installed 2>/dev/null | awk '{print $1}' | sort -u | \
    _mfzf \
      --prompt="Update > " \
      --preview 'mise ls --installed 2>/dev/null | grep "^{}"'
  ) || return

  echo "Updating $tool..."
  mise upgrade "$tool"
}

_mise_remove_runtime() {
  local runtime tool version confirm

  runtime=$(mise ls --installed 2>/dev/null | \
    _mfzf \
      --prompt="Remove > " \
      --preview 'echo "Will uninstall: {}"'
  ) || return

  tool=$(awk '{print $1}' <<< "$runtime")
  version=$(awk '{print $2}' <<< "$runtime")

  confirm=$(printf "No\nYes" | \
    _mfzf \
      --height=~20% \
      --prompt="Remove $tool@$version? > " \
      --preview-window=hidden
  ) || return

  [[ "$confirm" == "Yes" ]] && mise uninstall "$tool@$version"
}

_mise_list_runtimes() {
  local runtime tool version action

  runtime=$(mise ls --installed 2>/dev/null | \
    _mfzf \
      --prompt="Runtimes > " \
      --preview 'mise ls --installed 2>/dev/null | grep "^$(echo {} | awk "{print \$1}")"'
  ) || return

  [[ -z "$runtime" ]] && return
  tool=$(awk '{print $1}' <<< "$runtime")
  version=$(awk '{print $2}' <<< "$runtime")

  action=$(printf "Switch to this (global)\nSwitch to this (local)\nRemove\nCancel" | \
    _mfzf \
      --height=~25% \
      --prompt="$tool@$version > " \
      --preview-window=hidden
  ) || return

  case "$action" in
    "Switch to this (global)") mise use -g "$tool@$version" ;;
    "Switch to this (local)")  mise use "$tool@$version" ;;
    "Remove")                  _mise_remove_runtime ;;
  esac
}

_mise_current_runtime() {
  mise current 2>/dev/null | \
    _mfzf \
      --prompt="Current > " \
      --preview 'echo "Active: {}"' \
      --preview-window=right:40%:wrap
}

# --- Plugin management ---

_mise_list_plugins() {
  local plugin action

  plugin=$(mise plugins ls 2>/dev/null | \
    _mfzf \
      --prompt="Plugins > " \
      --preview 'mise ls --installed 2>/dev/null | grep "^{}"'
  ) || return

  [[ -z "$plugin" ]] && return

  action=$(printf "List versions\nUpdate\nRemove\nCancel" | \
    _mfzf \
      --height=~25% \
      --prompt="$plugin > " \
      --preview-window=hidden
  ) || return

  case "$action" in
    "List versions") mise ls-remote "$plugin" 2>/dev/null | fzfui ;;
    "Update")        mise plugins update "$plugin" ;;
    "Remove")        _mise_remove_plugin "$plugin" ;;
  esac
}

_mise_install_plugin() {
  local plugin cache="$_MISE_CACHE_DIR/plugins-remote"
  _mise_cache_refresh "$cache"

  plugin=$(awk '{print $1}' "$cache" | \
    _mfzf \
      --prompt="Install Plugin > " \
      --preview 'grep "^{}" '"$cache"
  ) || return

  echo "Installing plugin $plugin..."
  mise plugins install "$plugin"
}

_mise_remove_plugin() {
  # Accept plugin name as arg (from _mise_list_plugins) or pick via fzf
  local plugin="${1:-}" confirm

  if [[ -z "$plugin" ]]; then
    plugin=$(mise plugins ls 2>/dev/null | \
      _mfzf \
        --prompt="Remove Plugin > " \
        --preview-window=hidden
    ) || return
  fi

  confirm=$(printf "No\nYes" | \
    _mfzf \
      --height=~20% \
      --prompt="Remove plugin $plugin? > " \
      --preview-window=hidden
  ) || return

  [[ "$confirm" == "Yes" ]] && mise plugins uninstall "$plugin"
}

_mise_remote_versions() {
  local tool version cache="$_MISE_CACHE_DIR/plugins-remote"
  _mise_cache_refresh "$cache"

  tool=$(awk '{print $1}' "$cache" | \
    _mfzf \
      --prompt="Tool > " \
      --preview 'mise ls-remote {} 2>/dev/null | head -20'
  ) || return

  version=$(mise ls-remote "$tool" 2>/dev/null | \
    _mfzf \
      --prompt="$tool version > " \
      --preview "echo 'Press Enter to install $tool@{}'" \
      --header="Enter: install this version"
  ) || return

  echo "Installing $tool@$version..."
  mise install "$tool@$version" && mise reshim
}

# --- Mise command reference ---

_mise_commands() {
  local cmd command_str

  cmd=$(cat <<'EOF' | \
    _mfzf \
      --prompt="Command > " \
      --preview 'echo {} | awk "{print \$1}" | xargs mise help 2>/dev/null || echo "No help available"' \
      --preview-window=right:50%:wrap \
      --header="Enter: run"
mise install            Install a tool version
mise use                Set tool version (local .mise.toml)
mise use -g             Set tool version globally
mise ls                 List installed tools
mise ls-remote          List available remote versions
mise current            Show active versions
mise upgrade            Upgrade tool to latest
mise uninstall          Remove a tool version
mise reshim             Rebuild shims
mise plugins ls         List installed plugins
mise plugins ls-remote  List available plugins
mise plugins install    Install a plugin
mise plugins update     Update plugins
mise plugins uninstall  Remove a plugin
mise doctor             Check mise setup health
mise self-update        Update mise itself
mise env                Show env vars mise sets
mise exec               Run command with mise env
mise run                Run a task (mise.toml [tasks])
mise tasks              List defined tasks
mise settings           Show mise settings
mise cache clear        Clear mise cache
mise config             Show current config files
mise where              Show install path of a tool
mise which              Show path of a tool binary
EOF
  ) || return

  command_str=$(awk '{print $1, ($2 ~ /^-/ ? $2 : "")}' <<< "$cmd" | xargs)
  echo "Running: mise $command_str"
  eval "mise $command_str"
}
