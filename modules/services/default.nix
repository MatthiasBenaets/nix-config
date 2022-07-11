#
#  Services
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./services
#           └─ default.nix *
#               └─ ...
#

[
  ./dunst.nix
  ./flameshot.nix
  ./picom.nix
  ./polybar.nix
  ./sxhkd.nix
  ./udiskie.nix
  ./redshift.nix
]

# Media is pulled from desktop default config
