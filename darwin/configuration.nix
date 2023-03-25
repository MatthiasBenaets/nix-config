#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ config, pkgs, user, system, ... }:

let
   pkgs = import (builtins.fetchGit {
       # Descriptive name to make the store path easier to identify                
       name = "my-old-revision";                                                 
       url = "https://github.com/NixOS/nixpkgs/";                       
       ref = "refs/heads/nixpkgs-unstable";                     
       rev = "b3a285628a6928f62cdf4d09f4e656f7ecbbcafb";                                           
   }) { inherit system ; };                                                                           

   kubectl_1_25_4 = pkgs.kubectl;

in
{
  imports = [
    ./modules/yabai.nix
    ./modules/skhd.nix
  ];

  users.users."${user}" = {               # macOS user
    home = "/Users/${user}";
    shell = pkgs.zsh;                     # Default shell
  };

  networking = {
    computerName = "Toms MacBook";             # Host name
    hostName = "WKSMAC151152";
  };

  security.pam.enableSudoTouchIdAuth = true;

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      source-code-pro
      font-awesome
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
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
      alacritty

      # Command-line tools
      coreutils fzf ripgrep argo argocd bat colordiff cowsay colima
      gawk kubectx kubectl_1_25_4 google-cloud-sdk kustomize
      helmfile kubernetes-helm htop hugo k9s krew stern crane diffoscope

      minikube kind neofetch octant sipcalc tmate tree wget openssh keychain
      watch git-crypt gnupg gpg-tui cosign jq docker-client starship diceware glow spicetify-cli

      # Development
      git gcc gnumake python2 python38 cargo go yarn protobuf lima goreleaser cmctl niv vulnix syft grype

      # Extra Stuff
      lima
    ] ++ [ kubectl_1_25_4];
  };

  programs.zsh.enable = true;                            # Shell needs to be enabled

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
    ];
    brews = [
      "FelixKratz/formulae/sketchybar"
      "ddcctl"
      "ykman"
    ];
    casks = [
      "google-chrome"
      "now-tv-player"
      "plex-media-player"
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
      "logi-options-plus"
      "iterm2"
      "readdle-spark"
      "element"
      "zoom"
      "microsoft-teams"
      "yubico-yubikey-manager"
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
