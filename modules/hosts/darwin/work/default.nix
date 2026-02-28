{
  config,
  inputs,
  ...
}:

let
  host = {
    name = "MacBookAirM3";
    user.name = "lucp10771";
    state = {
      darwin = 5;
      version = "22.05";
    };
    system = "aarch64-darwin";
  };
in
{
  flake.darwinConfigurations.work = inputs.darwin.lib.darwinSystem {
    system = host.system;
    specialArgs = { inherit inputs; };
    modules = with config.flake.modules.darwin; [
      base
      work

      nixvim
      hyprspace
      homebrewWork
      kitty
    ];
  };

  flake.modules.darwin.work = {
    inherit host;
    home-manager.users.${host.user.name} = {
      imports = with config.flake.modules.homeManager; [
        zsh
      ];
    };
  };
}
