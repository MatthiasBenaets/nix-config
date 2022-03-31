#
#  These are the different profiles that can be used when building the flake.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./desktop OR ./laptop
#            ├─ ./default.nix
#            └─ ./home.nix 
#

{ lib, inputs, system, home-manager, user, ... }:

{
  desktop = lib.nixosSystem {                           # Desktop profile
    inherit system;
    specialArgs = { inherit user inputs; };             # Pass flake variable
    modules = [                                         # Modules that are used.
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {          # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };  # Pass flake variable
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./desktop/home.nix)];
        };
      }
    ];
  };

  laptop = lib.nixosSystem {                            # Laptop profile
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./laptop/home.nix)];
        };
      }
    ];
  };

  vm = lib.nixosSystem {                               # VM profile
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; }; 
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./vm/home.nix)];
        };
      }
    ];
  };
}
