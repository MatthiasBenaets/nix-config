# This function creates a nix-darwin system.
name: { darwin, pkgs, lib, home-manager, system, user }:

darwin.lib.darwinSystem {
  inherit system;

  specialArgs = { user = "tom.meadows"; inherit system; };
  modules = [
    ../machines/${name}.nix
    ../machines/shared.nix
    ../darwin/configuration.nix

    home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."tom.meadows" = import ../users/chaosinthecrd/home-manager.nix {
          inherit lib pkgs;
      };
    }

  ];
}
