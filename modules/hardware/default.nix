#
#  Hardware
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./hardware
#           └─ default.nix *
#               └─ ...
#
[
  ./dslr.nix 
  ./bluetooth.nix
]
