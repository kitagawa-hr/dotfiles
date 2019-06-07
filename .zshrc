#!/usr/local/bin/zsh

# 色を使用出来るようにする
autoload -Uz colors
colors


# pyenv init
if [ -e ~/.pyenv ]; then
    eval "$(pyenv init -)"
fi

# Init pyenv-virtualenv
if [ -e ~/.pyenv/plugins/virtualenv ]; then
    eval "$(pyenv virtualenv-init -)"
fi 

# pipenv completion
which pipenv > /dev/null 2>&1 && eval "$(pipenv --completion)"

# load settings
source ~/.zsh/completion.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/alias.zsh
source ~/.zsh/keybind.zsh
source ~/.zsh/zplug.zsh
source ~/.zsh/functions.zsh
source ~/.fzf.zsh

# OS別設定読み込み
case ${OSTYPE} in
    darwin*)
        source ~/.zshrc.osx
        ;;
    linux*)
        source ~/.zshrc.linux
        ;;
esac
# auto zcompile
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi

# tmux auto start
if [[ ! -n $TMUX && $- == *l* ]]; then
  # get the IDs
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | $PERCOL | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    :  # Start terminal normally
  fi
fi



# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kitagawaharuki/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kitagawaharuki/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kitagawaharuki/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kitagawaharuki/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/kitagawaharuki/.sdkman"
[[ -s "/Users/kitagawaharuki/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/kitagawaharuki/.sdkman/bin/sdkman-init.sh"

source /Users/kitagawaharuki/Library/Preferences/org.dystroy.broot/launcher/bash/br
