# stow-all: stow packages listed in ~/dotfiles/.stow-packages
# usage: stow-all [--dry-run] [--remove]
function stow-all() {
  local dotfiles="${DOTFILES:-$HOME/dotfiles}"
  local config="$dotfiles/.stow-packages"
  local flags=()

  for arg in "$@"; do
    case "$arg" in
      --dry-run) flags+=(--simulate) ;;
      --remove)  flags+=(-D) ;;
      *) echo "usage: stow-all [--dry-run] [--remove]"; return 1 ;;
    esac
  done

  [[ ! -f "$config" ]] && { echo "error: $config not found"; return 1; }

  local packages
  packages=(${(f)"$(grep -vE '^\s*(#|$)' "$config")"})
  [[ ${#packages} -eq 0 ]] && { echo "no packages listed in $config"; return 0; }

  echo "action:   ${flags[*]:-apply}"
  echo "packages: ${packages[*]}"
  cd "$dotfiles" || return 1

  for pkg in "${packages[@]}"; do
    [[ ! -d "$dotfiles/$pkg" ]] && { echo "skip: $pkg (not found)"; continue; }
    echo "stow $pkg"
    stow "${flags[@]}" "$pkg"
  done

  echo "done."
}
