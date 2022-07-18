#
#  Sway configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ hyprland.nix *
#

{ config, lib, pkgs, protocol, ... }:

{
  imports = [ ../../programs/waybar.nix ];

  config = lib.mkIf ( protocol == "Wayland" ) {
    hardware.opengl.enable = true;

    environment = {
      loginShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec Hyprland
        fi
      '';                                   # Will automatically open sway when logged into tty1
      variables = {
        #LIBCL_ALWAYS_SOFTWARE = "1";       # For applications in VM like alacritty to work
        #WLR_NO_HARDWARE_CURSORS = "1";     # For cursor in VM
      };
    };

    programs = {
      hyprland.enable = true;
    };
  };
}
