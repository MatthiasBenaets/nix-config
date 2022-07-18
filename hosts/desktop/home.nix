#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │       └─ ./home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ home.nix
#

{ pkgs, ... }:

{
  imports =
    [
      ../../modules/desktop/bspwm/home.nix  # Window Manager
      ../../modules/desktop/sway/home.nix
      #../../modules/desktop/hyprland/home.nix
    ];

  home = {                                # Specific packages for desktop
    packages = with pkgs; [
      # Applications
      darktable         # Raw Image Processing
      gimp              # Graphical Editor
      inkscape          # Vector Graphical Editor
      kdenlive          # Video Editor
      libreoffice       # Office Packages
      plex-media-player # Media Player
      shotcut           # Video Editor

      # Dependencies
      gmtp              # Used for mounting gopro
      
      # Imported in default config
      #bazarr           # Subtitles
      #discord          # Comms           # See overlay default.nix
      #ffmpeg           # Video Support
      #gphoto2          # Digital Photography
      #handbrake        # Encoder
      #radarr           # Media Movies    # See services/media.nix for radarr, sonarr and bazarr
      #shotwell         # Raw Photo Manager
      #sonarr           # Media TV Shows
      #steam            # Game Launcher

      # Future
      #MKVtoolnix
    ];
  };

  services = {                            # Applets
    blueman-applet.enable = true;         # Bluetooth
  };
}
