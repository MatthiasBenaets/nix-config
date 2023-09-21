#
#  Mounting tool
#

{ config, lib, pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    services = {
      udiskie = {
        enable = true;
        automount = true;
        tray = "auto";
      };
    };
  };
}
