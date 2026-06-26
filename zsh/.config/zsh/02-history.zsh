# ===============================
# History Configuration
# ~/.config/zsh/02-history.zsh
# ===============================
HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

mkdir -p "${HISTFILE:h}"

setopt \
  hist_ignore_dups \
  hist_ignore_all_dups \
  hist_save_no_dups \
  hist_reduce_blanks \
  hist_ignore_space \
  hist_verify \
  append_history \
  inc_append_history \
  extended_history
