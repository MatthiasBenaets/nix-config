#
# Compositor
#

{ pkgs, ... }:

{ 
  services.picom = {
    enable = true;
    activeOpacity = "0.8";                        # Node transparency
    inactiveOpacity = "0.75";
    backend = "xrender";                          # Rendering
    fade = true;
    fadeDelta = 5;
    opacityRule = [                               # Opacity rules
      "100:class_i ?= 'google-chrome'"
      "100:name *= 'feh'"
      "100:class_i *= 'libreoffice'"
      "100:class_i *= 'vlc'"
      "100:class_i *= 'pavucontrol'"
      "100:class_i *= 'plexmediaplayer'"
      "95:class_i ?= 'pcmanfm'"
      "85:class_i ?= 'rofi'"
      "75:class_i *= 'Alacritty'"
    ];
    shadow = true;                                # Shadows
    shadowOpacity = "0.75";
    menuOpacity = "0.95";
#   blur = true;
#   blurExclude = [
#     "class_i = 'polybar'"
#     "class_i = 'alacritty'"
#   ];
  };
}
