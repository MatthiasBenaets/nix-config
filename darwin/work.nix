#
#  Work MacOS system configuration.
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       ├─ work.nix *
#       └─ ./modules
#           └─ default.nix
#

{ pkgs, vars, ... }:

{
  imports = import (./modules);

  aerospace.enable = true;

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

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      "ansible"
      "ansible-lint"
      "docker-compose"
    ];
    casks = [
      # "adobe-creative-cloud"
      # "bettertouchtool"
      "cyberduck"
      "dbeaver-community"
      "docker-desktop"
      "firefox"
      "jordanbaird-ice"
      "local"
      "linearmouse"
      "moonlight"
      "obs"
      "postman"
      "quarto"
      "r-app"
      "raycast"
      "rstudio"
      "utm"
      "xquartz"
    ];
    masApps = {
      "wireguard" = 1451685025;
    };
  };

  system = {
    primaryUser = vars.user;
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.trackpad.enableSecondaryClick" = true;
        # "com.apple.keyboard.fnState" = true;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.2;
        autohide-time-modifier = 0.1;
        magnification = true;
        mineffect = "scale";
        # minimize-to-application = true;
        orientation = "bottom";
        showhidden = false;
        show-recents = false;
        tilesize = 20;
      };
      finder = {
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
      magicmouse = {
        MouseButtonMode = "TwoButton";
      };

      CustomUserPreferences = {
        # Settings of plist in /Users/${vars.user}/Library/Preferences/
        "com.apple.finder" = {
          # Set home directory as startup window
          NewWindowTargetPath = "file:///Users/${vars.user}/";
          NewWindowTarget = "PfHm";
          # Set search scope to directory
          FXDefaultSearchScope = "SCcf";
          # Multi-file tab view
          FinderSpawnTab = true;
        };
        "com.apple.desktopservices" = {
          # Disable creating .DS_Store files in network an USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        # Show battery percentage
        "/Users/${vars.user}/Library/Preferences/ByHost/com.apple.controlcenter".BatteryShowPercentage = true;
        # Privacy
        "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      };
      CustomSystemPreferences = {
        # /Users/${vars.user}/Library/Preferences/
      };
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
    optimise = {
      automatic = true;
      interval.Day = 7;
    };
    extraOptions = ''
      # auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {
    stateVersion = 5;
  };
}
