#
# Shell
#

{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh_nix";
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
#       source $HOME/.config/shell/shell_init
        # Hook direnv
#       emulate zsh -c "$(direnv hook zsh)"
        # Swag
        pfetch                                  # Show fetch logo on terminal start
      '';
    };
  };
}
