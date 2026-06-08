{
  description = "nix-darwin system flake — multi-host";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      mkDarwinSystem =
        {
          hostModule,
          username,
          homeDirectory,
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit
              inputs
              self
              username
              homeDirectory
              ;
          };
          modules = [
            ./modules/common.nix
            hostModule
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit username homeDirectory; };
              home-manager.users.${username} = import ./modules/home.nix;
            }
          ];
        };
    in
    {
      darwinConfigurations."Rimvydass-MacBook-Pro" = mkDarwinSystem {
        hostModule = ./hosts/work/default.nix;
        username = "rim";
        homeDirectory = "/Users/rim";
      };

      darwinConfigurations."Rims-MacBook-Pro" = mkDarwinSystem {
        hostModule = ./hosts/personal/default.nix;
        username = "rimvydaszilinskas"; # update if different on personal Mac
        homeDirectory = "/Users/rimvydaszilinskas"; # update if different on personal Mac
      };
    };
}
