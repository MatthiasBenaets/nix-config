#
#  Home-manager configuration for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ ./laptop
#   │   │   └─ home.nix *
#   │   └─ home.nix
#   └─ ./modules
#       ├─ ./menu 
#       │   └─ default.nix
#       ├─ ./services
#       │   └─ default.nix
#       └─ ./shell
#           └─ default.nix
#

{ pkgs, ... }:

{
  imports =								# Importing all the different modules 
    [(import ../home.nix)] ++
    (import ../../modules/apps) ++
    (import ../../modules/services) ++
    (import ../../modules/shell); 

  home = {
    packages = with pkgs; [
      firefox
      #alacritty
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
    };
  };

  programs.alacritty.settings.font.size = 8;
}
