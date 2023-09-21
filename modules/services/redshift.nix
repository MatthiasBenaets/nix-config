#
#  Screen Temperature
#

{ config, lib, pkgs, vars, ...}:

{
  config = lib.mkIf (config.services.xserver.enable) {
    home-manager.users.${vars.user} = {
      services = {
        redshift = {
          enable = true;
          temperature.night = 3000;
          latitude = 50.929818;
          longitude = 5.338297;
        };
      };
    };
  };
}
