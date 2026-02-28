{
  config,
  inputs,
  withSystem,
  ...
}:

let
  host = {
    user.name = "pacman";
    state.version = "22.05";
    system = "x86_64-linux";
  };
in
{
  flake.homeConfigurations.pacman = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem host.system ({ pkgs, ... }: pkgs);
    extraSpecialArgs = { inherit host inputs; };
    modules = with config.flake.modules.homeManager; [
      base
      pacman
    ];
  };
}
