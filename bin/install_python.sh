# /usr/bin/env bash

PYTHON_VERSION=3.7.3
CLI_PACKAGES=("black" "cookiecutter" "flake8" "mypy" "pipenv" "powerline-shell" "yapf")

# install pyenv
curl https://pyenv.run | bash

if [ "$(uname)" == "Darwin" ]; then
    export CFLAGS="-I$(xcrun --show-sdk-path)/usr/include"
fi

pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION
exec $SHELL
pip install -U pip
pip install -r requirements.txt

# install cli tools using pipx
pip install --user pipx
pipx ensurepath
for package in $CLI_PACKAGES; do
  pipx install $package
;done
