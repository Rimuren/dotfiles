# ======================
# FZF Helper
# /zsh/.config/zsh/helpers/fzf.zsh
# ======================

fzfui() {
  fzf \
    --height=~70% \
    --layout=reverse-list \
    --border \
    --cycle \
    --preview-window=right:60%:wrap \
    "$@"
}