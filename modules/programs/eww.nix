#
#  Bar
#

{ config, lib, pkgs, unstable, vars, ...}:

{
  config = lib.mkIf (config.wlwm.enable) {
    environment.systemPackages = with unstable; [
      eww-wayland         # Widgets
      jq                  # JSON Processor
      socat               # Data Transfer
    ];

    home-manager.users.${vars.user} = {
      home.file.".config/eww" = {
        source = ./eww;
        recursive = true;
      };
    };
  };
}
