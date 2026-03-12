# ======================
# Bash Configuration
# ======================

# Stop if not interactive
[[ $- != *i* ]] && return

# Load Environment
[[ -f ~/.config/bash/env.sh ]] && source ~/.config/bash/env.sh

# Load Functions
[[ -f ~/.config/bash/functions.sh ]] && source ~/.config/bash/functions.sh

# ===== Prompt =====
PS1='[\u@\h \W]\$ '

# ===== Completion =====
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# ===== Startup Info =====
if [[ $- == *i* ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi