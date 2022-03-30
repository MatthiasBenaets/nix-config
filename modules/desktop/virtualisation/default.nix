#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./virtualisation
#               └─ default.nix *
#

[
  ./docker.nix
  ./qemu.nix
]

# x11vnc is pulled form desktop default config
