# stow-all: stow semua package dotfiles
# usage: stow-all [--dry-run] [--remove]
function stow-all() {
  local dotfiles="${DOTFILES:-$HOME/dotfiles}"
  local flags=()
  local packages=(bash zsh atuin wezterm fastfetch starship mpd mpDris2 rmpc cava scripts fonts superfile)

  for arg in "$@"; do
    case "$arg" in
      --dry-run) flags+=(--simulate) ;;
      --remove)  flags+=(-D) ;;
      *) echo "usage: stow-all [--dry-run] [--remove]"; return 1 ;;
    esac
  done

  echo "action:   ${flags[*]:-apply}"
  echo "packages: ${packages[*]}"
  cd "$dotfiles" || return 1

  for pkg in "${packages[@]}"; do
    [[ ! -d "$dotfiles/$pkg" ]] && { echo "skip: $pkg (not found)"; continue; }
    echo "stow $pkg"
    stow "${flags[@]}" "$pkg"
  done

  [[ -z "${flags[*]/*-D*/}" ]] || fc-cache -fv
  echo "done."
}
