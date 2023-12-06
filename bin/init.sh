#!/usr/bin/env bash

#####################################
# homebrew                          #
#####################################

if ! [ -x "$(command -v brew)" ]; then
  echo "installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew shellenv >> ~/.zshrc.local
fi

echo "installing from Brewfile"
brew bundle --file ./Brewfile
