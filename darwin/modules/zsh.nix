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
        history.size = 10000;
        initExtra = ''
          # Search history
          autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
          zle -N up-line-or-beginning-search
          zle -N down-line-or-beginning-search
          bindkey '^[[A' up-line-or-beginning-search
          bindkey '^[[B' down-line-or-beginning-search

          # Powerlevel10k prompt
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

          # Set up completion and set color for selected suggestion
          zstyle ':completion:*' menu select
          ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'

          # Aliases
          alias ls="${pkgs.eza}/bin/eza --icons=always --color=always"
          alias -g ...=../..
          alias -g ....=../../..
        '';
      };
    };
  };
}
