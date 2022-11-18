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
  #./flameshot.nix
  #./picom.nix
  #./polybar.nix
  #./sxhkd.nix
  ./udiskie.nix
  #./redshift.nix
]

# flameshot, picom, polybar and sxhkd are pulled from desktop module
# redshift temporarely disables
