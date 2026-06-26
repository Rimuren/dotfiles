# =================================
# File Finder
# ~/.config/zsh/ui/15-finder.zsh
# =================================

# ff — fuzzy file finder with smart preview
# Enter: open file(s) with xdg-open
# Ctrl+Y: copy path(s) to clipboard
ff() {
  local files file count max=10

  files=$(
    fd --type f |
    fzfui \
      --multi \
      --prompt='Files> ' \
      --header='Enter: open  |  Ctrl+Y: copy path' \
      --preview '
        mime=$(file --brief --mime-type {})
        case "$mime" in
          image/*)
            chafa {} --fill=block --symbols=block --size=70x30 2>/dev/null
            ;;
          application/pdf)
            pdftotext {} - 2>/dev/null | head -100 | bat --language=text --style=plain --color=always
            ;;
          text/*|application/json|application/xml)
            bat --style=numbers --color=always {} 2>/dev/null
            ;;
          *)
            file --brief {}
            eza -lh --color=always {} 2>/dev/null
            ;;
        esac
      ' \
      --bind 'ctrl-y:execute-silent(echo {+} | xclip -selection clipboard)+abort'
  )

  [[ -z "$files" ]] && return

  # Count selected files — fixed from original broken syntax
  count=$(echo "$files" | wc -l)

  if (( count > max )); then
    echo "Too many files selected ($count), opening first $max only."
    files=$(echo "$files" | head -n "$max")
  fi

  # disown prevents zombie processes
  while IFS= read -r file; do
    nohup xdg-open "$file" >/dev/null 2>&1 &
    disown
  done <<< "$files"
}
