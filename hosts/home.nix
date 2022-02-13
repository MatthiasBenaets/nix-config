#
#  General Home-manager configuration
#
#  flake.nix
#   └─ ./hosts
#       ├─ ./desktop
#       │   └─ home.nix
#       └─ home.nix *
#

{ pkgs, ... }:

{ 
  imports = 								# Window Manager home config
       [(import ../modules/desktop/bspwm/home.nix)] ++
       ( import ../modules/apps) ++
       ( import ../modules/services) ++
       ( import ../modules/shell);

  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";

    packages = with pkgs; [
      pfetch
      libnotify 
      btop
      feh
      ranger
      pavucontrol
      mpv
      vlc
      qbittorrent
      obs-studio
      pcmanfm

      # General configuration
      #zsh
      #pulseaudio
      #vim
      #git
      #wget
      #pciutils
      #killall
      #
      # Imports General home-manager
      #firefox
      #alacritty
      #sxhkd
      #rofi
      #picom
      #dunst
      #polybar
      #flameshot
      #udiskie
      #
      # WM/DM
      #xorg.xkill
      #xorg.xev
      #xorg.xrandr
      #
      # Laptop
      #blueman
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    home-manager.enable = true;
    zsh.enable = true;
  };

  xsession = {                                                          # Session settings
    enable = true;
    numlock.enable = true;

    pointerCursor = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };   	
  };

  gtk = {                                                               # Theming
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "FiraCode Nerd Font Mono Medium";  
    };
  };

  home.stateVersion = "22.05";
}
