#
#  Virtualisation Modules
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktops
#           └─ ./virtualisation
#               ├─ default.nix *
#               └─ ...
#

[
  ./docker.nix
  ./qemu.nix
  ./x11vnc.nix
]
