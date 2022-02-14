#
# Compositor
#

{ pkgs, ... }:

{ 
  services.picom = {
    enable = true;
    activeOpacity = "0.8";					# Node transparency
    inactiveOpacity = "0.75";
    backend = "glx";						# Rendering
    fade = true;
    fadeDelta = 5;
    opacityRule = [ 						# Opacity rules
      "100:name *= 'Firefox'"
      "100:name *= 'feh'"
      "95:class_i ?= 'pcmanfm'"
      "95:class_i ?= 'rofi'"
    ];
    shadow = true;						# Shadows
    shadowOpacity = "0.75";
    menuOpacity = "0.95";
#   blur = true;
#   blurExclude = [
#     "class_i = 'polybar'"
#     "class_i = 'alacritty'"
#   ];
  };
}
