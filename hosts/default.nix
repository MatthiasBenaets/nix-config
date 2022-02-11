#
#  There are the different profiles that can be used when building the flake.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./desktop OR ./laptop
#            ├─ ./default.nix
#            └─ ./home.nix 
#

{ lib, inputs, system, home-manager, ... }:

{
  desktop = lib.nixosSystem {						# Desktop profile
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [								# Modules that are used.
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {				# Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.matthias = import ./desktop/home.nix;
      }
    ];
  };

  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.matthias = import ./laptop/home.nix;
      }
    ];
  };
}