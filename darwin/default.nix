#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       └─ <host>.nix
#

{ inputs, nixpkgs, nixpkgs-stable, darwin, home-manager, nixvim, vars, ... }:

let
  system = "x86_64-darwin";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  # MacBook8,1 "Core M" 1.2 12" (2015) A1534 ECM2746 profile
  macbook = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs system pkgs stable vars; };
    modules = [
      nixvim.nixDarwinModules.nixvim
      ./macbook.nix
      ../modules/editors/nvim.nix
      ../modules/programs/kitty.nix

      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
