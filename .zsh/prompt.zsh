# Init Powerline
powerline-daemon -q
. ~/.local/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh 

autoload vcs_info
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" formats "⭠ %r ⮁ %b%u%c"
zstyle ":vcs_info:git:*" actionformats "⭠ %r ⮁ %b%u%c ⮁ %a"
zstyle ":vcs_info:git:*" unstagedstr " ⮁ Unstaged"
zstyle ":vcs_info:git:*" stagedstr " ⮁ Staged"

git_is_track_branch(){
    if [ "$(git remote 2>/dev/null)" != "" ]; then
        local target_tracking_branch="origin/$(git rev-parse --abbrev-ref HEAD)"
        for tracking_branch in $(git branch -ar) ; do
            if [ "$target_tracking_branch" = "$tracking_branch" ]; then
                echo "true"
            fi
        done
    fi
}

git_info_pull(){
    if [ -n "$(git_is_track_branch)" ]; then
        local current_branch="$(git rev-parse --abbrev-ref HEAD)"
        local head_rev="$(git rev-parse HEAD)"
        local origin_rev="$(git rev-parse origin/$current_branch)"
        if [ "$head_rev" != "$origin_rev" ] && [ "$(git_info_push)" = "" ]; then
                echo " ⮁ Can Be Pulled"
        fi
    fi
}

git_info_push(){
    if [ -n "$(git_is_track_branch)" ]; then
        local current_branch="$(git rev-parse --abbrev-ref HEAD)"
        local push_count=$(git rev-list origin/"$current_branch".."$current_branch" 2>/dev/null | wc -l)
        if [ "$push_count" -gt 0 ]; then
            echo " ⮁ Can Be Pushed($push_count)"
        fi
    fi
}

function update_git_info() {
    LANG=en_US.UTF-8 vcs_info
    _vcs_info=$vcs_info_msg_0_
    _git_info_push=$(git_info_push)
    _git_info_pull=$(git_info_pull)
    if [ -n "$_vcs_info" ]; then
        local BG_COLOR=green

        if [ -n "$_git_info_push" ] || [ -n "$_git_info_pull" ]; then
          BG_COLOR=yellow
          FG_COLOR=black
        fi

        if [[ -n `echo $_vcs_info | grep -Ei "merge|unstaged|staged" 2> /dev/null` ]]; then
            BG_COLOR=red
            FG_COLOR=white
        fi
        echo "%{%K{$BG_COLOR}%}⮀%{%F{$FG_COLOR}%} $_vcs_info$_git_info_push$_git_info_pull %{%F{$BG_COLOR}%K{magenta}%}⮀"
    else
       echo "%{%K{magenta}%}⮀"
    fi
}

PROMPT_HOST='%{%b%F{gray}%K{blue}%} %(?.%{%F{green}%}✔.%{%F{red}%}✘)%{%F{black}%} %n %{%F{blue}%}'
PROMPT_DIR='%{%F{black}%} %~%  '
PROMPT_SU='%(!.%{%k%F{blue}%K{black}%}⮀%{%F{yellow}%} ⚡ %{%k%F{black}%}.%{%k%F{magenta}%})⮀%{%f%k%b%}'
PROMPT='
%{%f%b%k%}$PROMPT_HOST$(update_git_info)$PROMPT_DIR$PROMPT_SU
%{%f%b%K{blue}%} %{%F{black}%}$ %{%k%F{blue}⮀%{%f%k%b%} '
SPROMPT='${WHITE}%r is correct? [n,y,a,e]: %{$reset_color%}'
function powerline_precmd() {
    PS1="$(~/go/bin/powerline-go -error $? -shell zsh)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi
