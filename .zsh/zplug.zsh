# zplug settings
source $HOME/.zplug/init.zsh

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

zplug "peco/peco", \
    as:command, \
    from:gh-r, \
    frozen:1

zplug "mafredri/zsh-async",\
    from:github, \
    lazy:true


zplug "b-ryan/powerline-shell", \
  from:github, \
  hook-build:"python3 setup.py install"

zplug "supercrabtree/k"

zplug "junegunn/fzf-bin", \
    as:command, \
    from:gh-r, \
    rename-to:"fzf"

zplug "junegunn/fzf", \
    as:command, \
    use:"bin/fzf-tmux"

zplug "stedolan/jq", \
    as:command, \
    from:gh-r, \
    rename-to:jq

zplug "monochromegane/the_platinum_searcher", \
    as:command, \
    from:gh-r, \
    rename-to:pt, \
    frozen:1

zplug "jonas/tig", \
    use: "contrib/tig-completion.zsh"

zplug "motemen/ghq", \
    as:command, \
    from:gh-r, \
    rename-to:ghq


zplug "b4b4r07/gist", \
    as:command, \
    from:gh-r, \
    rename-to:"gist"

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

