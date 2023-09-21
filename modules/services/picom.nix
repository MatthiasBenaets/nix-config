#
#  Compositor
#

{ config, lib, pkgs, vars, ... }:

{ 
  config = lib.mkIf (config.bspwm.enable) {
    home-manager.users.${vars.user} = {
      services.picom = {
        enable = true;
        package = pkgs.picom.overrideAttrs(o: {
          src = pkgs.fetchFromGitHub {
            #repo = "picom";
            #owner = "pijulius";
            #rev = "982bb43e5d4116f1a37a0bde01c9bda0b88705b9";
            #sha256 = "YiuLScDV9UfgI1MiYRtjgRkJ0VuA1TExATA2nJSJMhM=";
            repo = "picom";
            owner = "jonaburg";
            rev = "e3c19cd7d1108d114552267f302548c113278d45";
            sha256 = "4voCAYd0fzJHQjJo4x3RoWz5l3JJbRvgIXn1Kg6nz6Y=";
          };
        });                                           # Override Picon Version

        backend = "glx";                              # Glx or Xrender
        vSync = true;                                 # Fix Screen Tearing

        #activeOpacity = 0.93;                        # Transparency
        #inactiveOpacity = 0.93;
        #menuOpacity = 0.93;

        shadow = false;                               # Shadows
        shadowOpacity = 0.75;
        fade = true;
        fadeDelta = 10;
        opacityRules = [                              # Opacity rules if transparency is prefered
          #"100:name = 'Picture in picture'"
          #"100:name = 'Picture-in-Picture'"
          #"85:class_i ?= 'rofi'"
          "80:class_i *= 'discord'"
          "80:class_i *= 'emacs'"
          "80:class_i *= 'Alacritty'"
          #"100:fullscreen"
        ];                                            # Find with $ xprop | grep "WM_CLASS"

        settings = {
          daemon = true;
          use-damage = false;                         # Fixes Flickering
          resize-damage = 1;
          refresh-rate = 0;
          corner-radius = 5;                          # Corners
          round-borders = 5;

          #animations = true;                         # Animations Pijulius
          #animation-window-mass = 0.5;
          #animation-for-open-window = "zoom";
          #animation-stiffness = 350;
          #animation-clamping = false;
          #fade-out-step = 1;

          transition-length = 150;                    # Animations Jonaburg
          transition-pow-x = 0.5;
          transition-pow-y = 0.5;
          transition-pow-w = 0.5;
          transition-pow-h = 0.5;
          size-transition = true;

          detect-rounded-corners = true;              # Extras
          detect-client-opacity = false;
          detect-transient = true;
          detect-client-leader = false;
          mark-wmwim-focused = true;
          mark-ovredir-focues = true;
          unredir-if-possible = true;
          glx-no-stencil = true;
          glx-no-rebind-pixmap = true;
        };
      };
    };
  };
}
