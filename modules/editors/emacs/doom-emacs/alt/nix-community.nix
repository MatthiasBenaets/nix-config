#
# Doom Emacs: home-manager alternative in "native.nix" and "default.nix". Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
# To make use of this module you will need to have doom-emacs as one of the inputs of the flake.
# This module is set up to be used with home-manager.
#
# flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ ./doom-emacs
#                   └─ ./alt
#                       └─ nix-community.nix *
#


{ config, pkgs, doom-emacs, ... }:

{
  imports = [ doom-emacs.hmModule ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };

  home.packages = with pkgs; [
    ripgrep
    coreutils
    fd
  ];                                             # Dependencies
}
