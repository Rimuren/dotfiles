# ======================
# Completion System
# 03-completion.zsh
# ======================

# Extra completion BEFORE compinit
fpath+=("$ZSH_PLUGINS/zsh-completions/src")

zmodload zsh/complist
autoload -Uz compinit

mkdir -p ~/.cache/zsh
compinit -i -C -d ~/.cache/zsh/zcompdump

# UI tweaks
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'