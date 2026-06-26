# =============================
# Aliases
# ~/.config/zsh/05-aliases.zsh
# =============================

# Use eza if available, fallback to ls
if command -v eza &>/dev/null; then
  alias ls='eza -ah --icons --group-directories-first'
  alias ll='eza -alh --icons --group-directories-first --git'
  alias tree='eza --tree --icons'
else
  alias ls='ls -ah --color=auto'
  alias ll='ls -alh --color=auto'
fi

alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias c='clear'

# pkill returns non-zero if process not found — suppress with ||:
alias wez='pkill -x wezterm-gui ||:; sleep 0.2; wezterm'
alias rmpcr='pkill -x rmpc ||:; systemctl --user restart mpd; rmpc'

alias mstatus='mpc status'
alias mstop='mpc stop'
alias mpause='mpc pause'
alias mplay='mpc play'

alias Sybau='sudo pacman -Syu'
