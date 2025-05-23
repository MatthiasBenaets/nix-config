#
#  Main MacOS system configuration.
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       ├─ darwin-configuration.nix *
#       └─ ./modules
#           └─ default.nix
#

{ pkgs, vars, ... }:

{
  imports = (import ./modules);

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  environment = {
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
      eza # Ls
      git # Version Control
      mas # Mac App Store $ mas search <app>
      ranger # File Manager
      tldr # Help
      wget # Download
      zsh-powerlevel10k # Prompt
    ];
  };

  programs = {
    zsh.enable = true;
    direnv = {
      enable = true;
      loadInNixShell = true;
      nix-direnv.enable = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
      cleanup = "zap";
    };
    casks = [
      "aldente"
      "appcleaner"
      "firefox"
      "jellyfin-media-player"
      "moonlight"
      "obs"
      "prusaslicer"
      "raycast"
      "stremio"
      "vlc"
      # "canon-eos-utility"
    ];
    masApps = {
      "wireguard" = 1451685025;
    };
  };

  home-manager.users.${vars.user} = {
    home.stateVersion = "22.05";
  };

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      # auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {
    primaryUser = vars.user;
    stateVersion = 4;
  };
}
