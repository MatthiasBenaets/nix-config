{
  config,
  inputs,
  ...
}:

let
  host = {
    name = "MacBookAirM1";
    user.name = "matthias";
    state = {
      darwin = 4;
      version = "22.05";
    };
    system = "aarch64-darwin";
  };
in
{
  flake.darwinConfigurations.m1 = inputs.darwin.lib.darwinSystem {
    system = host.system;
    specialArgs = { inherit inputs; };
    modules = with config.flake.modules.darwin; [
      base
      m1

      homebrewM1
      aerospace
      kitty
      nixvim
    ];
  };

  flake.modules.darwin.m1 = {
    inherit host;
    home-manager.users.${host.user.name} = {
      imports = with config.flake.modules.homeManager; [
        claude
        zsh
      ];
    };
  };
}
