{
  config,
  inputs,
  ...
}:

let
  host = {
    name = "MacBookIntel";
    user.name = "matthias";
    state = {
      darwin = 4;
      version = "22.05";
    };
    system = "x86_64-darwin";
  };
in
{
  flake.darwinConfigurations.intel = inputs.darwin.lib.darwinSystem {
    system = host.system;
    specialArgs = { inherit inputs; };
    modules = with config.flake.modules.darwin; [
      base
      intel

      nixvim
      homebrewIntel
      kitty
    ];
  };

  flake.modules.darwin.intel = {
    inherit host;
    home-manager.users.${host.user.name} = {
      imports = with config.flake.modules.homeManager; [
      ];
    };
  };
}
