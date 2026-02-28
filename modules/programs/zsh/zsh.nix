{
  flake.modules.nixos.base =
    { config, pkgs, ... }:
    {

      users.users.${config.host.user.name} = {
        shell = pkgs.zsh;
      };

      programs = {
        zsh = {
          enable = true;
          autosuggestions.enable = true;
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          histSize = 100000;

          ohMyZsh = {
            enable = true;
            plugins = [ "git" ];
          };

          shellInit = ''
            # Spaceship
            source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
            autoload -U promptinit; promptinit
            # Hook direnv
            #emulate zsh -c "$(direnv hook zsh)"

            #eval "$(direnv hook zsh)"
          '';
        };
      };
    };

  flake.modules.darwin.base =
    { config, pkgs, ... }:
    {
      users.users.${config.host.user.name} = {
        shell = pkgs.zsh;
      };

      programs.zsh.enable = true;
    };

  flake.modules.homeManager.zsh =
    {
      osConfig,
      lib,
      pkgs,
      ...
    }:
    {
      home.file.".p10k.zsh".source = ./p10k.zsh;

      home.packages = with pkgs; [
        eza
        zsh-powerlevel10k
      ];

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
          initContent = ''
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'

            alias ls="${pkgs.eza}/bin/eza --icons=always --color=always"
            alias finder="ofd" # open find in current path.
            #cdf will change directory to active finder directory

            ssh-add --apple-load-keychain &>/dev/null
          ''
          + lib.optionalString (osConfig.host.user.name == "m1") ''
            export PATH=$PATH:`cat $HOME/Library/Application\ Support/Garmin/ConnectIQ/current-sdk.cfg`/bin
          '';
        };
      };
    };
}
