#
# Compositor
#

{ config, lib, pkgs, ... }:

{ 
  config = lib.mkIf (config.xsession.enable) {      # Only evaluate code if using X11
    services.picom = {
      enable = true;
      activeOpacity = "0.93";                       # Node transparency
      inactiveOpacity = "0.93";
      backend = "glx";                              # Rendering ether with glx or xrender. You'll know if you need to switch this.
      fade = true;
      fadeDelta = 10;
      opacityRule = [                               # Opacity rules if transparency is prefered
        "100:name = 'Picture in picture'"
        "85:class_i ?= 'rofi'"
        "80:class_i *= 'discord'"
        "80:class_i *= 'emacs'"
        "80:class_i *= 'Alacritty'"
        "100:fullscreen"
      ];                                            # Find with $ xprop | grep "WM_CLASS"
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
        daemon = true;
        use-damage = false;                         # Fixes flickering and visual bugs with borders
        corner-radius = 5;                          # Corners
        round-borders = 5;
        animations = true;                          # All Animations
        animation-window-mass = 0.5;
        animation-for-open-window = "zoom";
        animation-stiffness = 350;
        detect-rounded-corners = true;              # For some reason fixes random border dots
        detect-client-opacity = false;
        detect-transient = true
        detect-client-leader = false
      '';                                           # Extra options for picom.conf (mostly for pijulius fork)
    };
  };
}
