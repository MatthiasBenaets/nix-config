#
#  Personal Emacs Config
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       ├─ default.nix
#       └─ ./editors
#           └─ ./emacs
#               └─ default.nix *
#


{ config, pkgs, vars, ... }:

{
  services.emacs = {
    enable = true;
  };

  system.activationScripts = {
    emacs.text = ''
      CONFIG="/home/${vars.user}/.emacs.d"

      if [ ! -d "$CONFIG" ]; then
        ${pkgs.git}/bin/git clone https://github.com/matthiasbenaets/emacs.d.git $CONFIG
      fi

      chown -R ${vars.user}:users /home/${vars.user}/.emacs.d
    '';
  };

  environment.systemPackages = with pkgs; [
    emacs
    emacs-all-the-icons-fonts
    fd
    ispell
    ripgrep
  ];
}
