
#!/usr/local/bin/zsh
# 色を使用出来るようにする
autoload -Uz colors
colors

# load settings
source ~/.zsh/completion.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/fzf.zsh
source ~/.zsh/alias.zsh
source ~/.zsh/keybind.zsh
source ~/.zsh/zplug.zsh
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




