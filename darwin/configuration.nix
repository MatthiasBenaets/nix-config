#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ config, pkgs, user, ... }:

{
  #imports = [
  #  ./modules/yabai.nix
  #  ./modules/skhd.nix
  #];

  users.users."${user}" = {               # macOS user
    home = "/Users/${user}";
    shell = pkgs.zsh;                     # Default shell
  };

  networking = {
    computerName = "MacBook";             # Host name
    hostName = "MacBook";
  };

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      source-code-pro
      font-awesome
      (nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
    ];
  };

  environment = {
    shells = with pkgs; [ zsh ];          # Default shell
    variables = {                         # System variables
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [         # Installed Nix packages
      # Terminal
      ansible
      git
      ranger

      # Doom Emacs
      emacs
      fd
      ripgrep
    ];
  };

  programs = {                            # Shell needs to be enabled
    zsh.enable = true;
  };

  services = {
    nix-daemon.enable = true;             # Auto upgrade daemon
  };

  homebrew = {                            # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = false;                 # Auto update packages
      upgrade = false;
      cleanup = "zap";                    # Uninstall not listed packages and casks
    };
    brews = [
      "wireguard-tools"
    ];
    casks = [
      "parsec"
      "plex-media-player"
    ];
  };

  nix = {
    package = pkgs.nix;
    gc = {                                # Garbage collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {
    defaults = {
      NSGlobalDomain = {                  # Global macOS system settings
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {                            # Dock settings
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
      };
      finder = {                          # Finder settings
        QuitMenuItem = false;             # I believe this probably will need to be true if using spacebar
      };  
      trackpad = {                        # Trackpad settings
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh''; # Since it's not possible to declare default shell, run this command after build
    stateVersion = 4;
  };
}
