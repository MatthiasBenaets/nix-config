#
#  G'Day
#  Behold is my personal NixOS and Darwin Flake.
#  I'm not the sharpest tool in the shed, so this build might not be the best out there.
#  I refer to the README document on how to use these files.
#  Currently and possibly forever a Work In Progress.
#
#  flake.nix *             
#   ├─ ./hosts
#   │   └─ default.nix
#   └─ ./darwin
#       └─ default.nix

{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs =                                                            # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";            # Nix Packages
#     nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
#
#     nurpkgs = {                                                     # Nix User Packages
#       url = github:nix-community/NUR;
#       inputs.nixpkgs.follows = "nixpkgs";
#     };

      home-manager = {                                                # Home Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      darwin = {
        url = "github:lnl7/nix-darwin/master";                        # MacOS Packages
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, darwin, ... }:    # Function that tells my flake which to use and what do what to do with the dependencies.
    let                                                               # Variables that can be used in the config files.
      user = "matthias";
      location = "$HOME/.setup";
    in                                                                # Use above variables in ...
    {
      nixosConfigurations = (                                         # Location of the available nixos configurations
        import ./hosts {                                              # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user location;          # Also inherit home-manager so it does not need to be defined here.
        }
      );

      darwinConfigurations = (                                        # Location of the available darwin configurations
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager darwin user;
        }
      );
    };
}
