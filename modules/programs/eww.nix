#
# Bar
#

{ config, lib, pkgs, unstable, host, user, ...}:

{
  environment.systemPackages = with unstable; [
    eww-wayland
  ];

  home-manager.users.${user} = {                           # Home-manager eww config link
    home.file.".config/eww" = {
      source = ./eww;
      recursive = true;
    };
  };
}
