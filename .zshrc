
#!/usr/local/bin/zsh

# load settings
source ~/.zsh/completion.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/fzf.zsh
source ~/.zsh/alias.zsh
source ~/.zsh/keybind.zsh
source ~/.zsh/zplug.zsh
export EDITOR='nvim'
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



# 色を使用出来るようにする
autoload -Uz colors
colors

# Python
# Init pyenv
if [ -e ~/.pyenv ]; then
    eval "$(pyenv init -)"
    if type aws > /dev/null 2>&1; then
        source "$(pyenv which aws_zsh_completer.sh)"
    fi
fi
# Init pyenv-virtualenv
if [ -e ~/.pyenv/plugins/virtualenv ]; then
    eval "$(pyenv virtualenv-init -)"
fi 

