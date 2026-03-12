# ======================
# File Finder
# /zsh/.config/zsh/ui/finder.zsh
# ======================

ff() {
  local files
  files=$(fd --type f | fzf -m --preview '
    if file --mime-type {} | grep -qE "image/"; then
      chafa {} --fill=block --symbols=block --size=40x20
    elif file --mime-type {} | grep -qE "text/"; then
      bat --style=numbers --color=always {} 2>/dev/null
    else
      eza -l --color=always {} 2>/dev/null || ls -lh {}
    fi
  ')
  if [[ -n "$files" ]]; then
    local count max=10
    count=${(f)#files}
    if (( count > max )); then
      echo "⚠️  Limit is $max files, opening first $max only."
      files=$(printf "%s\n" "$files" | head -n $max)
    fi
    echo "$files" | while IFS= read -r f; do nohup xdg-open "$f" >/dev/null 2>&1 & done
  fi
}
