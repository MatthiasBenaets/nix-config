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

      layout = "be";							# Keyboard layout & €-sign
      xkbOptions = "eurosign:e";

      libinput = {							# Trackpad support
        enable = true;
        touchpad.disableWhileTyping = true;
      };

      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime"     "0"
      '';

      displayManager = {						# Display Manager
        lightdm = {
          enable = true;
        };
        defaultSession = "none+bspwm";					  # none+bspwm -> no real display manager
      };
      windowManager.bspwm = {						# Window Manager
        enable = true;
      };
    }; 
  };

  environment.systemPackages = with pkgs; [				# Packages installed
    xorg.xev
    xorg.xkill
    xorg.xrandr
    
    #alacritty
    sxhkd
  ];
}
