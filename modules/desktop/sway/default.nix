#
#  Sway configuration
#

{ config, lib, pkgs, ... }:

{
  imports = [ ../../programs/waybar.nix ];

  hardware.opengl.enable = true;

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';                                   # Will automatically open sway when logged into tty1
    variables = {
      #LIBCL_ALWAYS_SOFTWARE = "1";       # For applications in VM like alacritty to work
      #WLR_NO_HARDWARE_CURSORS = "1";     # For cursor in VM
    };
  };

  programs = {
    sway = {                              # Tiling Wayland compositor & window manager
      enable = true;
      extraPackages = with pkgs; [
        autotiling      # Tiling Script
        wev             # Input viewer
        wl-clipboard    # Commandline Clipboard #alternative clipman/wayclip
        wlr-randr
        xwayland
      ];
    };
  };

  xdg.portal = {                                  # Required for flatpak with window managers
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
