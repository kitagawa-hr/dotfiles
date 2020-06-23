function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
  }

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

which powerline-shell &> /dev/null
if [ $? -eq 0 ]; then
  if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
  fi
fi
