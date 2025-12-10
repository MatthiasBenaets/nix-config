#
#  GTK
#

{ lib, config, pkgs, host, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {};
  };
}
