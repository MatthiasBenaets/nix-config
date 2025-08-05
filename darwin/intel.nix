#
#  Specific system configuration settings for MacBook 8,1
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       └─ ./intel.nix *
#

{ pkgs, vars, ... }:

{
  # imports = import (./modules);

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
      cargo
      eza # Ls
      git # Version Control
      neovim # Editor
      nodejs
      python3
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

  networking = {
    computerName = "MacBook";
    hostName = "MacBook";
  };

  # skhd.enable = false;
  # yabai.enable = false;

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      "docker-compose"
    ];
    casks = [
      "aldente"
      "alfred"
      "appcleaner"
      "docker-desktop"
      "firefox"
      "jellyfin-media-player"
      "moonlight"
      "obs"
      "rectangle"
      "stremio"
      "vlc"
      # "virtualbox" # sudo codesign --force --deep --sign - /Applications/VirtualBox.app/Contents/Resources/VirtualBoxVM.app
    ];
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
        minimize-to-application = true;
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
      # # /Users/${vars.user}/Library/Preferences/
      # }
      # CustomSystemPreferences = {
      # # /Users/${vars.user}/Library/Preferences/
      # }
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh'';
    # # Reload all settings without relog/reboot
    # activationScripts.postUserActivation.text = ''
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';
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
