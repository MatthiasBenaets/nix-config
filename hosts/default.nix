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

{ inputs, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, nur, nixvim, doom-emacs, hyprland, hyprspace, plasma-manager, vars, ... }:

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
  # Desktop Profile
  beelink = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable hyprland hyprspace vars;
      host = {
        hostName = "beelink";
        mainMonitor = "HDMI-A-2";
        secondMonitor = "HDMI-A-1";
      };
    };
    modules = [
      nur.modules.nixos.default
      nixvim.nixosModules.nixvim
      ./beelink
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

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
      nixvim.nixosModules.nixvim
      ./work
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  # VM Profile
  vm = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable vars;
      host = {
        hostName = "vm";
        mainMonitor = "Virtual-1";
        secondMonitor = "";
        thirdMonitor = "";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
