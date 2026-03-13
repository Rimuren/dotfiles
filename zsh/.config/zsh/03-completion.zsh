# ======================
# Completion System
# 03-completion.zsh
# ======================

# Extra completion BEFORE compinit
fpath+=("$ZSH_PLUGINS/zsh-completions/src")

# Cache completion
typeset -g ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump"
mkdir -p "${ZSH_COMPDUMP:h}"

# Rebuild only when plugins change
if [[ ! -f "$ZSH_COMPDUMP" ]] || \
   [[ -n "$(find "$ZSH_PLUGINS" -name '*.plugin.zsh' -newer "$ZSH_COMPDUMP" 2>/dev/null)" ]]; then
  echo "Rebuilding completion cache..."  # Optional feedback
  rm -f "$ZSH_COMPDUMP"
fi

autoload -Uz compinit
zmodload zsh/complist

compinit -i -C -d "$ZSH_COMPDUMP"

# UI tweaks
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'