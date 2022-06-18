#
#  Home-manager configuration for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix *
#   └─ ./modules
#       ├─ ./desktop
#       │   └─ ./sway
#       │      └─ home.nix
#       └─ ./programs
#           └─ ./waybar.nix
#

{ pkgs, ... }:

{
  imports =
    [
      #../../modules/desktop/sway/home.nix # Window Manager
      ../../modules/desktop/hyprland/home.nix # Window Manager
      ../../modules/programs/waybar.nix   # Waybar
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
#    network-manager-applet.enable = true; # Network
#   cbatticon = {
#     enable = true;
#     criticalLevelPercent = 10;
#     lowLevelPercent = 20;
#     iconType = null;
#   };
  };
}
