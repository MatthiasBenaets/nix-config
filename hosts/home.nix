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
      lxappearance
      neofetch
      libnotify # for dunst
      #dunst
      #polybar
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
      name = "Numix-Snow";
      package = pkgs.numix-cursor-theme;
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
      name = "Source Code Pro 11";  
    };
  };

  home.stateVersion = "22.05";
}
