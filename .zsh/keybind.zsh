# vi key bind
bindkey -v
# vim key bind
bindkey -M viins 'jj' vi-cmd-mode
# Add emacs-like keybind to viins mode
bindkey -M viins '^F'  forward-char
bindkey -M viins '^B'  backward-char
# bindkey -M viins '^P'  up-line-or-history
# bindkey -M viins '^N'  down-line-or-history
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^K'  kill-line
# bindkey -M viins '^R'  history-incremental-pattern-search-backward
# bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^Y'  yank
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^D'  delete-char-or-list

bindkey -M vicmd '^A'  beginning-of-line
bindkey -M vicmd '^E'  end-of-line
bindkey -M vicmd '^K'  kill-line
bindkey -M vicmd '^P'  up-line-or-history
bindkey -M vicmd '^N'  down-line-or-history
bindkey -M vicmd '^Y'  yank
bindkey -M vicmd '^W'  backward-kill-word
bindkey -M vicmd '^U'  backward-kill-line
bindkey -M vicmd '/'   vi-history-search-forward
bindkey -M vicmd '?'   vi-history-search-backward

bindkey -M vicmd 'gg' beginning-of-line
bindkey -M vicmd 'G'  end-of-line

# Insert a last word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey -M viins '^]' insert-last-word


# Surround a forward word by single quote
quote-previous-word-in-single() {
 '${(qq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N quote-previous-word-in-single
bindkey -M viins '^Q' quote-previous-word-in-single

# Surround a forward word by double quote
quote-previous-word-in-double() {
    modify-current-argument '${(qqq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N quote-previous-word-in-double
bindkey -M viins '^Xq' quote-previous-word-in-double

bindkey -M viins "$terminfo[kcbt]" reverse-menu-complete


#
# functions
#
_fzf-select-history() {
    if true; then
        BUFFER="$(
        history 1 \
            | sort -k1,1nr \
            | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' \
            | fzf --query "$LBUFFER"
        )"

        CURSOR=$#BUFFER
        #zle accept-line
        #zle clear-screen
        zle reset-prompt
    else
        if is-at-least 4.3.9; then
            zle -la history-incremental-pattern-search-backward && bindkey "^r" history-incremental-pattern-search-backward
        else
            history-incremental-search-backward
        fi
    fi
}
zle -N _fzf-select-history
bindkey '^r' _fzf-select-history

_delete-char-or-list-expand() {
    if [ -z "$RBUFFER" ]; then
        zle list-expand
    else
        zle delete-char
    fi
}
zle -N _delete-char-or-list-expand
bindkey '^D' _delete-char-or-list-expand


function is_git_repo()
{
    dir="${1:-$PWD}"
    dirname=$(dirname "$dir")

    [ -d "$dir/.git" ]   && return 0
    [ "$dirname" = "/" ] && return 1

    is_git_repo "$dirname"
    return $?
}

do-enter() {
    if [[ -n $BUFFER ]]; then
        zle accept-line
        return $status
    fi

    : ${ls_done:=false}
    : ${git_ls_done:=false}

    if [[ $PWD != $GIT_OLDPWD ]]; then
        git_ls_done=false
    fi

    echo
    if is_git_repo; then
        if $git_ls_done; then
            if [[ -n $(git status --short) ]]; then
                git status
            fi
        else
            ${=aliases[ls]} && git_ls_done=true
            GIT_OLDPWD=$PWD
        fi
    else
        if [[ $PWD != $OLDPWD ]] && ! $ls_done; then
            ${=aliases[ls]} && ls_done=true
        fi
    fi

    zle reset-prompt
}
zle -N do-enter
bindkey '^m' do-enter

# expand global aliases by space
# http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
globalias() {
  if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
    zle _expand_alias
    # zle expand-word
  fi
  zle self-insert
}

zle -N globalias

bindkey " " globalias



 #Checkout git branch (including remote branches)
fzf-git-branch-checkout() {
    local BRANCHES BRANCH
    BRANCHES=`git branch --all | grep -v HEAD`
    BRANCH=`echo "$BRANCHES" | fzf -d $(( 2 + $(wc -l <<< "$BRANCHES") )) +m`
    if [ -n "$BRANCH" ]; then
        git checkout $(echo "$BRANCH" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    fi
    zle accept-line
}
zle -N fzf-git-branch-checkout
bindkey "^S" fzf-git-branch-checkout

# ssh selected host
function fzf-ssh-host() {
    local SSH_HOST=$(awk '
        tolower($1)=="host" {
            for (i=2; i<=NF; i++) {
                if ($i !~ "[*?]") {
                    print $i
                }
            }
        }
    ' ~/.ssh/config | sort | fzf +m)
    if [ -n "$SSH_HOST" ]; then
        BUFFER="ssh $SSH_HOST"
    fi
    zle accept-line
}
zle -N fzf-ssh-host

# open file with editor
fzf-vim-open-file() {
    local FILE=$(rg --files --hidden -g \
        '!*.git' | fzf +m)
    if [ -n "$FILE" ]; then
        BUFFER="${EDITOR:-nvim} $FILE"
    fi
    zle accept-line
}
zle -N fzf-vim-open-file
bindkey '^O' fzf-vim-open-file

parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

git_status(){  
  local c_reset='\e[0m'
  local c_branch='\e[1;34m' # bold cyan
  local c_git_clean='\e[0;37m' # white
  local c_git_staged='\e[0;32m' # green
  local c_git_unstaged='\e[0;31m' # red
  local git_st=
  local FILE_NUM
  local git_where="${parse_git_branch}"
  local GIT_BRANCH="${git_where#(refs/heads/|tags/)}"
  
  if [ ${#GIT_BRANCH} -eq 40 ]; then
    GIT_BRANCH="(no branch)"
  fi
  local STATUS=`git status --porcelain`
  if [ -z "$STATUS" ]; then
    git_color="${c_git_clean}"
    git_st="clean"
  else
    FILE_NUM=`git status --porcelain | wc -l | tr -d '[:space:]'`
    echo -e "$STATUS" | grep -q '^ [A-Z\?]'
    if [ $? -eq 0 ]; then
      git_color="${c_git_unstaged}"
      git_st="unstaged ${FILE_NUM}"
    else
      git_color="${c_git_staged}"
      git_st="staged ${FILE_NUM}"
    fi
  fi 
  printf "${c_branch}${GIT_BRANCH}${c_reset}"
  printf " => ${git_color}${git_st}${c_reset}\n"
}

ghq-status(){
  
  local CUR_DIR=`pwd`
  local GHQ_ROOT=`ghq root`
  local GHQ_LIST=(`ghq list`)
  printf "\n"
  for local ghq_repo in $GHQ_LIST;do
    cd ${GHQ_ROOT}/${ghq_repo}
    printf "%-40s" ${ghq_repo}
    git_status
  done
  cd ${CUR_DIR}
  zle accept-line
}
zle -N ghq-status
bindkey '^N' ghq-status

