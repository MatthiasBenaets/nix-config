#
#  Home-manager configuration for desktop
#
#  flake.nix
#   └─ ./hosts
#       └─ ./desktop
#           └─ home.nix *
#

{ pkgs, ... }:

{
  home = {                                # Specific packages for desktop
    packages = with pkgs; [
      # Applications
      darktable         # Raw Image Processing
      gimp              # Graphical Editor
      inkscape          # Vector Graphical Editor
      libreoffice       # Office Packages
      lutris            # Game Launcher
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
      #Gimp Inkscape Krita
      #MKVtoolnix
      #Kdenlive
    ];
  };

  services = {                            # Applets
    blueman-applet.enable = true;         # Bluetooth
  };
}
