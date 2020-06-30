# zplug settings
source ${HOME}/.zplug/init.zsh

# set install plugins
zplug 'zplug/zplug', \
    hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-syntax-highlighting", \
    defer:2

zplug "zsh-users/zsh-autosuggestions"

zplug "b4b4r07/enhancd", \
    use:init.sh

zplug "zsh-users/zsh-completions", \
    lazy:true

zplug "mafredri/zsh-async",\
    from:github, \
    lazy:true

zplug "jonas/tig", \
    use: "contrib/tig-completion.zsh"

zplug "greymd/tmux-xpanes"

zplug "felixr/docker-zsh-completion"


# Set enhancd filters
export ENHANCD_FILTER=fzf:peco

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# load zsh plugins
zplug load

