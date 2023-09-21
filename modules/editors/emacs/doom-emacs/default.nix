#
#  Doom Emacs: Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
#  This is an ideal way to install on a vanilla NixOS installion.
#  You will need to import this from somewhere in the flake (Obviously not in a home-manager nix file)
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           ├─ default.nix
#           └─ ./emacs
#               └─ ./doom-emacs
#                   └─ default.nix *
#


{ config, pkgs, vars, ... }:

{
  services.emacs.enable = true;

  system.userActivationScripts = {               # Installation Script on Rebuild
    doomEmacs = {
      text = ''
        source ${config.system.build.setEnvironment}
        EMACS="$HOME/.emacs.d"

        if [ ! -d "$EMACS" ]; then
          ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs.git $EMACS
          yes | $EMACS/bin/doom install
          rm -r $HOME/.doom.d
          ln -s ${vars.location}/modules/editors/emacs/doom-emacs/doom.d $HOME/.doom.d
          $EMACS/bin/doom sync
        else
          $EMACS/bin/doom sync
        fi
      '';                                        # Will Sync on Changes
    };
  };

  environment.systemPackages = with pkgs; [
    clang
    coreutils
    emacs
    fd
    git
    ripgrep
  ];
}
