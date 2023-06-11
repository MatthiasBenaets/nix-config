name: { nixpkgs, pkgs, lib, home-manager, system, user, hyprland }:

nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [

    ../hardware/${name}.nix
    ../machines/${name}.nix
    hyprland.nixosModules.default
    {programs.hyprland.enable = true; programs.hyprland.xwayland.hidpi = true;}
    ../users/${user}/nixos.nix

    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/chaosinthecrd/home-manager.nix {
          inherit lib pkgs;
        };
    }

  ];
}
