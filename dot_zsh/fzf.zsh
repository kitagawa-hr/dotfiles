# Setup fzf
# setting

export FZF_REPO="$(brew --prefix)/opt/fzf"
if [[ ! "$PATH" == *${FZF_REPO}/bin* ]]; then
  export PATH="$PATH:${FZF_REPO}/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${FZF_REPO}/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${FZF_REPO}/shell/key-bindings.zsh"

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_COMPLETION_TRIGGER=','

# Custom fuzzy completion for "docker" command
#   e.g. docker **<TAB>
export DOCKER_FZF_PREFIX="--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"

_fzf_complete_docker_run_post() {
    awk '{print $1":"$2}'
}

_fzf_complete_docker_run () {
    _fzf_complete "$DOCKER_FZF_PREFIX -m --header-lines=1" "$@" < <(
        docker images
    )
}

_fzf_complete_docker_common_post() {
    awk -F"\t" '{print $1}'
}

_fzf_complete_docker_common () {
    _fzf_complete "$DOCKER_FZF_PREFIX --reverse -m" "$@" < <(
        docker images --format "{{.Repository}}:{{.Tag}}\t {{.ID}}"
    )
}

_fzf_complete_docker_container_post() {
    awk '{print $NF}'
}

_fzf_complete_docker_container () {
    _fzf_complete "$DOCKER_FZF_PREFIX -m --header-lines=1" "$@" < <(
        docker ps -a
    )
}


_fzf_complete_docker() {
    local tokens docker_command
    setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
    # http://zsh.sourceforge.net/FAQ/zshfaq03.html
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
    tokens=(${(z)LBUFFER})
    if [ ${#tokens} -le 2 ]; then
        return
    fi
    docker_command=${tokens[2]}
    case "$docker_command" in
        run)
            _fzf_complete_docker_run "$@"
            return
        ;;
        exec|rm)
            _fzf_complete_docker_container "$@"
            return
        ;;
        save|load|push|pull|tag|rmi)
            _fzf_complete_docker_common "$@"
            return
        ;;
    esac
  }

  _fzf_complete_git() {
    ARGS="$@"
    local branches
    branches=$(git branch -vv --all)
    if [[ $ARGS == 'git'* ]]; then
        _fzf_complete "--reverse --multi" "$@" < <(
            echo $branches
        )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_git_post() {
    awk '{print $1}'
}
