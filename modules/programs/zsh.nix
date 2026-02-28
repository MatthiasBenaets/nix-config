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
}
