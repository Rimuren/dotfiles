# ===== Environment =====

export EDITOR="micro"
export VISUAL="micro"
export PATH="$HOME/.local/bin:$HOME/.config/composer/vendor/bin:$PATH"
export COLORTERM=truecolor

# ===== History =====
HISTFILE=$HOME/.config/bash/history
HISTSIZE=10000
HISTFILESIZE=10000

shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r"