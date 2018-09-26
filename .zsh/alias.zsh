# application
alias jb='jupyter notebook'
alias jl='jupyter lab'
alias v='nvim'

# commands 
alias la='ls -a'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rm='rm -i'
alias mv='mv -i'

# git
alias gs='git status'
alias gss='git status --short --branch'
alias gr="git log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'"
alias g='cd $(ghq root)/$(ghq list | fzf)'
alias gh='hub browse $(ghq list | fzf | cut -d "/" -f 2,3)'
alias gch='git checkout `git branch | fzf | sed -e "s/\* //g" | awk "{print \$1}"`'
alias gca='git checkout `git branch --all | peco | sed -e "s/\* //g" | awk "{print \$1}"`'
alias gb='git branch'
alias cm='git commit -m'
alias push='git push origin HEAD'
alias add='git add'
alias pull='git pull'
alias commit='git commit'
eval $(thefuck --alias)

# zplug
alias zp='hub browse $(zplug list | fzf)'
