#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ config, pkgs, user, system, ... }:
{

  users.users."${user}" = {               # macOS user
    home = "/Users/${user}";
    shell = pkgs.zsh;                     # Default shell
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Moved all the global package setup to pkgs/default.nix

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
    taps = [
      "FelixKratz/formulae"
      "homebrew/cask-drivers"
      "homebrew/core"
      "homebrew/cask"
      "homebrew/bundle"
      "homebrew/services"
      "xwmx/tap"
      "koekeishiya/formulae"
    ];
    brews = [
      "FelixKratz/formulae/sketchybar"
      "koekeishiya/formulae/skhd"
      "koekeishiya/formulae/yabai"
      "ddcctl"
      "ykman"
      "gpg"
      "pinentry"
      "blueutil"
      "colima"
      "wifi-password"
    ];
    casks = [
      "akiflow"
      "launchcontrol"
      "kitty"
      "gpg-suite"
      "firefox"
      "google-chrome"
      "now-tv-player"
      "plex"
      "steam"
      "alacritty"
      "slack"
      "spotify"
      "notion"
      "raycast"
      "transmission"
      "via"
      "vlc"
      "visual-studio-code"
      "insomnia"
      "nordvpn"
      "nordpass"
      "logi-options-plus"
      "iterm2"
      "readdle-spark"
      "element"
      "zoom"
      "microsoft-teams"
      "yubico-yubikey-manager"
      "citrix-workspace"
      "sf-symbols"
    ];
  };

  system = {
    defaults = {
      NSGlobalDomain = {                  # Global macOS system settings
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        _HIHideMenuBar = true;
        "com.apple.swipescrolldirection" = false;
        AppleTemperatureUnit = "Celsius";

      };
      dock = {               # Dock settings
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        dashboard-in-overlay = true;
        expose-animation-duration = 0.0;
        launchanim = false;
        orientation = "left";
        showhidden = true;
        mru-spaces = false;
        show-recents = false;
        static-only = true;
        tilesize = 40;
      };
      finder = {                          # Finder settings
        QuitMenuItem = true;              # I believe this probably will need to be true if using spacebar
        AppleShowAllExtensions = true; 
      };  
      trackpad = {                        # Trackpad settings
        Clicking = true;
        TrackpadRightClick = true;
      };
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
      };
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh''; # Since it's not possible to declare default shell, run this command after build
    stateVersion = 4;
  };
}
