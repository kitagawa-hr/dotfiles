{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    font-awesome
    nerd-fonts._0xproto
    nerd-fonts.monaspace
    nerd-fonts.fira-code
  ];
}
