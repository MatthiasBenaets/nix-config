#
# Compositor
#

{ config, lib, pkgs, ... }:

{ 
  config = lib.mkIf (config.xsession.enable) {      # Only evaluate code if using X11
    services.picom = {
      enable = true;
      activeOpacity = "0.95";                       # Node transparency
      inactiveOpacity = "0.95";
      backend = "xrender";                          # Rendering ether with glx or xrender. You'll know if you need to switch this.
      fade = true;
      fadeDelta = 10;
      opacityRule = [                               # Opacity rules if transparency is prefered
        "100:fullscreen"
        #"95:class_i ?= 'pcmanfm'"
        #"95:class_i ?= 'rofi'"
        "80:class_i *= 'discord'"
        "80:class_i *= 'emacs'"
        "80:class_i *= 'Alacritty'"
      ];
      shadow = true;                                # Shadows
      shadowOpacity = "0.75";
      menuOpacity = "0.95";
      vSync = true;                                 # Should fix screen tearing
      package = pkgs.picom.overrideAttrs(o: {
        src = pkgs.fetchFromGitHub {
          repo = "picom";
          owner = "pijulius";
          rev = "982bb43e5d4116f1a37a0bde01c9bda0b88705b9";
          sha256 = "YiuLScDV9UfgI1MiYRtjgRkJ0VuA1TExATA2nJSJMhM=";
        };
      });                                           # Override picom to use pijulius' version
      extraOptions = ''
        corner-radius = 5;
        round-borders = 5;
        animations = true;
        animation-window-mass = 0.5;
        animation-for-open-window = "zoom";
        animation-stiffness = 350;
      '';                                           # Extra options for picom.conf (mostly for pijulius fork)
    };
  };
}
