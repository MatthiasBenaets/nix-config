#
#  Home-manager configuration for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#              └─ home.nix
#

{ pkgs, ... }:

{
  imports =
    [
      ../../modules/desktop/bspwm/home.nix # Window Manager
    ];

  home = {                                # Specific packages for laptop
    packages = with pkgs; [
      # Applications
      libreoffice                         # Office packages

      # Display
      #light                              # xorg.xbacklight not supported. Other option is just use xrandr.

      # Power Management
      #auto-cpufreq                       # Power management
      #tlp                                # Power management
    ];
  };

  programs = {
    alacritty.settings.font.size = 11;
  };

  services = {                            # Applets
    blueman-applet.enable = true;         # Bluetooth
    network-manager-applet.enable = true; # Network
#   cbatticon = {
#     enable = true;
#     criticalLevelPercent = 10;
#     lowLevelPercent = 20;
#     iconType = null;
#   };
  };
}
