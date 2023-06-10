name: { nixpkgs, pkgs, lib, home-manager, system, user, hyprland }:

nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [

    ../hardware/${name}.nix
    ../machines/${name}.nix
    hyprland.nixosModules.default
    ../users/${user}/nixos.nix

    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/chaosinthecrd/home-manager.nix {
          inherit lib pkgs;
        };
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
      };
    }
  ];
}
