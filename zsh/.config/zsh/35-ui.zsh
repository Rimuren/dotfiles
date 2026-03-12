# ======================
# UI Tools Loader
# /zsh/.config/zsh/30-ui.zsh
# ======================

for file in "$HOME/.config/zsh/ui/"*.zsh; do
  [[ -r "$file" ]] && source "$file"
done