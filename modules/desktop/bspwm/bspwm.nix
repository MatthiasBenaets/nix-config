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

      layout = "us";                              # Keyboard layout & €-sign
      xkbOptions = "eurosign:e";

      displayManager = {                          # Display Manager
        lightdm = {
          enable = true;                          # Wallpaper and gtk theme
          background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
          greeters = {
            gtk = {
              theme = {
                #name = "Dracula";
                #package = pkgs.dracula-theme;
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

  sound = {                                       # ALSA sound enable
    enable = true;
    mediaKeys = {                                 # Keyboard Media Keys (for minimal desktop)
      enable = true;
    };
  };

  hardware = {                                    # Hardware Audio
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';                                         # Automatically switch to bluetooth device upon connection
    };                                            # For optimal mic quality: Input at 35% (-25db)
  };

  environment.systemPackages = with pkgs; [       # Packages installed
    xorg.xev
    xorg.xkill
    xorg.xrandr
    #alacritty
    #sxhkd
  ];
}
