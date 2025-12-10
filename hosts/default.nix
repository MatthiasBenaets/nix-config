#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./<host>.nix
#           └─ default.nix
#

{ inputs, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, hyprland, hyprspace, plasma-manager, nixos-wsl, vars, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  # Work Profile
  work = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable hyprland hyprspace vars;
      host = {
        hostName = "work";
        mainMonitor = "eDP-1";
        secondMonitor = "DP-4";
        thirdMonitor = "DP-5";
        secondMonitorDesc = "desc:HP Inc. HP E24i G4 6CM3071B66";
        thirdMonitorDesc = "desc:HP Inc. HP E24i G4 6CM3071996";
      };
    };
    modules = [
      ./work
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  # wsl Profile
  wsl = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable hyprland hyprspace nixos-wsl vars;
      host = {
        hostName = "wsl";
        mainMonitor = ":0";
        secondMonitor = "";
      };
    };
    modules = [
      ./wsl
      ./configuration.nix
      nixos-wsl.nixosModules.default

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        #handle conflicting files in .config
        home-manager.backupFileExtension = "backup";
      }
    ];
  };  
}
