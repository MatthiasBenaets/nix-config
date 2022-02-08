{ 
  services.picom = {
    enable = true;
    activeOpacity = "0.8";
    inactiveOpacity = "0.5";
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    #opacityRule = [ "100:name *= 'i3lock'" ];
    shadow = true;
    shadowOpacity = "0.75";
  };
}
