#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │       └─ home.nix *
#   └─ ./modules
#       ├─ ./menu 
#       │   └─ default.nix
#       ├─ ./services
#       │   └─ default.nix
#       └─ ./shell
#           └─ default.nix
#

{ pkgs, ... }:

{
  imports = (import ../../modules/menu) ++ (import ../../modules/services) ++ (import ../../modules/shell);	# Importing all the different modules 

  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";

    packages = with pkgs; [
      neofetch
      polybar
    ];
  };

  programs = {
    home-manager.enable = true;
    zsh.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  xsession = {								# Session settings
    enable = true;
    numlock.enable = true;
    initExtra = ''							# Until I find a better solution, start polybar from here.
      polybar mybar &
    '';

    pointerCursor = {
      name = "Numix-Snow";
      package = pkgs.numix-cursor-theme;
    };
  };

  gtk = {								# Theming
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
