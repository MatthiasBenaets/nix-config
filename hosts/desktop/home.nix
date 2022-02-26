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
      google-chrome
      plex-media-player

      # Gimp Inkscape Krita
      # Steam Discord
      # Handbrake MKVtoolnix Sonarr Radarr
      # Kdenlive
      # LibreOffice
    ];
  };

  services = {                            # Applets
    blueman-applet.enable = true;         # Bluetooth
    network-manager-applet.enable = true; # Network
  };
}
