{ pkgs, ... }:

{
  services = {
    udiskie = {
      enable = true;
      tray = "auto";
    };
  };
}
