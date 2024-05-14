{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # Essentials
      bat
      chezmoi
      cmake
      curl
      fd
      fzf
      gcc
      git
      gnumake
      gnused
      jq
      neovim
      nushell
      openssl
      pkg-config
      ripgrep
      tmux
      tree-sitter
      unzip
      wget
      zsh

      # Dev tools
      csvlens
      delta
      devenv
      direnv
      eza
      hexyl
      hyperfine
      mcfly
      pinentry-tty
      procs
      starship
      uutils-coreutils
      xclip
      yazi
      zoxide

      # AWS
      awscli2
      ssm-session-manager-plugin

      # Git
      actionlint
      gh
      gh-dash
      ghq
      gitui
      lazygit
      tig

      # Nix
      nixfmt-rfc-style
      statix

      # JavaScript, TypeScript
      biome
      nodejs_22
      deno

      # Rust
      cargo-binstall
      rustup

      # Go
      go

      # Docker
      hadolint

      # Lua
      stylua
      lua-language-server

      # Shell
      shellcheck
      shfmt

      # Python
      pyright
      ruff
      rye

      # YAML
      yamlfmt
      yq

      # SQL
      nodePackages.sql-formatter

      # Markdown
      markdownlint-cli
    ];
    sessionVariables = {
      OPENSSL_DIR = "${pkgs.openssl.bin}/bin";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      OPENSSL_INCLUDE_DIR = "${pkgs.openssl.out.dev}/include";
    };

    sessionPath = [
      "$HOME/.rye/shims"
      "$HOME/.cargo/bin"
      "$GOPATH/bin"
    ];
  };
}
