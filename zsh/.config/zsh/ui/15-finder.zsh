# =================================
# File Finder
# ~/.config/zsh/ui/15-finder.zsh
# =================================

# _ff_open — shared open logic for ff and ffh
_ff_open() {
  local files="$1" file count max=10

  count=$(echo "$files" | wc -l)
  if (( count > max )); then
    echo "Too many files selected ($count), opening first $max only."
    files=$(echo "$files" | head -n "$max")
  fi

  # disown prevents zombie processes
  while IFS= read -r file; do
    case "${file:e:l}" in
      jpg|jpeg|png|gif|webp|bmp|tiff|svg|ico|heic|avif)
        nohup loupe "$file" >/dev/null 2>&1 & disown ;;
      mp4|mkv|avi|mov|webm|flv|wmv|m4v|3gp|\
      mp3|flac|ogg|wav|aac|m4a|opus|wma)
        nohup mpv "$file" >/dev/null 2>&1 & disown ;;
      pdf)
        nohup evince "$file" >/dev/null 2>&1 & disown ;;
      zip|tar|gz|bz2|xz|rar|7z|zst|lz4)
        nohup file-roller "$file" >/dev/null 2>&1 & disown ;;
      txt|md|rst|conf|ini|toml|yaml|yml|\
      json|xml|sh|zsh|bash|fish|\
      py|js|ts|jsx|tsx|rs|go|c|cpp|h|hpp|\
      lua|vim|rb|php|java|kt|swift|css|html)
        nohup wezterm start -- micro "$file" >/dev/null 2>&1 & disown ;;
      *)
        nohup xdg-open "$file" >/dev/null 2>&1 & disown ;;
    esac
  done <<< "$files"
}

# _ff_location — pick search root, default is $HOME
# dynamically detects mounted partitions at runtime
_ff_location() {
  # always include Home first as default
  local entries="$HOME  (Home)"

  # collect relevant mount points: real block devices only,
  # skip boot/efi, pseudo filesystems, and bind mounts
  local skip_pattern='^(/|/boot|/boot/efi|/dev|/proc|/sys|/run|/tmp|/snap)$'
  while IFS= read -r mp; do
    [[ "$mp" == "$HOME" ]] && continue
    [[ "$mp" =~ $skip_pattern ]] && continue
    # get label from lsblk if available, fallback to basename of mountpoint
    local label
    label=$(lsblk -no LABEL,MOUNTPOINT 2>/dev/null | awk -v mp="$mp" '$2==mp {print $1}' | head -1)
    [[ -z "$label" ]] && label=$(basename "$mp")
    entries+="\n${mp}  (${label})"
  done < <(lsblk -lno MOUNTPOINT 2>/dev/null | grep -v '^$')

  printf '%b' "$entries" | \
    fzf \
      --height=~30% \
      --layout=reverse-list \
      --border \
      --prompt='Search in> ' \
      --header='Select location (Enter: confirm | Esc: default Home)' \
      --select-1 \
      --bind "esc:become(echo $HOME)" | \
    awk '{print $1}'
}

# _ff_cache_dir — returns cache dir path
_ff_cache_dir() { echo "${XDG_CACHE_HOME:-$HOME/.cache}/ff"; }

# _ff_index — get file list for a location, using cache for non-Home mounts
# cache is invalidated when the directory mtime changes
# $1 = location (absolute path), $2 = extra fd flags
_ff_index() {
  local location="$1" fd_flags="$2"
  local base="${location%/}"

  # always use live fd for $HOME — changes too frequently
  if [[ "$location" == "$HOME" ]]; then
    fd --type f $fd_flags --base-directory "$location" | sed "s|^|${base}/|"
    return
  fi

  # for other mounts, use cache
  local cache_dir cache_file mtime_file current_mtime cached_mtime
  cache_dir=$(_ff_cache_dir)
  # sanitize location to a safe filename
  local safe_name="${location//\//_}"
  cache_file="${cache_dir}/${safe_name}.cache"
  mtime_file="${cache_dir}/${safe_name}.mtime"

  mkdir -p "$cache_dir"
  # mtime check: depth 2 is fast; for deeper changes use 'ffr' to force rebuild
  current_mtime=$(find "$location" -maxdepth 2 -type d -printf '%T@\n' 2>/dev/null | sort -n | tail -1)
  cached_mtime=$(cat "$mtime_file" 2>/dev/null)

  if [[ ! -f "$cache_file" || "$current_mtime" != "$cached_mtime" ]]; then
    local tmp_file count
    tmp_file="${cache_file}.tmp"
    : > "$tmp_file"
    # pipe through awk for inline progress, all output goes to cache file
    fd --type f $fd_flags --base-directory "$location" | \
      sed "s|^|${base}/|" | \
      awk 'BEGIN{n=0} {print; n++; if(n%1000==0) printf "\r  %d files...", n > "/dev/stderr"}' \
      > "$tmp_file"
    count=$(wc -l < "$tmp_file")
    printf "\r\033[K%d files indexed. done.\n" "$count" >&2
    mv "$tmp_file" "$cache_file"
    echo "$current_mtime" > "$mtime_file"
  fi

  cat "$cache_file"
}

# _ff_pick — shared fzf picker
# $1 = extra fd flags (e.g. '--hidden'), $2 = prompt label
# outputs absolute paths by prepending location
_ff_pick() {
  local location
  location=$(_ff_location)
  [[ -z "$location" ]] && location='/'
  _ff_index "$location" "$1" | \
    fzfui \
      --multi \
      --prompt="$2> " \
      --header='Enter: open  |  Ctrl+Y: copy path' \
      --scheme=path \
      --filepath-word \
      --ellipsis='…/' \
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
}

# ff — fuzzy file finder (non-hidden files only)
# Enter: open file(s) with app based on extension
# Ctrl+Y: copy path(s) to clipboard
ff() {
  local files
  files=$(_ff_pick '' 'Files')
  [[ -z "$files" ]] && return
  _ff_open "$files"
}

# ffh — fuzzy file finder including hidden files (dotfiles, etc.)
# Enter: open file(s) with app based on extension
# Ctrl+Y: copy path(s) to clipboard
ffh() {
  local files
  files=$(_ff_pick '--hidden' 'Files (hidden)')
  [[ -z "$files" ]] && return
  _ff_open "$files"
}

# ffr — force rebuild cache for a mount (use after deep directory changes)
ffr() {
  local cache_dir location safe_name
  cache_dir=$(_ff_cache_dir)

  # pick which mount to rebuild
  location=$(_ff_location)
  [[ -z "$location" || "$location" == "$HOME" ]] && echo "ffr: cache only applies to non-Home mounts" && return

  safe_name="${location//\//_}"
  rm -f "${cache_dir}/${safe_name}.cache" "${cache_dir}/${safe_name}.mtime"
  printf "Indexing %s...\n" "$location"
  _ff_index "$location" '' > /dev/null
}
