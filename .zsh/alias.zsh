# ------------------------------------
# Applications
# ------------------------------------
alias jb='jupyter notebook'
alias jl='jupyter lab'
alias v='nvim'
alias zp='hub browse $(zplug list | fzf)'

# ------------------------------------
# Shell Commands
# ------------------------------------
alias la='ls -a'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rm='rm -i'
alias mv='mv -i'

# ------------------------------------
# Git Commands
# ------------------------------------
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
alias pull='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias add='git add'
alias commit='git commit'

# ------------------------------------
# Docker commands
# ------------------------------------

# Get latest container ID
alias dl="docker ps -l -q"

# Get container process
alias dps="docker ps"

# Get process included stop container
alias dpa="docker ps -a"

# Get images
alias di="docker images"

# Get container IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"

# Execute interactive container, e.g., $dex base /bin/bash
alias dex="docker exec -i -t"

# Stop all containers
dstop() { docker stop $(docker ps -a -q); }

# Remove all containers
drm() { docker rm $(docker ps -a -q); }

# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# Remove all images
dri() { docker rmi $(docker images -q); }


