#
#  General Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ ./desktop
#   │   │   └─ ./bspwm
#   │   │       └─ home.nix
#   │   └─ home.nix *
#   └─ ./modules
#       └─./apps & ./services & ./shell
#          └─ default.nix
#

{ config, lib, pkgs, ... }:

{ 
  imports =                                   # Home Manager Modules
    [(import ../modules/desktop/bspwm/home.nix)] ++
    (import ../modules/editors) ++
    (import ../modules/apps) ++
    (import ../modules/services) ++
    (import ../modules/shell);

  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";

    packages = with pkgs; [
      # Terminal
      btop              # Resource Manager
      pfetch            # Minimal fetch
      ranger            # File Manager
      
      # Video/Audio
      feh               # Image Viewer
      mpv               # Media Player
      obs-studio        # Broadcasting
      pavucontrol       # Audio control
      plex-media-player # Media Player
      vlc               # Media Player
      
      # Dependencies
      libnotify         # Notifications need for Dunst
      ##snixembed       # System tray fix, run snixembed --fork in .xinitrc

      # Apps
      google-chrome     # Browser
      pcmanfm           # File Manager
      qbittorrent       # Torrents
      remmina           # XRDP Client

      # File Management
      unzip             # Zip files
      unrar             # Rar files

      # General configuration
      #git              # Repositories
      #killall          # Stop Applications
      #neovim           # Text Editor
      #pciutils         # Computer utility info
      #pulseaudio       # Sound
      #wget             # Downloader
      #zsh              # Shell
      #ffmpeg           # Multimedia framework
      #gphoto2          # Digital camera software
      #
      # Imports General home-manager
      #alacritty        # Terminal Emulator
      #dunst            # Notifications
      #doom emacs       # Text Editor
      #flameshot        # Screenshot
      #nano             # Text Editor
      #picom            # Compositer
      #polybar          # Bar
      #rofi             # Menu
      #sxhkd            # Shortcuts
      #udiskie          # Auto Mounting
      #vim              # Text Editor
      #
      # WM/DM
      #xorg.xev         # Input viewer
      #xorg.xkill       # Kill Applications
      #xorg.xrandr      # Screen settings
      #
      # Desktop
      #blueman          # Bluetooth
      #discord          # Chat
      #libreoffice      # Office Tools
      #plex             # Plex Server
      #steam            # Games
      #radarr           # Movies
      #sonarr           # TV Shows
      #bazarr           # Subtitles
      #handbrake        # Encoder
      #
      # Laptop
      #blueman          # Bluetooth
      #libreoffice      # Office Tools
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    home-manager.enable = true;
    zsh.enable = true;
  };

  xsession = {                                # Session settings
    enable = true;
    numlock.enable = true;

    pointerCursor = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "FiraCode Nerd Font Mono Medium";  
    };
  };

  home.file.".config/wall".source = config.lib.file.mkOutOfStoreSymlink ../modules/themes/wall;

  home.stateVersion = "22.05";
}
