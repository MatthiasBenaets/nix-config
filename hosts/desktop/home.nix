#{ config, pkgs, ... }:
{ pkgs, ... }:

{

  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";

    packages = with pkgs; [
      neofetch
      polybar
    ];
  };

  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh_nix";
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      history.size = 10000;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        custom = "$HOME/.config/zsh_nix/custom";
      };

      initExtra = ''
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
      #  source $HOME/.config/shell/shell_init
      #  # Hook direnv
      #  emulate zsh -c "$(direnv hook zsh)"
      '';
    };
  };

  services = {
    polybar = {
      enable = true;
      script = "polybar mybar &";
      config = {
        "bar/mybar" = {
          width = "100%";
          height = "3%";
          radius = 0;
          modules-center = "date";
        };

        "module/date" = {
          type = "internal/date";
          internal = 5;
          date = "%d.%m.%y";
          time = "%H:%M";
          label = "%time%  %date%";
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  xsession = {
    numlock.enable = true;

    pointerCursor = {
      name = "Numix-Snow";
      package = pkgs.numix-cursor-theme;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Source Code Pro 11";
    };
  };

  home.stateVersion = "22.05";
}
