#!/usr/bin/env bash

#####################################
# install vim-plug                  #
#####################################

if ! [ -f "${XDG_DATA_HOME:-$HOME/.local/share/nvim/site/autoload/plug.vim}" ]; then
  echo "installing vim-plug"
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

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

#####################################
# python                            #
#####################################

PYTHON_VERSION=3.7.3
CLI_PACKAGES=("black" "cookiecutter" "flake8" "mypy" "pipenv" "powerline-shell" "yapf")

echo "setup python environment"
if ! [ -x "$(command -v pyenv)" ]; then
  echo "installing pyenv"
  curl https://pyenv.run | bash
fi

if [ "$(uname)" == "Darwin" ]; then
  export CFLAGS="-I$(xcrun --show-sdk-path)/usr/include"
fi

echo "installing python $PYTHON_VERSION interpreter"
pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION
pip install -U pip

# install cli tools using pipx
pip install --user pipx
pipx ensurepath
for package in "${CLI_PACKAGES[@]}"; do
  pipx install "$package"
done
