# ======================
# Mise Runtime Manager UI
# /zsh/.config/zsh/ui/miseui.zsh
# ======================

miseui() {

  command -v mise >/dev/null || {
    echo "mise is not installed"
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

    "Install Runtime")

      local tool
      tool=$(mise plugins ls-remote | fzfui --prompt="Tool > ")
      [[ -z "$tool" ]] && return

      local version
      version=$(mise ls-remote "$tool" | awk '{print $1}' | \
        fzfui \
        --prompt="Version > " \
        --preview "mise ls-remote $tool | head -20" \
        --preview-window=right:60%)

      [[ -z "$version" ]] && return

      mise install "$tool@$version"
      mise reshim
      ;;

    "Switch Runtime")

      local runtime
      runtime=$(mise ls --installed | fzfui --prompt="Runtime > ")
      [[ -z "$runtime" ]] && return

      mise use -g "$(echo "$runtime" | awk '{print $1"@"$2}')"
      ;;

    "Remove Runtime")

      local runtime
      runtime=$(mise ls --installed | fzfui --prompt="Remove > ")
      [[ -z "$runtime" ]] && return

      mise uninstall "$(echo "$runtime" | awk '{print $1"@"$2}')"
      ;;

    "Update Runtime")

      local tool
      tool=$(mise ls --installed | awk '{print $1}' | sort -u | fzfui --prompt="Update > ")
      [[ -z "$tool" ]] && return

      mise upgrade "$tool"
      ;;

    "Installed Runtimes")
      mise ls --installed | fzfui
      ;;

    "Current Runtime")
      mise current | fzfui
      ;;

    "Plugins")
      mise plugins ls | fzfui
      ;;

    "Install Plugin")

      local plugin
      plugin=$(mise plugins ls-remote | fzfui --prompt="Plugin > ")
      [[ -z "$plugin" ]] && return

      mise plugins install "$plugin"
      ;;

    "Remove Plugin")

      local plugin
      plugin=$(mise plugins ls | fzfui --prompt="Remove Plugin > ")
      [[ -z "$plugin" ]] && return

      mise plugins uninstall "$plugin"
      ;;

    "Update Plugins")
      mise plugins update
      ;;

    "Remote Versions")

      local tool
      tool=$(mise plugins ls | \
        fzfui \
        --prompt="Tool > " \
        --preview 'mise ls-remote {} | head -20' \
        --preview-window=right:60%)

      [[ -z "$tool" ]] && return

      mise ls-remote "$tool" | fzfui
      ;;

    "Reshim")
      mise reshim
      ;;

  esac
}