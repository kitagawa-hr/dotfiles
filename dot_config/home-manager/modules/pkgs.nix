{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # CLI tools
      bat
      chezmoi
      cmake
      csvlens
      curl
      delta
      direnv
      eza
      fd
      gcc
      git
      gnumake
      gnused
      hexyl
      hyperfine
      jq
      openssl
      pinentry-tty
      pkg-config
      procs
      qrcp
      ripgrep
      tmux
      unzip
      uutils-coreutils
      wget
      xclip
      yazi

      # Neovim
      jdt-language-server
      lua-language-server
      typos-lsp
      efm-langserver
      neovim
      tree-sitter

      # shell
      fish
      fzf
      mcfly
      starship
      zsh
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

      # DAP
      vscode-extensions.vadimcn.vscode-lldb

      # Nix
      nil
      nixfmt-rfc-style
      statix

      # JavaScript, TypeScript
      biome
      nodejs_22
      deno
      typescript-language-server

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
      basedpyright
      ruff
      uv

      # YAML
      yamlfmt
      yq

      # SQL
      nodePackages.sql-formatter

      # Markdown
      markdownlint-cli

      # zig
      zig
      zls
    ];
    sessionVariables = {
      GOPATH = "$HOME/go";
      OPENSSL_DIR = "${pkgs.openssl.bin}/bin";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      OPENSSL_INCLUDE_DIR = "${pkgs.openssl.out.dev}/include";
    };

    sessionPath = [
      "$HOME/.cargo/bin"
      "$GOPATH/bin"
    ];
  };
}
