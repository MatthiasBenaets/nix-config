#
#  Home-manager configuration for macbook
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   └─ ./home.nix *
#   └─ ./modules
#       └─ ./programs
#           └─ ./alacritty.nix
#

{ pkgs, ... }:

{
  imports = 
    [
      ../modules/programs/alacritty.nix
      ../modules/shell/zsh.nix
      ../modules/editors/nvim/nvim.nix
      ./modules/sketchybar/sketchybar.nix
    ];
  home = {                                        # Specific packages for macbook
    packages = with pkgs; [
      # Terminal
      pfetch
    ];
    stateVersion = "22.05";
  };

  programs = {
    git = {
      enable = true;
      userName = "chaosinthecrd";
      userEmail = "tom@tmlabs.co.uk";
    };
    alacritty = {
      enable = true;
    };
    kitty = {
      enable = true;
    };
    zsh = {                                       # Post installation script is run in configuration.nix to make it default shell
      enable = true;
      enableAutosuggestions = true;               # Auto suggest options and highlights syntax. It searches in history for options
      enableSyntaxHighlighting = true;
      history.size = 10000;

      oh-my-zsh = {                               # Extra plugins for zsh
        enable = true;
        plugins = [ "git" ];
        custom = "$HOME/.config/zsh_nix/custom";
      };

      initExtra = ''
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
      '';                                         # Zsh theme
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
