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
  atload"!_zsh_autosuggest_start" zsh-users/zsh-autosuggestions
