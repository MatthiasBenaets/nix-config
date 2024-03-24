#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       └─ <host>.nix
#

{ inputs, nixpkgs-unstable, darwin, home-manager-unstable, nixvim-unstable, vars, ... }:

let
  system = "x86_64-darwin";
  pkgs = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  # MacBook8,1 "Core M" 1.2 12" (2015) A1534 ECM2746 profile
  macbook = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs vars; };
    modules = [
      nixvim-unstable.nixDarwinModules.nixvim
      ./macbook.nix
      ../modules/editors/nvim.nix
      ../modules/programs/kitty.nix

      home-manager-unstable.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
