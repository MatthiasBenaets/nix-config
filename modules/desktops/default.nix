#
#  Desktop Environments & Window Managers
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./desktops
#           ├─ default.nix *
#           └─ ...
#

[
  ./bspwm.nix
  ./gnome.nix
  ./hyprland.nix
  ./kde.nix
  ./options.nix
  ./river.nix
  ./sway.nix
]
