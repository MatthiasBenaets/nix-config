#
# Compositor
#

{ config, lib, pkgs, ... }:

{ 
  config = lib.mkIf (config.xsession.enable == true) {
  services.picom = {
    enable = true;
    activeOpacity = "1";                          # Node transparency
    inactiveOpacity = "1";
    backend = "glx";                              # Rendering (opengl) - Laptop might need xrender
    fade = true;
    fadeDelta = 5;
    opacityRule = [                               # Opacity rules if transparency is prefered
      "95:class_i ?= 'pcmanfm'"
      "95:class_i ?= 'rofi'"
      "80:class_i *= 'discord'"
      "80:class_i *= 'emacs'"
      "80:class_i *= 'Alacritty'"
    ];
    shadow = true;                                # Shadows
    shadowOpacity = "0.75";
    menuOpacity = "0.95";
#   blur = true;
#   blurExclude = [
#     "class_i = 'polybar'"
#     "class_i = 'alacritty'"
#   ];
    vSync = true;                                 # Should fix screen tearing
  };
};
}
