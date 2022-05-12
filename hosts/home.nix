#
#  General Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix *
#   └─ ./modules
#       └─ ./apps & ./services & ./shell & ./editors
#           └─ default.nix
#

{ config, lib, pkgs, user, ... }:

{ 
  imports =                                   # Home Manager Modules
    (import ../modules/editors) ++
    (import ../modules/apps) ++
    (import ../modules/services) ++
    (import ../modules/shell);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      btop              # Resource Manager
      pfetch            # Minimal fetch
      ranger            # File Manager
      
      # Video/Audio
      feh               # Image Viewer
      mpv               # Media Player
      pavucontrol       # Audio control
      plex-media-player # Media Player
      vlc               # Media Player
      stremio           # Media Streamer

      # Dependencies
      libnotify         # Notifications need for Dunst

      # Apps
      google-chrome     # Browser
      remmina           # XRDP & VNC Client

      # File Management
      gnome.file-roller # Archive Manager
      pcmanfm           # File Manager
      rsync             # Syncer $ rsync -r dir1/ dir2/
      unzip             # Zip files
      unrar             # Rar files

      # General configuration
      #git              # Repositories
      #killall          # Stop Applications
      #nano             # Text Editor
      #pciutils         # Computer utility info
      #pulseaudio       # Sound
      #usbutils         # USB utility info
      #wacomtablet      # Wacom Tablet
      #wget             # Downloader
      #xclip            # Console Clipboard
      #xterm            # Terminal
      #zsh              # Shell
      #
      # Imports General home-manager modules
      #alacritty        # Terminal Emulator
      #dunst            # Notifications
      #doom emacs       # Text Editor
      #flameshot        # Screenshot
      #neovim           # Text Editor
      #picom            # Compositer
      #polybar          # Bar
      #rofi             # Menu
      #sxhkd            # Shortcuts
      #udiskie          # Auto Mounting
      #vim              # Text Editor
      #
      # X11
      #xorg.xev         # Input viewer
      #xorg.xkill       # Kill Applications
      #xorg.xrandr      # Screen settings
      #
      # Wayland
      #
      #
      # Desktop
      #bazarr           # Subtitles
      #blueman          # Bluetooth
      #darktable        # Raw Image Processing
      #deluge           # Torrents
      #discord          # Chat
      #ffmpeg           # Video Support (dslr)
      #gmtp             # Mount MTP (GoPro)
      #gphoto2          # Digital Photography
      #handbrake        # Encoder
      #libreoffice      # Office Tools
      #plex             # Plex Server
      #radarr           # Movies
      #sonarr           # TV Shows
      #steam            # Games
      #shotcut          # Video editor
      #shotwell         # Raw Image Manager
      #simple-scan      # Scanning
      # 
      # Laptop
      #blueman          # Bluetooth
      #libreoffice      # Office Tools
      #simple-scan      # Scanning
      #
      # Flatpak
      #obs-studio       # Recording/Live Streaming
    ];
    file.".config/wall".source = config.lib.file.mkOutOfStoreSymlink ../modules/themes/wall;
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    cursorTheme = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrains Mono Medium";  # or FiraCode Nerd Font Mono Medium  
    };
  };
}
