{
  config,
  inputs,
  ...
}:

let
  host = {
    name = "beelink";
    user.name = "matthias";
    state.version = "22.05";
    system = "x86_64-linux";
    monitors = [
      {
        name = "HDMI-A-2";
        w = "1920";
        h = "1080";
        refresh = "60";
        x = "1920";
        y = "0";
      }
      {
        name = "HDMI-A-1";
        w = "1920";
        h = "1080";
        refresh = "60";
        x = "0";
        y = "0";
      }
    ];
  };
in
{
  flake.nixosConfigurations.beelink = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      beelink

      audio
      bluetooth
      keyboard
      print
      scan

      nixvim
      hyprland
      flatpak
      virtualisation
      games
    ];
  };

  flake.modules.nixos.beelink = {
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
