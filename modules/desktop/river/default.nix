#
#  Bspwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./river
#               └─ default.nix *
#

{ config, lib, pkgs, ... }:

{

  imports = [ ../../programs/waybar.nix ];

  hardware.opengl.enable = true;

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec river
      fi
    '';                                   # Will automatically open sway when logged into tty1
    variables = {
      #LIBCL_ALWAYS_SOFTWARE = "1";       # For applications in VM like alacritty to work
      #WLR_NO_HARDWARE_CURSORS = "1";     # For cursor in VM
    };
    systemPackages = with pkgs; [
      river
      wlr-randr
      xdg-desktop-portal-wlr
    ];
  };

  programs.dconf.enable = true;

  xdg.portal = {                          # Required for flatpak with windowmanagers
    enable = true;
    wlr.enable = true;                    # Xdg for wayland
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #gtkUsePortal = true;
  };
}
