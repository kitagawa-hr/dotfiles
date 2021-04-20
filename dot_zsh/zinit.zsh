# install zinit if not installed
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin"
fi

# init zinit
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# install packages
zinit wait lucid light-mode for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" zdharma/fast-syntax-highlighting \
  blockf zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start; export ZSH_AUTOSUGGEST_USE_ASYNC=1" zsh-users/zsh-autosuggestions \
  depth=1 jeffreytse/zsh-vi-mode \
  atload"typeset -g ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT='true'" kutsan/zsh-system-clipboard

zinit lucid from'gh-r' as'program' for \
  mv'zoxide* -> zoxide' atload'eval "$(zoxide init zsh)"' ajeetdsouza/zoxide \
  mv'mcfly* -> mcfly' atload'eval "$(mcfly init zsh)"; export MCFLY_KEY_SCHEME=vim; export MCFLY_FUZZY=true' cantino/mcfly \
  mv'skim* -> sk' lotabout/skim
