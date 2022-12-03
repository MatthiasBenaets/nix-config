#
#  Hyprland configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ default.nix *
#

{ config, lib, pkgs, ... }:

{
  imports = [ ../../programs/waybar.nix ];

  services.dbus.enable = true;

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';                                   # Will automatically open Hyprland when logged into tty1

    variables = {
      #WLR_NO_HARDWARE_CURSORS=1;         # Possible variables needed in vm
      #WLR_RENDERER_ALLOW_SOFTWARE=1;
      XDG_CURRENT_DESKTOP="Hyprland";
      XDG_SESSION_TYPE="wayland";
      XDG_SESSION_DESKTOP="Hyprland";
    };
    systemPackages = with pkgs; [
      grim
      mpvpaper
      slurp
      swappy
      wl-clipboard
      wlr-randr
    ];
  };

  programs = {
    hyprland.enable = true;
  };
}
