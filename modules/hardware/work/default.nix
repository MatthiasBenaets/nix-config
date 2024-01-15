#
#  Hardware
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./work
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./hardware
#           └─ ./work
#               ├─ default.nix *
#               └─ ...
#

[
  # ./intel.nix
  ./nvidia.nix
  ./wpa.nix
]
