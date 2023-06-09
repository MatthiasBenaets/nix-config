{
  description = "Tom's Personal NixOS and Darwin System Flake Configuration";

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

    };

  outputs = inputs @ { self, nixpkgs, home-manager, darwin, ... }:   # Function that tells my flake which to use and what do what to do with the dependencies.
    let                                                                     # Variables that can be used in the config files.
      mkDarwin = import ./lib/mkdarwin.nix;
      mkVM = import ./lib/mkvm.nix;
      mkBM = import ./lib/mkbm.nix;
      user = "chaosinthecrd";
    in                                                                      # Use above variables in ...
    {
      nixosConfigurations.vm-aarch64 = mkVM "vm-aarch64" {
        inherit nixpkgs home-manager user;
        system = "aarch64-linux"
      };

      # assuming for now that all bare-metal is going to be x86
      nixosConfigurations.bm-x86 = mkBM "bm-x86-linux" {
        inherit nixpkgs home-manager user;
        system = "x86_64-linux"
      }

      darwinConfigurations.macbook-m1 = mkDarwin "macbook-m1" {
        inherit darwin nixpkgs home-manager overlays;
        system = "aarch64-darwin";
        # overriding standard user name to adhere to Venafi IT policy
        user = "tom.meadows";
      }

    };
}
