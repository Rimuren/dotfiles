# ======================
# FZF Helper
# zsh/.config/zsh/helpers/10-fzf.zsh
# ======================

# Base fzf wrapper with consistent UI defaults.
# Caller options override these defaults.
# Usage: some-cmd | fzfui [fzf-options...]
# Example: fzfui --preview 'bat --color=always {}'
fzfui() {
  fzf \
    --height=~70% \
    --layout=reverse-list \
    --border \
    --cycle \
    --preview-window=right:60%:wrap \
    --preview 'echo {}' \
    "$@"
}
