#
#  Apps
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./programs
#           └─ default.nix *
#               └─ ...
#

[
  ./alacritty.nix
  ./rofi.nix
  ./wofi.nix
  #./waybar.nix
  #./games.nix
]
# Waybar.nix is pulled from modules/desktop/..
# Games.nix and flatpak.nix are pulled from desktop/default.nix
