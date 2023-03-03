#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix *
#       ├─ configuration.nix
#       └─ home.nix
#

{ lib, inputs, nixpkgs, home-manager, darwin, user, ...}:

let
  system = "aarch64-darwin";                                 # System architecture
in
{
  workMacbook = darwin.lib.darwinSystem {                       # MacBook Pro (14-inch, 2021), M1 Pro
    inherit system;
    specialArgs = { inherit inputs; user = "tom.meadows"; };
    modules = [                                             # Modules that are used
      ./configuration.nix

      home-manager.darwinModules.home-manager {             # Home-Manager module that is used
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."tom.meadows" = import ./home.nix;
      }
    ];
  };

  personalMacbook = darwin.lib.darwinSystem {                       # MacBook Pro (14-inch, 2021), M1 Pro
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [                                             # Modules that are used
      ./configuration.nix

      home-manager.darwinModules.home-manager {             # Home-Manager module that is used
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import ./home.nix;
      }
    ];
  };
}
