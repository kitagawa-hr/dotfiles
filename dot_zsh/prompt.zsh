# install starship if not installed
if ! type starship > /dev/null; then
    command curl -fsSL https://starship.rs/install.sh | bash
fi

eval "$(starship init zsh)"
