{
  config,
  inputs,
  ...
}:

let
  host = {
    name = "vm";
    user.name = "matthias";
    state.version = "25.11";
    system = "x86_64-linux";
    monitors = [
      {
        name = "Virtual-1";
      }
    ];
  };
in
{
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      vm

      nixvim
    ];
  };

  flake.modules.nixos.vm = {
    inherit host;
    home-manager.users.${host.user.name} = {
      imports = with config.flake.modules.homeManager; [
      ];
    };
  };
}
