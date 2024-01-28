#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       └─ <host>.nix
#

{ lib, inputs, nixpkgs, darwin, home-manager, nixvim, vars, ...}:

let
  system = "x86_64-darwin";                                 # System Architecture
in
{
  macbook = darwin.lib.darwinSystem {                       # MacBook8,1 "Core M" 1.2 12" (2015) A1534 ECM2746 profile
    inherit system;
    specialArgs = { inherit inputs vars; };
    modules = [                                             # Modules Used
      nixvim.nixDarwinModules.nixvim
      ./macbook.nix
      ../modules/editors/nvim.nix

      home-manager.darwinModules.home-manager {             # Home-Manager Module
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
