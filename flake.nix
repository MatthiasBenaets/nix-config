{
  description = "Tom's Personal NixOS and Darwin System Flake Configuration";

  inputs =                                                                  # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";                  # Nix Packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";                  # Nix Packages
      nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
      home-manager = {                                                      # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      darwin = {
        url = "github:lnl7/nix-darwin/master";                              # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprland = {
        url = "github:hyprwm/Hyprland";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };

      xremap-flake.url = "github:xremap/nix-flake";

      nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = inputs @ { self, xremap-flake, hyprland, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }:   # Function that tells my flake which to use and what do what to do with the dependencies.
    let                                                                     # Variables that can be used in the config files.
      mkDarwin = import ./lib/mkdarwin.nix;
      mkSys = import ./lib/mksys.nix;
      user = "chaosinthecrd";
      system = "x86_64-linux";
      pkgs  = import nixpkgs {
      inherit system; 
      config = { allowUnfree = true; allowInsecure = true; };
      overlays = [
        (final: prev: {
          nordpass = final.callPackage ./pkgs/nordpass { };
          waybar = inputs.nixpkgs-unstable.legacyPackages.${system}.waybar;
          swww = inputs.nixpkgs-unstable.legacyPackages.${system}.swww;
          _1password-gui = inputs.nixpkgs-unstable.legacyPackages.${system}._1password-gui;
          dunst = inputs.nixpkgs-unstable.legacyPackages.${system}.dunst;
          slack = inputs.nixpkgs-unstable.legacyPackages.${system}.slack;
          nwg-look = inputs.nixpkgs-unstable.legacyPackages.${system}.nwg-look;
          cartridges = inputs.nixpkgs-unstable.legacyPackages.${system}.cartridges;
        })
      ];
      };
    in                                                                      # Use above variables in ...
    {

      nixosConfigurations.desktop = mkSys "desktop" rec {
         inherit home-manager user nixpkgs xremap-flake hyprland system pkgs;
         lib = pkgs.lib;
      };

      darwinConfigurations.macbook-m1 = mkDarwin "macbook-m1" rec {
        inherit darwin home-manager;
        system = "aarch64-darwin";
        # overriding standard user name to adhere to Venafi IT policy
        user = "tom.meadows";
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
      };

    };
}
