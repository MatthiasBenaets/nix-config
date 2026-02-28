{
  config,
  inputs,
  ...
}:

let
  host = {
    name = "work";
    user.name = "matthias";
    state.version = "22.05";
    system = "x86_64-linux";
    monitors = [
      {
        name = "eDP-1";
        x = "3840";
        y = "0";
      }
      {
        name = "desc:HP Inc. HP E24i G4 6CM3071B66"; # DP-4
        x = "1920";
        y = "0";
      }
      {
        name = "desc:HP Inc. HP E24i G4 6CM3071996"; # DP-5
        x = "0";
        y = "0";
      }
    ];
  };
in
{
  flake.nixosConfigurations.work = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      work

      light
      audio
      bluetooth
      keyboard
      print
      scan

      nixvim
      hyprland
      flatpak
      virtualisation
    ];
  };

  flake.modules.nixos.work = {
    inherit host;
    home-manager.users.${host.user.name} = {
      imports = with config.flake.modules.homeManager; [
        mime

        kitty
        obs

        noctalia
      ];
    };
  };
}
