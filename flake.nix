#
#  G'Day
#  Behold is my personal NixOS Flake.
#  I'm not the sharpest tool in the shed, so this build might not be the best out there.
#  I refer to the README document on how to use this file.
#  Currently a Work In Progress.
#
#  flake.nix *             
#   └─ ./hosts
#       └─ default.nix
#

{
  description = "Personal NixOS/Home-Manager Configuration";

  inputs =								# All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";		  # Nix Packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

#     nurpkgs = {							  # Nix User Packages
#       url = github:nix-community/NUR;
#       inputs.nixpkgs.follows = "nixpkgs";
#     };

      home-manager = {							  # Home Package Management
        url = github:nix-community/home-manager;
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:		# Function that tells my flake which to use and what do what to do with the dependencies.
    let									  # Variables that can be used in the config files.
      system = "x86_64-linux";						  # System architecture
      
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;					  # Allow proprietary software
      };

      lib = nixpkgs.lib;
    in									# Use above variables in ...
    {
      nixosConfigurations = {                         			  # Location of the available configurations
        import ./hosts {						  # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs system home-manager;				  # Also inherit home-manager so it does not need to be defined here.
        }
      );

#     devShell.${system} = (						  # devShell
#       import ./outputs/installation.nix {
#         inherit system nixpkgs;
#       }
#     );
    };
}
