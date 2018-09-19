# --------------------------------------
# use vi mode
# --------------------------------------
set -o vi

# --------------------------------------
# enable bash-completion
# --------------------------------------
if [ -f /usr/local/Cellar/bash-completion/1.3_1/etc/profile.d/bash_completion.sh ]; then
  . /usr/local/Cellar/bash-completion/1.3_1/etc/profile.d/bash_completion.sh
fi

# --------------------------------------
# use rmtrash command instead of rm
# --------------------------------------
if type rmtrash > /dev/null 2>&1; then
    alias rm='rmtrash'
fi

# --------------------------------------
# brew-file
#
# Update Brewfile after used brew command
# --------------------------------------
if type brew > /dev/null 2>&1; then
    if [ -f $(brew --prefix)/etc/brew-wrap ];then
        source $(brew --prefix)/etc/brew-wrap
    fi
fi
# --------------------------------------
# enable bash-completion
# --------------------------------------
if [ -f /usr/local/Cellar/bash-completion/1.3_1/etc/profile.d/bash_completion.sh ]; then
  . /usr/local/Cellar/bash-completion/1.3_1/etc/profile.d/bash_completion.sh
fi 
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
PYTHONPATH='/Users/kitagawaharuki/da-workflow'


# --------------------------------------
# alias 
# --------------------------------------
# commands 
alias la='ls -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rm='rm -i'
alias mv='mv -i'

# git
alias gs='git status'
alias gss='git status --short --branch'
alias gr="git log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'"
alias gb='git branch'
alias cm='git commit -m'
alias push='git push'
alias add='git add'
alias pull='git pull'
