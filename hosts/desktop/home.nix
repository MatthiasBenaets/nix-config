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
      lutris

      # In orimported with default config
      #steam
      #discord                            # See overlay default.nix
      #sonarr
      #radarr                             # See services/media.nix for all 3
      #bazarr
      #handbrake

      # Future
      # Gimp Inkscape Krita
      # MKVtoolnix
      # Kdenlive
    ];
  };

  services = {                            # Applets
    blueman-applet.enable = true;         # Bluetooth
    #robi = {
    # enable = true;
    # rules = [
    #   {
    #     name = "Dual";
    #     outputs_connected = [ "HDMI-A-0" "HDMI-A-1" ];
    #     primary: "HDMI-A-1";
    #     configure_row: [ "HDMI-A-0" "HDMI-A-1" ];
    #   }
    # ];
    #};
  };
}
