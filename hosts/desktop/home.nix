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
      plex-media-player
      libreoffice
      #steam
      #discord                             # ~/.config/discord/settings.json : add "SKIP_HOST_UPDATE": true

      # Gimp Inkscape Krita
      # Handbrake MKVtoolnix Sonarr Radarr
      # Kdenlive
    ];
  };

  services = {                            # Applets
    blueman-applet.enable = true;         # Bluetooth
    network-manager-applet.enable = true; # Network
  };
}
