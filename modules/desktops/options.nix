#
#  Options to enable packages depending on the DE/WM. They options are enabled in the <desktop>.nix files.
#

{ lib, ... }:

with lib;
{
  options = {
    wlwm = {
      # Condition if host uses a wayland window manager
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    laptop = {
      # Condition if host is a laptop
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
}
