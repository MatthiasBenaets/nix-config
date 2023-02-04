#
# Direnv
#
# create a shell.nix
# create a .envrc and add use nix shell.nix
# direnv allow
# add direnv package to emacs
# add 'eval "$(direnv hook zsh)"' to .zshrc (and same for bash)
#

{ config, lib, pkgs, ... }:

{
  programs = lib.mkIf (config.programs.zsh.enable) {
    zsh = {
      shellInit = ''
        emulate zsh -c "$(direnv hook zsh)"
      '';
    };
  };

  environment = {
    systemPackages = with pkgs; [ direnv nix-direnv ];
    pathsToLink = [
      "/share/nix-direnv"
    ];
  };

  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
  };

  nixpkgs.overlays = [
    (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
  ];
}
