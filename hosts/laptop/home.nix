#
#  Home-manager configuration for laptop
#
#  flake.nix
#   └─ ./hosts
#       └─ ./laptop
#           └─ home.nix *
#

{ pkgs, ... }:

{
  home = {								# Specific packages for laptop
    packages = with pkgs; [
      firefox
      #light								# xorg.xbacklight not supported. Other option is just use xrandr.
      #auto-cpufreq
      #tlp
    ];
  };
  
  services = {								# Applets
    blueman-applet.enable = true;                                         # Bluetooth
    network-manager-applet.enable = true;                                 # Network
    cbatticon = {
      enable = true;
      criticalLevelPercent = 10;
      lowLevelPercent = 20;
      iconType = null;
    };
  };

  programs = {
    alacritty.settings.font.size = 8;
  };
}
