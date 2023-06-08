
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
      # Terminal
      btop              # Resource Manager
      ranger            # File Manager
      tldr              # Helper

      # Video/Audio
      feh               # Image Viewer
      plex-media-player # Media Player

      # Apps
      appimage-run      # Runs AppImages on NixOS
      firefox           # Browser

      # File Management
      gnome.file-roller # Archive Manager
      okular            # PDF Viewer
      pcmanfm           # File Manager
      p7zip             # Zip Encryption
      rsync             # Syncer - $ rsync -r dir1/ dir2/
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
