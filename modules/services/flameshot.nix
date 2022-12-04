#
# Screenshots
#

{ config, lib, pkgs, user, ... }:

{
  config = lib.mkIf (config.xsession.enable) {    # Only evaluate code if using X11
    services = {                                    # sxhkd shortcut = Printscreen button (Print)
      flameshot = {
        enable = true;
        settings = {
          General = {                               # Settings
            savePath = "/home/${user}/";
            saveAsFileExtension = ".png";
            uiColor = "#2d0096";
            showHelp = "false";
            disabledTrayIcon = "true";              # Hide from systray
          };
        };
      };
    };
  };
}
