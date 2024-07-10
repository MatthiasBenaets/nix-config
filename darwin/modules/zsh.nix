#
#  Shell
#

{ pkgs, vars, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      eza # Ls
      zsh-powerlevel10k # Prompt
    ];
  };

  home-manager.users.${vars.user} = {
    home.file.".p10k.zsh".source = ./p10k.zsh;

    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        history.size = 10000;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "macos"
          ];
        };
        initExtra = ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

          ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'

          alias ls="${pkgs.eza}/bin/eza --icons=always --color=always"
          alias finder="ofd"
        '';
      };
    };
  };
}
