#
#  Home-manager configuration for macbook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./home.nix *
#

{ pkgs, ... }:

{
  imports = [
  ];

  home = {                                      # Specific packages for macbook
    packages = with pkgs; [
      # Applications
      pfetch
    ];
  };

  programs = {
    alacritty = {                               # Terminal Emulator
      enable = true;
    };
    zsh = {                                     # Post installation script is run in configuration.nix to make it default shell
      enable = true;
      enableAutosuggestions = true;             # Auto suggest options and highlights syntact, searches in history for options
      enableSyntaxHighlighting = true;
      history.size = 10000;

      oh-my-zsh = {                             # Extra plugins for zsh
        enable = true;
        plugins = [ "git" ];
        custom = "$HOME/.config/zsh_nix/custom";
      };

      initExtra = ''
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
        pfetch
      '';                                       # Zsh theme
    };
  };

  home.stateVersion = "22.05";
}
