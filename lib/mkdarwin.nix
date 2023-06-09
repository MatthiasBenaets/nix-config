# This function creates a nix-darwin system.
name: { darwin, nixpkgs, home-manager, system, user, overlays }:

darwin.lib.darwinSystem rec {
  inherit system;

  modules = [
    ../machines/${name}.nix
    ./machines/shared.nix
    ../darwin/configuration.nix

    home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      # I've hard coded the user here as unless the user gets overriden, it's what I am. 
      # If I want more than one user in the future then i'll have to rethink.
      home-manager.users.${user} = import ../users/chaosinthecrd/home-manager.nix;
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
