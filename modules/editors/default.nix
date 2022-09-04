#
#  Editors
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./home.nix
#   └─ ./modules
#       └─ ./services
#           └─ default.nix *
#               └─ ...
#

[
  ./nvim
  ./emacs
]
# emacs get pulled from hosts configuration
