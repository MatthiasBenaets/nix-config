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
      "95:name *= 'Rofi'"
    ];
    shadow = true;						# Shadows
    shadowOpacity = "0.75";
  };
}
