#
#  Mounting tool
#

{ vars, ... }:

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
