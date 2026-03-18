# ======================
# Aliases
# 05-aliases.zsh
# ======================

alias ls='ls -ah --color=auto'
alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias c='clear'
alias wez='killall wezterm-gui 2>/dev/null; wezterm'
alias rmpcr='killall rmpc 2>/dev/null; systemctl --user restart mpd; rmpc'

alias mstatus='mpc status'
alias mstop='mpc stop'
alias mpause='mpc pause'
alias mplay='mpc play'

alias Sybau='sudo pacman -Syu'
