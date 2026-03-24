{
  config,
  inputs,
  withSystem,
  ...
}:

let
  host = {
    name = "Ubuntu";
    user.name = "matthias";
    state.version = "26.05";
    system = "x86_64-linux";
  };
in
{
  flake.homeConfigurations.ubuntu = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem host.system ({ pkgs, ... }: pkgs);
    extraSpecialArgs = { inherit host inputs; };
    modules = with config.flake.modules.homeManager; [
      base
      ubuntu
      nixvim
      kitty
      flatpak
      zsh
    ];
  };
}
