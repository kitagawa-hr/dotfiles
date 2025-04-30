{
  description = "Home Manager configuration of haruki-kitagawa";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      username = "haruki-kitagawa";
    in
    {
      homeConfigurations = {
        "${username}@mbp-work" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [
            ./modules/pkgs.nix
            ./modules/fonts.nix
            {
              programs.home-manager.enable = true;
              home = {
                inherit username;
                homeDirectory = "/Users/${username}";
                stateVersion = "23.11";
              };
            }
          ];
        };

        "kitagawa@mbp-private" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-darwin";
          modules = [
            ./modules/pkgs.nix
            ./modules/fonts.nix
            {
              programs.home-manager.enable = true;
              home = {
                username = "kitagawa";
                homeDirectory = "/Users/kitagawa";
                stateVersion = "23.11";
              };
            }
          ];
        };

        "${username}@mbp-orb" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-linux";
          modules = [
            ./modules/pkgs.nix
            {
              programs.home-manager.enable = true;
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
                stateVersion = "23.11";
              };
            }
          ];
        };
      };
    };
}
