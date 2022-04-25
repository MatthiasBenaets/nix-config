#
#  Home-manager configuration for macbook
#
#  flake.nix
#   └─ ./hosts
#       └─ ./macbook
#           └─ home.nix *
#

{ pkgs, ... }:

{
  imports = [
  ];

  home = {                                # Specific packages for macbook
    packages = with pkgs; [
      # Applications
      pfetch
    ];
  };

  programs = {
    alacritty = {
      enable = true;
    };
    zsh = {                               # So for some reason it won't change default shell on it's own
      enable = true;                      # Run: chsh -s /bin/zsh
      enableAutosuggestions = true;             # Auto suggest options and highlights syntact, searches in history for options
      enableSyntaxHighlighting = true;
      history.size = 10000;

      oh-my-zsh = {                             # Extra plugins for zsh
        enable = true;
        plugins = [ "git" ];
        custom = "$HOME/.config/zsh_nix/custom";
      };

      initExtra = ''                            # Zsh theme
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
        pfetch
      '';
    };
  };

  home.stateVersion = "22.05";
}
