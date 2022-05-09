{ config, lib, pkgs, ... }:

{
  hardware.opengl.enable = true;

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';                                   # Will automatically open sway when logged into tty1
    variable = {
      #XKB_DEFAULT_LAYOUT = "us";         # Keyboard layout
      #LIBCL_ALWAYS_SOFTWARE = "1";       # For applications in VM like alacritty to work
      #WLR_NO_HARDWARE_CURSORS = "1";     # For cursor in VM
    };
  };

  programs = {
    sway = {                              # Tiling Wayland compositor & window manager
      enable = true;
      extraPackages = with pkgs; [
        #swaylock       # Screen Locker
        #swayidle       # Idle Management
        #wl-clipboard   # Commandline Clipboard
        #mako           # Notifications
        #kanshi         # Autorandr
        #
        #dmenu           # Menu
        #wofi           # Menu
        autotiling      # Tiling Script
      ];
    };
  };

  sound.enable = true;                    # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}
