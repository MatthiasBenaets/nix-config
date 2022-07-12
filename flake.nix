#
#  G'Day
#  Behold is my personal Nix, NixOS and Darwin Flake.
#  I'm not the sharpest tool in the shed, so this build might not be the best out there.
#  I refer to the README and other org document on how to use these files.
#  Currently and possibly forever a Work In Progress.
#
#  flake.nix *             
#   ├─ ./hosts
#   │   └─ default.nix
#   ├─ ./darwin
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#

{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs =                                                                  # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                  # Nix Packages

      home-manager = {                                                      # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      darwin = {
        url = "github:lnl7/nix-darwin/master";                              # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nur = {
        url = "github:nix-community/NUR";                                   # NUR packages
      };

      nixgl = {                                                             #OpenGL 
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprland = {
        url = "github:vaxerski/Hyprland";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, darwin, nur, nixgl, hyprland, ... }:   # Function that tells my flake which to use and what do what to do with the dependencies.
    let                                                                     # Variables that can be used in the config files.
      user = "matthias";
      location = "$HOME/.setup";
      protocol = "X";         # Desktop choice "X" and "Wayland" | Laptop ONLY choice "Wayland"
    in                                                                      # Use above variables in ...
    {
      nixosConfigurations = (                                               # NixOS configurations
        import ./hosts {                                                    # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager nur user location hyprland protocol;   # Also inherit home-manager so it does not need to be defined here.
        }
      );

      darwinConfigurations = (                                              # Darwin Configurations
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager darwin user;
        }
      );

      homeConfigurations = (                                                # Non-NixOS configurations
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager nixgl user;
        }
      );
    };
}
