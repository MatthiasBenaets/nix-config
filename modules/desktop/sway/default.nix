#
#  Sway configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./sway
#               └─ sway.nix *
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
        ##swayidle        # Idle Management Daemon
        wev             # Input viewer
        wl-clipboard    # Commandline Clipboard #alternative clipman/wayclip
        #kanshi         # Autorandr #not needed with single laptopscreen. need to find something like arandr
        xwayland
        wayvnc
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 5900 ];   # Used for vnc
}
