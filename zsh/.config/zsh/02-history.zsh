# ======================
# History Configuration
# zsh/.config/zsh/02-history.zsh
# ======================
HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

mkdir -p "${HISTFILE:h}"