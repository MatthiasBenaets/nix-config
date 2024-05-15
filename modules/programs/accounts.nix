#
# Gnome Control Manager
# Mainly used for online accounts
#

{ lib, pkgs, vars, host, ... }:

{
  config = lib.mkIf (host.hostName == "beelink" || host.hostName == "work" || host.hostName == "xps") {
    environment.systemPackages = with pkgs; [
      gnome.gnome-control-center
      gnome-online-accounts
    ];

    services.gnome.gnome-keyring.enable = true;

    security.pam.services.gnomekey.enableGnomeKeyring = true;

    home-manager.users.${vars.user} = {
      xdg.desktopEntries.gnome-control-center = {
        name = "Gnome Control Center";
        exec = "env XDG_CURRENT_DESKTOP=GNOME ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
      };
    };
  };
}
