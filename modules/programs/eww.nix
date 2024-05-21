#
#  Bar
#

{ config, lib, pkgs, vars, ... }:

{
  config = lib.mkIf (config.wlwm.enable) {
    environment.systemPackages = with pkgs; [
      eww # Widgets
      jq # JSON Processor
      socat # Data Transfer
    ];

    home-manager.users.${vars.user} = {
      home.file.".config/eww" = {
        source = ./eww;
        recursive = true;
      };
    };
  };
}
