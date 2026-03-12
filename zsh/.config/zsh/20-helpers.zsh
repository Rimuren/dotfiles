# ======================
# Helper Functions Loader
# /zsh/.config/zsh/20-helpers.zsh
# ======================

for file in "$HOME/.config/zsh/helpers/"*.zsh; do
  [[ -r "$file" ]] && source "$file"
done