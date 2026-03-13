# ======================
# File Finder
# /zsh/.config/zsh/ui/finder.zsh
# ======================

ff() {
  local files
  files=$(fd --type f | fzf -m --preview '
    mime=$(file --brief --mime-type {})
    case "$mime" in
      image/*)
        chafa {} --fill=block --symbols=block --size=70x30 2>/dev/null
        ;;
      text/*)
        bat --style=numbers --color=always {} 2>/dev/null
        ;;
      *)
        eza -l --color=always {} 2>/dev/null || ls -lh {}
        ;;
    esac
  ')
  if [[ -n "$files" ]]; then
    local count max=10
    count=${(f)#files}
    if (( count > max )); then
      echo "Limit is $max files, opening first $max only."
      files=$(printf "%s\n" "$files" | head -n $max)
    fi
    echo "$files" | while IFS= read -r f; do nohup xdg-open "$f" >/dev/null 2>&1 & done
  fi
}
