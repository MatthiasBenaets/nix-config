#
# Doom Emacs: home-manager alternative in "native.nix". Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ default.nix *
#


{ config, pkgs, doom-emacs, ... }:

{
  imports = [ doom-emacs.hmModule ];

  services.emacs = {
    enable = true;
    package = doom-emacs;
  };

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
