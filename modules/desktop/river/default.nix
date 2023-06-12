#
# River configuration
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
    '';                                   # Will automatically open River when logged into tty1
    variables = {
      #LIBCL_ALWAYS_SOFTWARE = "1";       # For applications in VM like alacritty to work
      #WLR_NO_HARDWARE_CURSORS = "1";     # For cursor in VM
    };
    systemPackages = with pkgs; [
      river
      wev
      wl-clipboard
      wlr-randr
      xdg-desktop-portal-wlr
      xwayland
    ];
  };

  programs.dconf.enable = true;

  xdg.portal = {                          # Required for flatpak with window managers
    enable = true;
    wlr.enable = true;                    # XDG for Wayland
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #gtkUsePortal = true;
  };
}
