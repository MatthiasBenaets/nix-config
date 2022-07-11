#
#  Specific system configuration settings for macbook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ config, pkgs, user, ... }:

{
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
    yabai = {                             # Tiling window manager
      enable = true;
      package = pkgs.yabai;
      config = {                          # Other configuration options
        layout = "bsp";
        auto_balance = "off";
        split_ratio = "0.50";
        window_border = "on";
        window_border_width = "2";
        window_placement = "second_child";
        focus_follows_mouse = "autoraise";
        mouse_follows_focus = "off";
        top_padding = "10";
        bottom_padding = "10";
        left_padding = "10";
        right_padding = "10";
        window_gap = "10";
      };
      extraConfig = ''
        yabai -m rule --add app='^Emacs$' manage=on
        yabai -m rule --add title='Preferences' manage=off layer=above
        yabai -m rule --add title='^(Opening)' manage=off layer=above
        yabai -m rule --add title='Library' manage=off layer=above
        yabai -m rule --add app='^System Preferences$' manage=off layer=above
        yabai -m rule --add app='Activity Monitor' manage=off layer=above
        yabai -m rule --add app='Finder' manage=off layer=above
        yabai -m rule --add app='^System Information$' manage=off layer=above
        #yabai -m rule --add=
        #yabai -m rule --add=
      '';                                 # Specific rules for if it is managed and on which layer
    };
    skhd = {                              # Hotkey daemon
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        # Open Terminal
        alt - return : /Applications/Alacritty.App/Contents/MacOS/alacritty

        # Toggle Window
        lalt - t : yabai -m window --toggle float && yabai -m window --grid 4:4:1:1:2:2
        lalt - f : yabai -m window --toggle zoom-fullscreen
        lalt - q : yabai -m window --close

        # Focus Window
        lalt - up : yabai -m window --focus north
        lalt - down : yabai -m window --focus south
        lalt - left : yabai -m window --focus west
        lalt - right : yabai -m window --focus east

        # Swap Window
        shift + lalt - up : yabai -m window --swap north
        shift + lalt - down : yabai -m window --swap south
        shift + lalt - left : yabai -m window --swap west
        shift + lalt - right : yabai -m window --swap east

        # Resize Window
        shift + cmd - left : yabai -m window --resize left:-50:0 && yabai -m window --resize right:-50:0
        shift + cmd - right : yabai -m window --resize left:50:0 && yabai -m window --resize right:50:0
        shift + cmd - up : yabai -m window --resize up:-50:0 && yabai -m window --resize down:-50:0
        shift + cmd - down : yabai -m window --resize up:-50:0 && yabai -m window --resize down:-50:0

        # Focus Space
        ctrl - 1 : yabai -m space --focus 1
        ctrl - 2 : yabai -m space --focus 2
        ctrl - 3 : yabai -m space --focus 3
        ctrl - 4 : yabai -m space --focus 4
        ctrl - 5 : yabai -m space --focus 5
        #ctrl - left : yabai -m space --focus prev
        #ctrl - right: yabai -m space --focus next

        # Send to Space
        shift + ctrl - 1 : yabai -m window --space 1
        shift + ctrl - 2 : yabai -m window --space 2
        shift + ctrl - 3 : yabai -m window --space 3
        shift + ctrl - 4 : yabai -m window --space 4
        shift + ctrl - 5 : yabai -m window --space 5
        shift + ctrl - left : yabai -m window --space prev && yabai -m space --focus prev
        shift + ctrl - right : yabai -m window --space next && yabai -m space --focus next

        # Menu
        #cmd + space : for now its using the default keybinding to open Spotlight Search
      '';                                 # Hotkey config
    };
  };

  homebrew = {                            # Declare Homebrew using Nix-Darwin
    enable = true;
    autoUpdate = true;                    # Auto update packages
    cleanup = "zap";                      # Uninstall not listed packages and casks
    brews = [
      "wireguard-tools"
    ];
    casks = [
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
    keyboard = {
      enableKeyMapping = true;            # Needed for skhd
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh''; # Since it's not possible to declare default shell, run this command after build
    stateVersion = 4;
  };
}
