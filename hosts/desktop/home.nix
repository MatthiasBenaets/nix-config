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
      plex-media-player
      libreoffice
      lutris

      # Imported in default config
      #steam
      #discord                            # See overlay default.nix
      #sonarr
      #radarr                             # See services/media.nix for all 3
      #bazarr
      #handbrake

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
