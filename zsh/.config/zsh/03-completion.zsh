# ======================
# Completion System
# ~/.config/zsh/03-completion.zsh
# ======================

# Extra completions must be added to fpath before compinit
fpath+=("$ZSH_PLUGINS/zsh-completions/src")

typeset -g ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump"
mkdir -p "${ZSH_COMPDUMP:h}"

autoload -Uz compinit
zmodload zsh/complist

# Rebuild cache only when plugins are newer than the dump
if [[ ! -f "$ZSH_COMPDUMP" ]] || \
   [[ -n "$(find "$ZSH_PLUGINS" -name '*.plugin.zsh' -newer "$ZSH_COMPDUMP" 2>/dev/null)" ]]; then
  compinit -i -d "$ZSH_COMPDUMP"
else
  compinit -i -C -d "$ZSH_COMPDUMP"   # -C skips check, faster startup
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''