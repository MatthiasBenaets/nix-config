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

{ config, pkgs, vars, ... }:

{
  imports = ( import ./modules );

  users.users.${vars.user} = {            # MacOS User
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;                     # Default Shell
  };

  networking = {
    computerName = "MacBook";             # Host Name
    hostName = "MacBook";
  };

  skhd.enable = false;                    # Window Manager
  yabai.enable = false;                   # Hotkeys

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
    shells = with pkgs; [ zsh ];          # Default Shell
    variables = {                         # Environment Variables
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [         # System-Wide Packages
      # Terminal
      ansible
      git
      pfetch
      ranger
      neovim
    ];
  };

  programs = {
    zsh.enable = true;                    # Shell
  };

  services = {
    nix-daemon.enable = true;             # Auto-Upgrade Daemon
  };

  homebrew = {                            # Homebrew Package Manager
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      "wireguard-tools"
    ];
    casks = [
      "moonlight"
      "plex-media-player"
    ];
  };

  nix = {
    package = pkgs.nix;
    gc = {                                # Garbage Collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {                              # Global macOS System Settings
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
      };
      finder = {
        QuitMenuItem = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh''; # Set Default Shell
    stateVersion = 4;
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "22.05";
    };

    programs = {
      zsh = {                             # Shell
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        history.size = 10000;

        oh-my-zsh = {                     # Plug-ins
          enable = true;
          plugins = [ "git" ];
          custom = "$HOME/.config/zsh_nix/custom";
        };

        initExtra = ''
          # Spaceship
          source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
          autoload -U promptinit; promptinit
          pfetch
        '';                               # Theming
      };
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        plugins = with pkgs.vimPlugins; [
          # Syntax
          vim-nix
          vim-markdown

          # Quality of life
          vim-lastplace                   # Opens document where you left it
          auto-pairs                      # Print double quotes/brackets/etc.
          vim-gitgutter                   # See uncommitted changes of file :GitGutterEnable

          # File Tree
          nerdtree                        # File Manager - set in extraConfig to F6

          # Customization
          wombat256-vim                   # Color scheme for lightline
          srcery-vim                      # Color scheme for text

          lightline-vim                   # Info bar at bottom
          indent-blankline-nvim           # Indentation lines
        ];

        extraConfig = ''
          syntax enable                             " Syntax highlighting
          colorscheme srcery                        " Color scheme text

          let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ }                                     " Color scheme lightline

          highlight Comment cterm=italic gui=italic " Comments become italic
          hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

          set number                                " Set numbers

          nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree
        '';
      };
    };
  };
}
