#
#  MacOS Modules
#
#  flake.nix
#   └─ ./darwin
#       ├─ <host>.nix
#       └─ ./modules
#           ├─ default.nix *
#           └─ ...
#

[
  # ./alacritty.nix
  ./kitty.nix
  ./skhd.nix
  ./yabai.nix
  ./zsh.nix
  ../../modules/editors/nvim.nix
]
