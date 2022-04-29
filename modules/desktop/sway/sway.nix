{ config, lib, pkgs, ... }:

{
  #future reference https://github.com/gytis-ivaskevicius/nixfiles/tree/2b2abcd07ede0df56360a8cda50a919a65864f8c when I switch to wayland
  hardware.opengl.enable = true;

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';                                   # Will automatically open sway when logged into tty1
    variable = {
      XKB_DEFAULT_LAYOUT = "be";          # Keyboard layout
      #LIBCL_ALWAYS_SOFTWARE = "1";       # For applications in VM like alacritty to work
      #WLR_NO_HARDWARE_CURSORS = "1";     # For cursor in VM
    };
  };

  programs = {
    sway = {                              # Tiling Wayland compositor & window manager
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        #swaylock       # Screen Locker
        #swayidle       # Idle Management
        #wl-clipboard   # Commandline Clipboard
        #mako           # Notifications
        #kanshi         # Autorandr
        #
        foot            # Terminal
        dmenu           # Menu
        #wofi           # Menu
      ];
    };
    waybar.enable = true;                 # Bar
  };

  services.pipewire = {                   # Sound
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}
