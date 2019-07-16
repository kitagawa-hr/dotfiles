# --------------------------------------
# load ~/.bashrc
# --------------------------------------
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# --------------------------------------
# terminal color
# --------------------------------------
if type gls > /dev/null 2>&1; then
    alias ls='/usr/local/bin/gls --color=auto -h'
fi

# --------------------------------------
# pyenv
# --------------------------------------
if type pyenv > /dev/null 2>&1; then
    export PYENV_ROOT=~/.pyenv
    export PATH=$PATH:$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init -)"

    # If you have homebrew openssl and pyenv installed,
    # you may need to tell the compiler where the openssl package is located:
    export CFLAGS="-I$(brew --prefix openssl)/include"
    export LDFLAGS="-L$(brew --prefix openssl)/lib"
fi

export PATH="$HOME/.cargo/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/kitagawaharuki/.sdkman"
[[ -s "/Users/kitagawaharuki/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/kitagawaharuki/.sdkman/bin/sdkman-init.sh"

export PATH="$HOME/.poetry/bin:$PATH"
if [ -e /Users/kitagawaharuki/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/kitagawaharuki/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
