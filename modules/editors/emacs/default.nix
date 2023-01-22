#
# Personal Emacs config. Can be set up with vanilla nixos or with home-manager (see comments at bottom)
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ default.nix *
#


{ config, pkgs, ... }:

{
  services.emacs = {
    enable = true;
  };

  system.activationScripts = {
    emacs.text = ''
      CONFIG="$HOME/.emacs.d"

      if [ ! -d "$CONFIG" ]; then
        git clone https://github.com/matthiasbenaets/emacs.d.git $CONFIG
      fi
    '';

  };
}

#Home-manager
  #programs.emacs = {
  #  enable = true;
  #}; # also keep services.emacs
  #
  #home = {
  #  activation = {
  #    emacs = ''
  #    '';
  #  };
  #};
