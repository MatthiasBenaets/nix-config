{ inputs, overlays, vars, ... }:

let
  lib = inputs.nixpkgs.lib;

  mkHost = { name, system, extraModules ? [ ], hostVars, description ? "Default config" }:
    lib.nixosSystem {
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
            system.stateVersion = "22.05";
          }
          ./configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          inputs.nixvim.nixosModules.nixvim
        ]
        ++ extraModules;
    };
in
{
  description = "Below the different profiles that can be used when building NixOS";

  beelink = mkHost {
    description = "Config for Beelink EQ12 Pro";
    name = "beelink";
    system = "x86_64-linux";
    extraModules = [
      inputs.nur.modules.nixos.default
      ./beelink
    ];
    hostVars = {
      mainMonitor = "HDMI-A-2";
      secondMonitor = "HDMI-A-1";
    };
  };

  work = mkHost {
    description = "Config for Work Lenovo T15";
    name = "work";
    system = "x86_64-linux";
    extraModules = [ ./work ];
    hostVars = {
      mainMonitor = "eDP-1";
      secondMonitor = "DP-4";
      thirdMonitor = "DP-5";
      secondMonitorDesc = "desc:HP Inc. HP E24i G4 6CM3071B66";
      thirdMonitorDesc = "desc:HP Inc. HP E24i G4 6CM3071996";
    };
  };

  vm = mkHost {
    description = "Config for Virtual Machines";
    name = "vm";
    system = "x86_64-linux";
    extraModules = [ ./vm ];
    hostVars = {
      mainMonitor = "Virtual-1";
      secondMonitor = "";
      thirdMonitor = "";
    };
  };
}
