{ inputs, overlays, vars, ... }:

let
  mkHost = { name, system, extraModules ? [ ], hostVars ? { }, description ? "Default Config" }:
    inputs.darwin.lib.darwinSystem {
      inherit system;

      specialArgs = {
        inherit inputs system;
        vars = vars // { hostName = name; } // hostVars;
      };

      modules =
        [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config.allowUnfree = true;
          }
          # ./darwin-configuration.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              inputs.mac-app-util.homeManagerModules.default
            ];
          }
          inputs.mac-app-util.darwinModules.default
          inputs.nixvim.nixDarwinModules.nixvim
        ]
        ++ extraModules;
    };
in
{
  MacBookIntel = mkHost {
    description = "MacBook8,1 'Core M' 1.2 12 inch (2015) A1534";
    name = "MacBookIntel";
    system = "x86_64-darwin";
    extraModules = [
      ./intel.nix
      ./modules/kitty.nix
      ./modules/zsh.nix
    ];
  };

  MacBookAirM1 = mkHost {
    description = "MacBookAir10,1 M1 13 inch (2020)";
    name = "MacBookAirM1";
    system = "aarch64-darwin";
    extraModules = [
      ./darwin-configuration.nix
      ./m1.nix
    ];
  };

  MacBookAirM3 = mkHost {
    description = "Work MacBookAir15,12 M3 13 inch (2024)";
    name = "MacBookAirM3";
    system = "aarch64-darwin";
    extraModules = [
      ./work.nix
    ];
    hostVars = {
      user = "lucp10771";
    };
  };
}
