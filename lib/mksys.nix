name: { pkgs, nixpkgs, lib, home-manager, system, user, hyprland, xremap-flake }:
nixpkgs.lib.nixosSystem {
  inherit system pkgs;

  modules = [

    ../hardware/${name}.nix
    ../machines/${name}.nix
    ../machines/shared.nix
    hyprland.nixosModules.default
    xremap-flake.nixosModules.default
    ../users/${user}/nixos.nix

    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/chaosinthecrd/home-manager.nix {
          inherit lib pkgs user;
        };
    }

  ];

}
