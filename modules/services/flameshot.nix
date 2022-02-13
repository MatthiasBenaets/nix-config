{ pkgs, ... }:

{
  services = {
    flameshot = {
      enable = true;
      settings = {
        General = {
          savePath = "/home/matthias/";
          saveAsFileExtension = ".png";
          uiColor = "#2d0096";
          showHelp = "false";
          disabledTrayIcon = "true";
        };
      };
    };
  };
}
