{
  description = "Tom's Personal NixOS and Darwin System Flake Configuration";

  inputs =                                                                  # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";                  # Nix Packages


      hyprland = {                                                          # Official Hyprland flake
        url = "github:vaxerski/Hyprland"; 
        inputs.nixpkgs.follows = "nixpkgs";
      };

      home-manager = {                                                      # User Package Management
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      darwin = {
        url = "github:lnl7/nix-darwin/master";                              # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };

  outputs = inputs @ { self, nixpkgs, home-manager, darwin, hyprland, ... }:   # Function that tells my flake which to use and what do what to do with the dependencies.
    let                                                                     # Variables that can be used in the config files.
      mkDarwin = import ./lib/mkdarwin.nix;
      mkVM = import ./lib/mkvm.nix;
      mkBM = import ./lib/mkbm.nix;
      user = "chaosinthecrd";
    in                                                                      # Use above variables in ...
    {
      nixosConfigurations.vm-aarch64-prl = mkVM "vm-aarch64-prl" rec {
        inherit nixpkgs home-manager user hyprland;
        system = "aarch64-linux";
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
      };

      # # assuming for now that all bare-metal is going to be x86
      # nixosConfigurations.bm-x86 = mkBM "bm-x86-linux" {
      #   inherit nixpkgs home-manager user;
      #   system = "x86_64-linux";
      #   lib = nixpkgs.lib;
      # };

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
