#
#  Hardware
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./services
#           └─ default.nix *
#               └─ ...
#
[
  ./dslr.nix 
  ./bluetooth.nix
]
