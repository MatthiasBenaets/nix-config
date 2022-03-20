#
#  Bspwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ bspwm.nix *
#

{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    xserver = {
      enable = true;

      layout = "be";                              # Keyboard layout & €-sign
      xkbOptions = "eurosign:e";

      displayManager = {                          # Display Manager
        lightdm = {
          enable = true;                          # Wallpaper and gtk theme
          background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
          greeters = {
            gtk = {
              theme = {
                name = "Dracula";
                package = pkgs.dracula-theme;
              };
              cursorTheme = {
                name = "Dracula-cursors";
                package = pkgs.dracula-theme;
                size = 16;
              };
            };
          };
        };
        defaultSession = "none+bspwm";            # none+bspwm -> no real display manager
      };
      windowManager= {
        bspwm = {                     # Window Manager
          enable = true;
        };  
      };
    }; 
  };

  environment.systemPackages = with pkgs; [       # Packages installed
    xorg.xev
    xorg.xkill
    xorg.xrandr
    #alacritty
    #sxhkd
  ];
}
