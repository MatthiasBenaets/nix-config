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
      xbacklight
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

  programs.alacritty.settings.font.size = 8;
}
