# =================================
# Fuzzy Cleaner
# ~/.config/zsh/ui/16-cleaner.zsh
# =================================

# fclean — fuzzy search application leftovers
#
# Usage:
#   fclean helix
#   fclean
#
# Keybinds:
#   Tab    → select item(s)
#   Enter  → print selected path(s)
#   Ctrl-Y → copy selected path(s) to clipboard
#   Esc    → cancel

fclean() {
  local query="$*"

  if [[ -z "$query" ]]; then
    query=$(printf '' | fzfui \
      --prompt='Search> ' \
      --header='Enter application/package name to search')
    [[ -z "$query" ]] && return
  fi

  # --- Package manager info (printed before fzf) ---

  # pacman/yay: check if still installed
  if pacman -Q "$query" &>/dev/null; then
    echo "⚠  pacman: '$query' is still installed — uninstall first"
    echo "   Run: yay -Rns $query"
    echo
  fi

  # pacman/yay: show leftover owned files (files not cleaned by uninstall)
  # pacman -Ql lists all files that *were* owned; cross-check with what still exists
  local pacman_leftovers=()
  if pacman -Ql "$query" &>/dev/null; then
    while IFS= read -r f; do
      [[ -e "$f" ]] && pacman_leftovers+=("$f")
    done < <(pacman -Ql "$query" 2>/dev/null | awk '{print $2}')
  fi

  # flatpak: check installed and data dirs
  local flatpak_app_id=""
  if command -v flatpak &>/dev/null; then
    flatpak_app_id=$(flatpak list --app --columns=application 2>/dev/null | grep -i "$query" | head -1)
    if [[ -n "$flatpak_app_id" ]]; then
      echo "⚠  flatpak: '$flatpak_app_id' is still installed — uninstall first"
      echo "   Run: flatpak uninstall $flatpak_app_id"
      echo
    fi
  fi

  # --- Filesystem search dirs ---
  local search_dirs=(
    # User dirs
    "$HOME/.config"
    "$HOME/.cache"
    "$HOME/.local/share"
    "$HOME/.local/state"
    "$HOME/.local/bin"
    "$HOME/.local/lib"
    "$HOME/.local/etc"
    "$HOME/.local/share/applications"
    "$HOME/.local/share/icons"
    "$HOME/.local/share/fonts"
    "${XDG_DATA_HOME:-$HOME/.local/share}/systemd/user"
    # Flatpak user data
    "$HOME/.var/app"
    "$HOME/.local/share/flatpak"
    # System dirs
    "/etc"
    "/usr/share/applications"
    "/usr/local/share/applications"
    "/usr/share/icons"
    "/usr/share/pixmaps"
    "/usr/lib/systemd/system"
    "/etc/systemd/system"
    "/usr/lib/systemd/user"
    "/etc/xdg"
    "/opt"
  )

  local existing_dirs=()
  for d in "${search_dirs[@]}"; do
    [[ -d "$d" ]] && existing_dirs+=("$d")
  done

  local paths
  paths=$(
    {
      # Filesystem matches
      find "${existing_dirs[@]}" -iname "*${query}*" -print 2>/dev/null

      # Pacman-owned files still on disk
      for f in "${pacman_leftovers[@]}"; do
        echo "$f"
      done

      # Flatpak data dirs for matched app id
      if [[ -n "$flatpak_app_id" ]]; then
        find "$HOME/.var/app/$flatpak_app_id" \
             "$HOME/.local/share/flatpak/app/$flatpak_app_id" \
             -print 2>/dev/null
      fi
    } | sort -u
  )

  if [[ -z "$paths" ]]; then
    echo "No leftovers found for: $query"
    return 1
  fi

  local selected
  selected=$(
    printf '%s\n' "$paths" |
    fzfui \
      --multi \
      --prompt="Leftovers [$query]> " \
      --header='Tab: select  |  Enter: print paths  |  Ctrl+Y: copy  |  Esc: cancel' \
      --scheme=path \
      --filepath-word \
      --ellipsis='…/' \
      --preview 'PATH=/usr/bin:/bin:/usr/local/bin
        if [[ -d {} ]]; then
          echo "DIRECTORY"
          echo
          du -sh {} 2>/dev/null
          echo
          eza -la --color=always {} 2>/dev/null
        else
          echo "FILE"
          echo
          ls -lh --color=always {} 2>/dev/null
          echo
          file --brief {}
        fi
      ' \
      --preview-window='right:45%:wrap' \
      --bind 'ctrl-y:execute-silent(echo -n {+} | xclip -selection clipboard)+abort'
  )

  [[ -z "$selected" ]] && return

  echo
  echo "Selected paths:"
  echo "$selected"
}
