# ======================
# Mise Runtime Manager UI
# /zsh/.config/zsh/ui/miseui.zsh
# ======================

miseui() {
  command -v mise >/dev/null || {
    echo "mise is not installed" >&2
    return 1
  }

  local choice
  choice=$(printf "%s\n" \
    "Install Runtime" \
    "Switch Runtime" \
    "Update Runtime" \
    "Remove Runtime" \
    "Installed Runtimes" \
    "Current Runtime" \
    "Plugins" \
    "Install Plugin" \
    "Remove Plugin" \
    "Update Plugins" \
    "Reshim" \
    "Remote Versions" \
    | fzfui --prompt="Mise > ")

  case "$choice" in
    "Install Runtime")     _mise_install_runtime ;;
    "Switch Runtime")      _mise_switch_runtime ;;
    "Update Runtime")      _mise_update_runtime ;;
    "Remove Runtime")      _mise_remove_runtime ;;
    "Installed Runtimes")  _mise_list_runtimes ;;
    "Current Runtime")     _mise_current_runtime ;;
    "Plugins")            _mise_list_plugins ;;
    "Install Plugin")     _mise_install_plugin ;;
    "Remove Plugin")      _mise_remove_plugin ;;
    "Update Plugins")     _mise_update_plugins ;;
    "Reshim")             _mise_reshim ;;
    "Remote Versions")    _mise_remote_versions ;;
  esac
}

_mise_install_runtime() {
  local tool version
  tool=$(mise plugins ls-remote | fzfui --prompt="Tool > ") || return
  version=$(mise ls-remote "$tool" | awk '{print $1}' | \
    fzfui --prompt="Version > " --preview "mise ls-remote $tool | head -20") || return
  
  mise install "$tool@$version"
  mise reshim
}

_mise_switch_runtime() {
  local runtime
  runtime=$(mise ls --installed | fzfui --prompt="Runtime > ") || return
  mise use -g "$(awk '{print $1"@"$2}' <<< "$runtime")"
}

_mise_update_runtime() {
  local tool
  tool=$(mise ls --installed | awk '{print $1}' | sort -u | fzfui --prompt="Update > ") || return
  mise upgrade "$tool"
}

_mise_remove_runtime() {
  local runtime
  runtime=$(mise ls --installed | fzfui --prompt="Remove > ") || return
  mise uninstall "$(awk '{print $1"@"$2}' <<< "$runtime")"
}

_mise_list_runtimes() {
  mise ls --installed | fzfui
}

_mise_current_runtime() {
  mise current | fzfui
}

_mise_list_plugins() {
  mise plugins ls | fzfui
}

_mise_install_plugin() {
  local plugin
  plugin=$(mise plugins ls-remote | fzfui --prompt="Plugin > ") || return
  mise plugins install "$plugin"
}

_mise_remove_plugin() {
  local plugin
  plugin=$(mise plugins ls | fzfui --prompt="Remove Plugin > ") || return
  mise plugins uninstall "$plugin"
}

_mise_update_plugins() {
  mise plugins update
}

_mise_reshim() {
  mise reshim
}

_mise_remote_versions() {
  local tool
  tool=$(mise plugins ls | \
    fzfui --prompt="Tool > " --preview 'mise ls-remote {} | head -20') || return
  mise ls-remote "$tool" | fzfui
}