# ===========================
# FZF Integration (CTRL + R)
# 06-fzf.zsh
# ===========================

if command -v fzf &>/dev/null; then
  fzf-history() {
	local selected
	selected=$(fc -l 1 | awk '!seen[$0]++' | fzf --height=40% --reverse --border)
	[[ -n $selected ]] && BUFFER=$selected

	CURSOR=$#BUFFER
	  
	zle reset-prompt
  }
  zle -N fzf-history
  bindkey '^R' fzf-history
fi
