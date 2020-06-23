# /usr/bin/env bash

# chezmoi
curl -sfL https://git.io/chezmoi | sh
chezmoi init --apply --verbose https://github.com/kitagawa-hr/dotfiles.git
