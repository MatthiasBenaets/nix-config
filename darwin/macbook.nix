#
#  Specific system configuration settings for MacBook 8,1
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       ├─ macbook.nix *
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

  networking = {
    computerName = "MacBook";
    hostName = "MacBook";
  };

  skhd.enable = false;
  yabai.enable = false;

  fonts = {
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
    shells = with pkgs; [ zsh ];
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [
      # Terminal
      git
      ranger

      # Remote
      moonlight-qt
    ];
  };

  programs = {
    zsh.enable = true;
  };

  services = {
    nix-daemon.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      # "wireguard-tools"
    ];
    casks = [
      # "canon-eos-utility"
      # "jellyfin-media-player"
      "obs"
      "plex-media-player"
      "stremio"
      "virtualbox" # sudo codesign --force --deep --sign - /Applications/VirtualBox.app/Contents/Resources/VirtualBoxVM.app
    ];
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
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.keyboard.fnState" = true;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.trackpad.enableSecondaryClick" = true;
      };
      dock = {
        autohide = false;
        largesize = 36;
        tilesize = 24;
        magnification = true;
        mineffect = "genie";
        orientation = "bottom";
        showhidden = false;
        show-recents = false;
      };
      finder = {
        AppleShowAllFiles = false;
        ShowPathbar = true;
        QuitMenuItem = false;
      };
      # keyboard = {
      #   remapCapsLockToEscape = true;
      # };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
      magicmouse = {
        MouseButtonMode = "TwoButton";
      };
      # CustomUserPreferences = {
      # # ~/Library/Preferences/
      # }
      # CustomSystemPreferences = {
      # # ~/Library/Preferences/
      # }
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh'';
    # # Reload all settings without relog/reboot
    # activationScripts.postUserActivation.text = ''
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';
    stateVersion = 4;
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "22.05";
    };

    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        history.size = 10000;
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
          custom = "$HOME/.config/zsh_nix/custom";
        };
        initExtra = ''
          source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
          autoload -U promptinit; promptinit
        '';
      };
    };
  };
}
