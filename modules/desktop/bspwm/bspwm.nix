#
#  Bspwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ bspwm.nix *
#

{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    xserver = {
      enable = true;

      layout = "us";                              # Keyboard layout & €-sign
      xkbOptions = "eurosign:e";
      libinput.enable = true;

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
        bspwm = {                                 # Window Manager
          enable = true;
        };  
      };
    }; 
  };

  programs.zsh.enable = true;                     # Weirdly needs to be added to have default user on lightdm

  environment.systemPackages = with pkgs; [       # Packages installed
    xclip
    xorg.xev
    xorg.xkill
    xorg.xrandr
    xterm
    #alacritty
    #sxhkd
  ];
}
