#
#  Specific system configuration settings for MacBook Air M1 10,1
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       └─ ./m1.nix *
#

{ config, lib, pkgs, vars, ... }:

{
  imports = import (./modules);

  hyprspace.enable = true;

  environment = {
    systemPackages = with pkgs; [
    ];
  };

  homebrew = {
    brews = [
      "ansible"
      "ansible-lint"
      "docker-compose"
    ];
    casks = [
      "adobe-creative-cloud"
      "autodesk-fusion"
      "BarutSRB/tap/hyprspace"
      # "bettertouchtool"
      "blender"
      # "connectiq"
      "darktable"
      "dbeaver-community"
      "deluge"
      "docker-desktop"
      "garmin-express"
      "google-chrome"
      "handbrake-app"
      "love"
      "local"
      "linearmouse"
      "mkvtoolnix"
      # "obsidian"
      "ollama-app"
      "openmtp"
      "orcaslicer"
      "portfolioperformance"
      "httpie-desktop"
      # "r-app"
      "raycast"
      # "rstudio"
      "upscayl"
      "utm"
      "visual-studio-code"
      "wacom-tablet"
      "xnviewmp"
    ];
    masApps = {
      "Adguard for Safari" = 1440147259; # Safari
      "Bitwarden" = 1352778147; # Safari
      # "FileZilla Pro - FTP and Client" = 1298486723;
      # "FileZilla Pro RemoteDrive" = -2087754162;
      "Keynote" = 409183694;
      "LanguageTool - Grammer Checker" = 1534275760; # Safari
      "Microsoft Remote Desktop" = 1295203466;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Sauce for Strava™" = 1570922521; # Safari
      "Userscripts" = 1463298887; # Safari
      "Xcode" = 497799835;
    };
  };

  system = {
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
    programs = lib.mkIf (config.programs.zsh.enable) {
      zsh = {
        initContent = ''
          export PATH=$PATH:`cat $HOME/Library/Application\ Support/Garmin/ConnectIQ/current-sdk.cfg`/bin
        '';
      };
    };
  };
}
