# ======================
# Environment Variables
# zsh/.config/zsh/00-env.zsh
# ======================

# XDG base dirs — many tools follow these
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR="micro"
export VISUAL="micro"
export PATH="$HOME/.local/bin:$XDG_CONFIG_HOME/composer/vendor/bin:$PATH"
export MPD_HOST="$XDG_CONFIG_HOME/mpd/socket"
export COLORTERM=truecolor
export STARSHIP_LOG=error
export ZSH_PLUGINS="$XDG_CONFIG_HOME/zsh/plugins/manual"