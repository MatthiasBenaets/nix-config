
{ config, lib, pkgs, user, ... }:

{ 
  imports =                               # Home Manager Modules
  [
    ../modules/programs/alacritty.nix
  ];


  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      ranger            # File Manager
      feh               # Image Viewer
      plex-media-player # Media Player
      firefox           # Browser
      # File Management
      unzip             # Zip Files
      unrar             # Rar Files
      zip               # Zip
    ];
    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
  };

  systemd.user.targets.tray = {               # Tray.target can not be found when xsession is not enabled. This fixes the issue.
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
