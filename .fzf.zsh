# Setup fzf
# ---------
if [[ ! "$PATH" == *${HOME}/.cache/dein/repos/github.com/junegunn/fzf/bin* ]]; then
  export PATH="$PATH:${HOME}/.cache/dein/repos/github.com/junegunn/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/.cache/dein/repos/github.com/junegunn/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOME}/.cache/dein/repos/github.com/junegunn/fzf/shell/key-bindings.zsh"

# setting
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_COMPLETION_TRIGGER=','

