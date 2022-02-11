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
  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";

    packages = with pkgs; [
      pfetch
      libnotify # for dunst
      #dunst
      #polybar 
      btop
      feh
      ranger
      mpv
      vlc
      qbittorrent
      obs-studio

      #vim
      #git
      #wget
      #pciutils
      #xorg.xkill
      #xorg.xev
      #alacritty
      #xshkd
      #zsh
      #rofi
      #picom
      #pulseaudio
      #blueman
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    home-manager.enable = true;
    zsh.enable = true;
  };
  
  services = {                                                          # System tray services
    blueman-applet.enable = true;					  # Bluetooth
    network-manager-applet.enable = true;				  # Network
    pasystray.enable = true;						  # Sound
    udiskie = {								  # Auto mount USB
      enable = true;
      tray = "always";
    };
  };

  xsession = {                                                          # Session settings
    enable = true;
    numlock.enable = true;

    pointerCursor = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
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
